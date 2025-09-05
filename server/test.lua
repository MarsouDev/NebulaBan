--- Function to clear all ban-related tables
--- This is useful for development purposes to reset the database
-- Ban.clearAllTables = function(callback)
--     local tables = {
--         "banned_steams",
--         "banned_licenses",
--         "banned_discords",
--         "banned_ips",
--         "banned_fivems",
--         "banned_xbls",
--         "banned_lives",
--         "banned_tokens",
--         "nebula_bans"
--     }

--     local clearedCount = 0
--     for _, tableName in ipairs(tables) do
--         MySQL.query(string.format('DELETE FROM %s', tableName), {}, function(success)

--             clearedCount = clearedCount + 1
--             if clearedCount == #tables and callback then
--                 callback(true)
--             end
--         end)
--     end
-- end


-- Ban.clearAllTables()
-- Wait(1999)

-- Ban.banPlayer(2, 1, 'Testing Ban', 'Admin', function(success, banId, message)
--     if success then
--         print("Ban successful! Ban ID: " .. banId)
--     else
--         print("Ban failed: " .. message)
--     end
-- end)