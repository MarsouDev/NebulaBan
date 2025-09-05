lib.locale()
Ban = {}

--- Generates a unique, robust and well-formatted ban ID
--- @param length number Length of the ban ID to generate
--- @return string The unique ban ID generated
Ban.generateBanId = function(length)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local function buildId(len)
        local id = ''
        for i = 1, len do
            local randomIndex = math.random(1, #chars)
            id = id .. chars:sub(randomIndex, randomIndex)
        end
        return id
    end

    local banId = buildId(length)
    local exists = MySQL.prepare.await('SELECT EXISTS(SELECT 1 FROM nebula_bans WHERE ban_id = ?) AS uniqueCheck', { banId })
    if exists == 0 then
        Logger.debug(locale('ban_id_generated', banId))
        return banId
    else
        return Ban.generateBanId(length)
    end
end

--- Retrieves all identifiers of a player in a clean and structured way
--- @param source number The player's source
--- @return table Table containing all the player's identifiers
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
    

--- Function to ban a player (with source or identifiers)
--- @param banData number|table The player's source or identifiers table
--- @param duration number Duration of the ban in hours (0 for permanent)
--- @param reason string Reason for the ban
--- @param admin string Information about the administrator issuing the ban
--- @param callback function Callback function to handle the result
Ban.banPlayer = function(banData, duration, reason, admin, callback)
    if type(banData) == "number" then
        banData = Ban.getPlayerIdentifiers(banData)
    end

    local banId = Ban.generateBanId(nConfig.banIdLength or 8)
    local currentTime = os.time()
    local expireTime = duration > 0 and (currentTime + (duration * 3600)) or nil

    MySQL.insert('INSERT INTO nebula_bans (ban_id, player_name, ban_reason, banned_by, ban_date, ban_expire, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        banId, banData.playerName, reason, admin, currentTime, expireTime, 1
    }, function(success)
        callback(banId, success, success and "Player banned successfully." or "Failed to ban player.")
        if success then
            Logger.info(locale('ban_success', banData.playerName, tostring(duration), reason, banId))

            local identifierTables = {
                steam = "banned_steams",
                license = "banned_licenses",
                discord = "banned_discords",
                ip = "banned_ips",
                fivem = "banned_fivems",
                xbl = "banned_xbls",
                live = "banned_lives"
            }

            for idType, tableName in pairs(identifierTables) do
                if banData[idType] then
                    MySQL.insert(string.format('INSERT INTO %s (identifier, ban_id) VALUES (?, ?)', tableName), {
                        banData[idType], banId
                    }, function(insertSuccess)
                        if not insertSuccess then
                            Logger.error(locale('ban_failed_ids', idType, tableName, banId))
                        end
                    end)
                end
            end

            for _, token in ipairs(banData.tokens) do
                MySQL.insert('INSERT INTO banned_tokens (identifier, ban_id) VALUES (?, ?)', {
                    token, banId
                }, function(insertSuccess)
                    if not insertSuccess then
                        Logger.error(locale('ban_failed_tokens', token, "banned_tokens", banId))
                    end
                end)
            end
        end
    end)
end