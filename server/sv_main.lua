--- @class Ban
Ban = {}

local IDENTIFIER_TABLES = {
    steam = "banned_steams",
    license = "banned_licenses",
    discord = "banned_discords",
    ip = "banned_ips",
    fivem = "banned_fivems",
    xbl = "banned_xbls",
    live = "banned_lives"
}

local ALL_BAN_TABLES = {
    "banned_steams", "banned_licenses", "banned_discords", "banned_ips",
    "banned_fivems", "banned_xbls", "banned_lives", "banned_tokens"
}

--- Generate a secure, unique Ban ID
Ban.generateBanId = function(length)
    local randomCode = Utils.GenerateRandomCode(length)

    local result = MySQL.prepare.await("SELECT 1 FROM nebula_bans WHERE ban_id = ?", { randomCode })
    if result and #result > 0 then
        return Ban.generateBanId(length)
    end

    return randomCode
end

--- Get player identifiers
Ban.getPlayerIdentifiers = function(source)
    local rawIdentifiers = GetPlayerIdentifiers(source)
    local identifiers = {
        steam = nil,
        license = nil,
        discord = nil,
        ip = nil,
        fivem = nil,
        xbl = nil,
        live = nil,
        playerName = GetPlayerName(source),
        tokens = {}
    }

    for _, identifier in ipairs(rawIdentifiers) do
        local identifierType, value = identifier:match('^(%w+):(.+)$')
        if identifierType and value then
            if identifierType == 'steam' then
                identifiers.steam = value
            elseif identifierType == 'license' then
                identifiers.license = value
            elseif identifierType == 'discord' then
                identifiers.discord = value
            elseif identifierType == 'ip' then
                identifiers.ip = value
            elseif identifierType == 'fivem' then
                identifiers.fivem = value
            elseif identifierType == 'xbl' then
                identifiers.xbl = value
            elseif identifierType == 'live' then
                identifiers.live = value
            end
        end
    end

    for i = 0, GetNumPlayerTokens(source) - 1 do
        local token = GetPlayerToken(source, i)
        if token then
            table.insert(identifiers.tokens, token)
        end
    end

    return identifiers
end

--- Check if player is already banned
Ban.isPlayerBanned = function(identifiers, callback)
    if not identifiers or not callback then
        return callback(false, nil)
    end

    local queryConditions = {}
    local queryParams = {}

    for idType, tableName in pairs(IDENTIFIER_TABLES) do
        if identifiers[idType] then
            table.insert(queryConditions,
                string.format("EXISTS(SELECT 1 FROM %s bt WHERE bt.identifier = ? AND bt.ban_id = nb.ban_id)", tableName)
            )
            table.insert(queryParams, identifiers[idType])
        end
    end

    for _, token in ipairs(identifiers.tokens or {}) do
        table.insert(queryConditions,
            "EXISTS(SELECT 1 FROM banned_tokens bt WHERE bt.identifier = ? AND bt.ban_id = nb.ban_id)"
        )
        table.insert(queryParams, token)
    end

    if #queryConditions == 0 then
        return callback(false, nil)
    end

    local query = string.format(
        "SELECT ban_id, ban_reason, banned_by, ban_date, ban_expire FROM nebula_bans nb WHERE is_active = 1 AND (%s) LIMIT 1",
        table.concat(queryConditions, " OR ")
    )

    MySQL.query(query, queryParams, function(results)
        if results and results[1] then
            callback(true, results[1])
        else
            callback(false, nil)
        end
    end)
end

