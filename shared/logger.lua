local resourceName = "^0[^6NebulaBan^0]"

local LogLevels = {
    DEBUG = { prefix = "^0[^6DEBUG^0]", color = "^6" },
    INFO  = { prefix = "^0[^4INFO^0]",  color = "^4" },
    ERROR = { prefix = "^0[^1ERROR^0]", color = "^1" },
}

-- Function to log messages with different levels
local function log(level, msg, ...)
    local config = LogLevels[level]
    if not config then
        error("Unknown log level: " .. tostring(level))
        return
    end

    local formattedMsg = string.format(msg, ...)
    print(("%s %s %s^0"):format(resourceName, config.color .. config.prefix .. '^0', formattedMsg))
end

Logger = {}

function Logger.debug(msg, ...)
    log("DEBUG", msg, ...)
end

function Logger.info(msg, ...)
    log("INFO", msg, ...)
end

function Logger.error(msg, ...)
    log("ERROR", msg, ...)
end