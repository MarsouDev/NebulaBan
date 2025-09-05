nConfig = {
    Locale = 'en', -- Available languages: 'en', 'fr'
    ResourceName = 'NebulaBan',
    BanIdLength = 8,
    
    Commands = {
        Ban = 'ban',
        Unban = 'unban',
        CheckBan = 'checkban',
    },
}

Locales = Locales or {}
function _U(str, ...)
    if Locales[nConfig.Locale] and Locales[nConfig.Locale][str] then
        return string.format(Locales[nConfig.Locale][str], ...)
    else
        return str
    end
end