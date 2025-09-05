Utils = {}

--- Generates a random alphanumeric code with mixed uppercase letters and numbers
--- Ensures at least 3 letters and 3 numbers for maximum randomness
--- @param length number The desired length of the code (minimum 6)
--- @return string The generated random code
Utils.GenerateRandomCode = function(length)
    if type(length) ~= "number" or length < 6 then
        length = 8
    end

    math.randomseed(os.clock() * 1000000 + os.time())
    for _ = 1, 3 do math.random() end

    local LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local DIGITS = "0123456789"
    local ALL_CHARS = LETTERS .. DIGITS

    local minLetters = math.max(3, math.floor(length * 0.4))
    local minDigits = math.max(3, math.floor(length * 0.4))

    local chars = {}
    for i = 1, minLetters do
        local randIndex = math.random(1, #LETTERS)
        chars[#chars + 1] = LETTERS:sub(randIndex, randIndex)
    end

    for i = 1, minDigits do
        local randIndex = math.random(1, #DIGITS)
        chars[#chars + 1] = DIGITS:sub(randIndex, randIndex)
    end

    for i = #chars + 1, length do
        local randIndex = math.random(1, #ALL_CHARS)
        chars[i] = ALL_CHARS:sub(randIndex, randIndex)
    end
    for shuffle = 1, 3 do
        for i = #chars, 2, -1 do
            local j = math.random(1, i)
            chars[i], chars[j] = chars[j], chars[i]
        end
    end

    return table.concat(chars)
end

--- Function to print debug messages
--- @param msg string The debug message
--- @param ... any Additional arguments to format into the message
--- @return nil
Utils.Debug = function(msg, ...)
    local resourceName = "^0[^6" .. nConfig.ResourceName .. "^0]"
    local debugPrefix = "^0[^6DEBUG^0]"
    local formattedMsg = string.format(msg, ...)
    print(("%s %s %s^0"):format(resourceName, debugPrefix, formattedMsg))
end
