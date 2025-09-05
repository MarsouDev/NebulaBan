nConfig = {

    Locale = 'en', -- Available languages: 'en', 'fr', 'de', 'es', 'it', 'pt', 'ru', 'cn', 'jp'

    ResourceName = 'NebulaBan', -- Resource name (change if the folder has been renamed)
    BanIdLength = 8,           -- Length of the generated Ban ID (used for the unban command)

    Commands = {
        Ban = 'ban',            -- Ban a player (/ban [ID] [time] [reason])
        Unban = 'unban',        -- Unban a player using their BanID (/unban [BanID])
        CheckBan = 'checkban',  -- Check if a player is banned (/checkban [ID])
    },

}