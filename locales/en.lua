Locales = Locales or {}
Locales['en'] = {
    -- Ban system messages
    ["ban_success"] = "^2Player ^7%s ^2has been banned with Ban ID: ^7%s",
    ["ban_failed"] = "^1Failed to ban player: ^7%s",
    ["ban_already_banned"] = "^3Player is already banned with Ban ID: ^7%s",
    ["ban_player_not_found"] = "^1Player not found",
    ["ban_invalid_duration"] = "^1Invalid ban duration. Use numbers (hours) or 0 for permanent",
    
    -- Unban system messages
    ["unban_success"] = "^2Ban ID ^7%s ^2has been successfully removed",
    ["unban_failed"] = "^1Failed to unban Ban ID: ^7%s",
    ["unban_not_found"] = "^1Ban ID ^7%s ^1not found or already inactive",
    
    -- Check ban messages
    ["check_banned"] = "^1Player is banned:\n^7Reason: %s\n^7Banned by: %s\n^7Ban ID: %s\n^7Date: %s",
    ["check_not_banned"] = "^2Player is not banned",
    ["check_permanent"] = "Permanent",
    ["check_expires"] = "Expires: %s",
    
    -- Command usage
    ["usage_ban"] = "^3Usage: ^7/%s [player_id] [duration_hours] [reason]",
    ["usage_unban"] = "^3Usage: ^7/%s [ban_id]",
    ["usage_checkban"] = "^3Usage: ^7/%s [player_id]",
    
    -- General messages
    ["no_permission"] = "^1You don't have permission to use this command",
    ["invalid_player"] = "^1Invalid player ID",
    ["command_error"] = "^1An error occurred while executing the command"
}