--- Insert all identifier bans
Ban.insertIdentifierBans = function(identifiers, banId, callback)
    local completed = 0
    local total = 0
    local hasError = false

    -- Count total operations
    for idType in pairs(IDENTIFIER_TABLES) do
        if identifiers[idType] then
            total = total + 1
        end
    end
    total = total + #identifiers.tokens

    if total == 0 then
        return callback(true)
    end

    local function checkComplete()
        completed = completed + 1
        if completed >= total then
            callback(not hasError)
        end
    end

    -- Insert standard identifiers
    for idType, tableName in pairs(IDENTIFIER_TABLES) do
        if identifiers[idType] then
            MySQL.insert(
                string.format("INSERT INTO %s (identifier, ban_id) VALUES (?, ?)", tableName),
                { identifiers[idType], banId },
                function(success)
                    if not success then
                        hasError = true
                    end
                    checkComplete()
                end
            )
        end
    end

    -- Insert tokens
    for _, token in ipairs(identifiers.tokens) do
        MySQL.insert(
            "INSERT INTO banned_tokens (identifier, ban_id) VALUES (?, ?)",
            { token, banId },
            function(success)
                if not success then
                    hasError = true
                end
                checkComplete()
            end
        )
    end
end

--- Insert main ban record after all identifiers are inserted
Ban.insertMainBanRecord = function(identifiers, banId, duration, reason, admin, callback)
    local currentTime = os.time()
    local expireTime = duration > 0 and (currentTime + duration * 3600) or nil

    MySQL.insert(
        "INSERT INTO nebula_bans (ban_id, player_name, ban_reason, banned_by, ban_date, ban_expire, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)",
        { banId, identifiers.playerName, reason, admin, currentTime, expireTime, 1 },
        function(insertId)
            if not insertId then
                return callback(banId, false, "Database insertion failed")
            end
            callback(banId, true, "Player banned successfully")
        end
    )
end

--- Main ban function
Ban.banPlayer = function(banData, duration, reason, admin, callback)
    if not banData or not reason or not admin or not callback then
        return callback(false, nil, "Invalid parameters")
    end

    if type(banData) == "number" then
        banData = Ban.getPlayerIdentifiers(banData)
        if not banData then
            return callback(false, nil, "Player not found")
        end
    end

    -- Check if already banned
    Ban.isPlayerBanned(banData, function(isBanned, banInfo)
        if isBanned then
            return callback(false, banInfo.ban_id, "Player is already banned")
        end

        -- Generate Ban ID
        local banId = Ban.generateBanId(nConfig.BanIdLength)
        if not banId then
            return callback(false, nil, "Failed to generate Ban ID")
        end

        -- Calculate timestamps
        local currentTime = os.time()
        local expireTime = duration > 0 and (currentTime + duration * 3600) or nil

        -- Insert main ban record first
        MySQL.insert(
            "INSERT INTO nebula_bans (ban_id, player_name, ban_reason, banned_by, ban_date, ban_expire, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)",
            { banId, banData.playerName, reason, admin, currentTime, expireTime, 1 },
            function(insertId)
                if not insertId then
                    return callback(false, banId, "Database insertion failed")
                end

                -- Insert all identifiers
                Ban.insertIdentifierBans(banData, banId, function(success)
                    if success then
                        callback(true, banId, "Player banned successfully")
                    else
                        callback(false, banId, "Failed to insert identifiers")
                    end
                end)
            end
        )
    end)
end


--- Unban player - remove from all tables
Ban.unbanPlayer = function(banId, callback)
    if not banId or type(banId) ~= "string" then
        return callback(false)
    end

    -- Remove from all identifier tables first
    local completed = 0
    local total = #ALL_BAN_TABLES

    local function checkComplete()
        completed = completed + 1
        if completed >= total then
            -- All identifiers removed, now update main ban record
            Ban.deactivateMainBan(banId, callback)
        end
    end

    for _, tableName in ipairs(ALL_BAN_TABLES) do
        MySQL.query(
            string.format("DELETE FROM %s WHERE ban_id = ?", tableName),
            { banId },
            function(affectedRows)
                checkComplete()
            end
        )
    end
end

--- Deactivate main ban record
Ban.deactivateMainBan = function(banId, callback)
    MySQL.update(
        "UPDATE nebula_bans SET is_active = 0, unban_date = ? WHERE ban_id = ?",
        { os.time(), banId },
        function(affectedRows)
            callback(affectedRows and affectedRows > 0)
        end
    )
end