--- NebulaBan Commands System
--- All chat commands for ban management

--- Helper function to format date
local function formatDate(timestamp)
    if not timestamp then
        return _U("check_permanent")
    end
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

--- Helper function to get player name safely
local function getPlayerNameSafe(source)
    local name = GetPlayerName(source)
    return name or "Unknown"
end

--- /ban command
RegisterCommand(nConfig.Commands.Ban, function(source, args, rawCommand)
    if #args < 3 then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 255, 0 },
            args = { "NebulaBan", _U("usage_ban", nConfig.Commands.Ban) }
        })
        return
    end

    local targetId = tonumber(args[1])
    local duration = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "NebulaBan", _U("invalid_player") }
        })
        return
    end

    if not duration or duration < 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "NebulaBan", _U("ban_invalid_duration") }
        })
        return
    end

    local adminName = getPlayerNameSafe(source)

    Ban.banPlayer(targetId, duration, reason, adminName, function(banId, success, message)
        if success then
            local playerName = getPlayerNameSafe(targetId)
            
            TriggerClientEvent('chat:addMessage', source, {
                color = { 0, 255, 0 },
                args = { "NebulaBan", _U("ban_success", playerName, banId) }
            })
            
            DropPlayer(targetId, string.format("You have been banned.\nReason: %s\nBan ID: %s\nBanned by: %s", reason, banId, adminName))
        else
            if message == "Player is already banned" then
                TriggerClientEvent('chat:addMessage', source, {
                    color = { 255, 165, 0 },
                    args = { "NebulaBan", _U("ban_already_banned", banId or "Unknown") }
                })
            else
                TriggerClientEvent('chat:addMessage', source, {
                    color = { 255, 0, 0 },
                    args = { "NebulaBan", _U("ban_failed", message) }
                })
            end
        end
    end)
end, false)

--- /unban command
RegisterCommand(nConfig.Commands.Unban, function(source, args, rawCommand)
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 255, 0 },
            args = { "NebulaBan", _U("usage_unban", nConfig.Commands.Unban) }
        })
        return
    end

    local banId = args[1]

    Ban.unbanPlayer(banId, function(success)
        if success then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 0, 255, 0 },
                args = { "NebulaBan", _U("unban_success", banId) }
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                args = { "NebulaBan", _U("unban_not_found", banId) }
            })
        end
    end)
end, false)

--- /checkban command
RegisterCommand(nConfig.Commands.CheckBan, function(source, args, rawCommand)
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 255, 0 },
            args = { "NebulaBan", _U("usage_checkban", nConfig.Commands.CheckBan) }
        })
        return
    end

    local targetId = tonumber(args[1])
    
    if not targetId or not GetPlayerName(targetId) then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "NebulaBan", _U("invalid_player") }
        })
        return
    end

    local identifiers = Ban.getPlayerIdentifiers(targetId)
    if not identifiers then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "NebulaBan", _U("ban_player_not_found") }
        })
        return
    end

    Ban.isPlayerBanned(identifiers, function(isBanned, banInfo)
        if isBanned then
            local banDate = formatDate(banInfo.ban_date)
            local expireInfo = banInfo.ban_expire and _U("check_expires", formatDate(banInfo.ban_expire)) or _U("check_permanent")
            
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "NebulaBan", _U("check_banned", banInfo.ban_reason, banInfo.banned_by, banInfo.ban_id, banDate) .. "\n" .. expireInfo }
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = { 0, 255, 0 },
                args = { "NebulaBan", _U("check_not_banned") }
            })
        end
    end)
end, false)

--- Console logging for server events
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    deferrals.defer()
    
    Wait(100)
    
    local identifiers = Ban.getPlayerIdentifiers(source)
    if not identifiers then
        deferrals.done()
        return
    end

    Ban.isPlayerBanned(identifiers, function(isBanned, banInfo)
        if isBanned then
            local reason = string.format(
                "You are banned from this server.\nReason: %s\nBan ID: %s\nBanned by: %s\nBan date: %s",
                banInfo.ban_reason,
                banInfo.ban_id,
                banInfo.banned_by,
                formatDate(banInfo.ban_date)
            )
            
            if banInfo.ban_expire then
                reason = reason .. "\nExpires: " .. formatDate(banInfo.ban_expire)
            else
                reason = reason .. "\nPermanent ban"
            end
            
            deferrals.done(reason)
        else
            deferrals.done()
        end
    end)
end)

