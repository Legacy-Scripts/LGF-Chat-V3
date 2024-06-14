SharedCore = {}

function SharedCore:GetDebug(...)
    local enableDebug = GetConvar("LGF_Chat:Debugging", "false")
    local args = { ... }
    if enableDebug == "true" then
        for i, arg in ipairs(args) do
            if type(arg) == 'table' then
                args[i] = json.encode(arg, { sort_keys = true, indent = true })
            else
                args[i] = '^0' .. tostring(arg)
            end
        end

        local formattedMessage = '^5[DEBUG] ^7' .. table.concat(args, '\t')
        print(formattedMessage)
    end
end

function SharedCore:GetKeyTraduction(key)
    local Language = GetConvar("LGF_Chat:Translate", "en")
    local File = LoadResourceFile(cache.resource, ("utils/locales/%s.json"):format(Language))

    if not File then
        warn("Defined Language does not exist in locales/*.json please inform server owner.")
        File = LoadResourceFile(cache.resource, "utils/en.json")
    end

    local locales = json.decode(File)
    return locales[key] or ("[MISSING TRANSLATION: %s]"):format(key)
end

return SharedCore
