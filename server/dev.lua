--- Function to clear all ban-related tables
--- This is useful for development purposes to reset the database
Ban.clearAllTables = function(callback)
    local tables = {
        "banned_steams",
        "banned_licenses",
        "banned_discords",
        "banned_ips",
        "banned_fivems",
        "banned_xbls",
        "banned_lives",
        "banned_tokens",
        "nebula_bans"
    }

    local clearedCount = 0
    for _, tableName in ipairs(tables) do
        MySQL.query(string.format('DELETE FROM %s', tableName), {}, function(success)
            if success then
                Logger.info(string.format("Cleared table: %s", tableName))
            else
                Logger.error(string.format("Failed to clear table: %s", tableName))
            end

            clearedCount = clearedCount + 1
            if clearedCount == #tables and callback then
                callback(true)
            end
        end)
    end
end


Ban.clearAllTables(function(success)
    if success then
        Logger.info("All ban-related tables have been cleared.")
    else
        Logger.error("Failed to clear all ban-related tables.")
    end
end)
Wait(1000) -- Wait a moment to ensure the database is ready
Ban.banPlayer(1, 2, "Testing ban function", "Admin", function(banId, success, message)
    if success then
        Logger.info("Ban ID: %s | Message: %s", banId, message)
    else
        Logger.error("Ban failed: %s", message)
    end
end)