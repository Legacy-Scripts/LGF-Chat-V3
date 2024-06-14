---@diagnostic disable: missing-parameter

local Core = require 'modules.server.bridge.bridge'
local SharedCore = require 'utils.utils'

local Functions = {}
local adActive = false

-- OOC COMMAND
RegisterCommand(CFG.OOC, function(source, args)
    local playerId = source
    local playerName = Core:GetPlayerName(playerId)
    local typeChat = "OOC"
    local description = table.concat(args, " ")
    if args and #args > 0 then
        exports['LGF-Chat']:CreateSendMessage({
            playerId = playerId,
            message = description,
            playerJob = typeChat,
            author = playerName,
            bgColor = '#312B2B',
            icon = 'globe'
        })

        ServerFunction:SendDiscordMessage(playerId, playerName, typeChat, description)
    end
end)

-- POLICE COMMAND (Not Private)
RegisterCommand(CFG.POLICE, function(source, args)
    local PlayerJob <const> = Core:GetPlayerJob(source)
    local Text = table.concat(args, " ")
    if args and #args > 0 then
        if PlayerJob == 'police' then
            exports['LGF-Chat']:CreateSendMessage({
                playerId = source,
                message = Text,
                playerJob = PlayerJob,
                author = Core:GetPlayerName(source),
                bgColor = '#312B2B',
                icon = 'user-shield'
            })
            ServerFunction:SendDiscordMessage(source, Core:GetPlayerName(source), 'POLICE', Text)
        else
            Core:SvNotification(source, SharedCore:GetKeyTraduction("noPermissionCommand"), 'Warning', 'fa-solid fa-triangle-exclamation')
        end
    end
end)

-- AMBULANCE COMMAND (Not Private)
RegisterCommand(CFG.AMBULANCE, function(source, args)
    local PlayerJob <const> = Core:GetPlayerJob(source)
    local text = table.concat(args, " ")
    if args and #args > 0 then
        if PlayerJob == 'ambulance' then
            exports['LGF-Chat']:CreateSendMessage({
                playerId = source,
                message = text,
                playerJob = PlayerJob,
                author = Core:GetPlayerName(source),
                bgColor = '#312B2B',
                icon = 'truck-medical'
            })
            ServerFunction:SendDiscordMessage(source, Core:GetPlayerName(source), 'AMBULANCE', text)
        else
            Core:SvNotification(source, SharedCore:GetKeyTraduction("noPermissionCommand"), 'Warning', 'fa-solid fa-triangle-exclamation')
        end
    end
end)

-- CHAT ONLY STAFF COMMAND (Private)
RegisterCommand(CFG.ONLYSTAFF, function(source, args)
    local PlayerGroup <const> = Core:GetPlayerGroup(source)
    if not CFG.AdminGroup[PlayerGroup] then return end
    local PlayerName = Core:GetPlayerName(source)
    local text       = table.concat(args, " ")
    if args and #args > 0 then
        for _, playerId in pairs(GetPlayers()) do
            local AdminGroup = Core:GetPlayerGroup(playerId)
            if CFG.AdminGroup[AdminGroup] then
                TriggerClientEvent("chatMessage", playerId, PlayerName, text, source, 'PRIVATE STAFF', '#312B2B', 'user-shield')
                ServerFunction:SendDiscordMessage(source, Core:GetPlayerName(source), 'ONLY STAFF', text)
            end
        end
    end
end)

-- CHAT STAFF COMMAND (Not Private)
RegisterCommand(CFG.STAFF, function(source, args)
    local PlayerGroup <const> = Core:GetPlayerGroup(source)
    local text = table.concat(args, " ")
    if args and #args > 0 then
        if CFG.AdminGroup[PlayerGroup] then
            exports['LGF-Chat']:CreateSendMessage({
                playerId = source,
                message = text,
                playerJob = PlayerGroup,
                author = Core:GetPlayerName(source),
                bgColor = '#312B2B',
                icon = 'eye'
            })
            ServerFunction:SendDiscordMessage(source, Core:GetPlayerName(source), 'STAFF', text)
        else
            Core:SvNotification(source, SharedCore:GetKeyTraduction("noPermissionCommand"), 'Warning', 'fa-solid fa-triangle-exclamation')
        end
    end
end)

-- PROMOTION CHAT
RegisterCommand(CFG.AD, function(source, args)
    if adActive then
        Core:SvNotification(source, SharedCore:GetKeyTraduction("adAlreadyActive"), 'Warning', 'fa-solid fa-triangle-exclamation')
        return
    end

    local PlayerJob <const> = Core:GetPlayerJob(source)
    local text = table.concat(args, " ")
    local adInterval <const> = 30
    local adDuration <const> = 1
    local adRepeats <const> = adDuration * 60 / adInterval

    if text == nil or text == '' then
        Core:SvNotification(source, SharedCore:GetKeyTraduction("adNeedMessage"), 'Error', 'fa-solid fa-triangle-exclamation')
        return
    end

    adActive = true

    function Functions:sendAd()
        exports['LGF-Chat']:CreateSendMessage({
            message = text,
            playerJob = PlayerJob,
            author = 'ADVERTISEMENT',
            bgColor = '#312B2B',
            icon = 'bell'
        })
    end

    Functions:sendAd()

    for i = 1, adRepeats - 1 do
        SetTimeout(i * adInterval * 1000, function()
            Functions:sendAd()
        end)
    end

    SetTimeout(adDuration * 60 * 1000, function()
        adActive = false
        Core:SvNotification(source, SharedCore:GetKeyTraduction("adFinished"), 'Success', 'fa-solid fa-check')
    end)

    Core:SvNotification(source, SharedCore:GetKeyTraduction("adScheduled"), 'Success', 'fa-solid fa-check')
end)
