local Core = require 'modules.server.bridge.bridge'
ServerFunction = {}

if not lib.checkDependency('ox_lib', '3.21.0', true) then
    return warn('Download Latest versions for a safe approach')
end


RegisterServerEvent('LGF_Chat:ClearChat', function()
    TriggerClientEvent('LGF_Chat:ClearChat', -1)
    CancelEvent()
end)

AddEventHandler('playerJoining', function()
    if CFG.PlayerName == 'rp' then
        TriggerClientEvent('chatMessage', -1, 'System', Core:GetPlayerName(source) .. ' joined.')
    elseif CFG.PlayerName == 'steam' then
        TriggerClientEvent('chatMessage', -1, 'System', GetPlayerName(source) .. ' joined.')
    end
end)

RegisterServerEvent("_chat:messageEntered", function(message, playerJob)
    local source = source
    local author
    if CFG.PlayerName == 'rp' then
        author = Core:GetPlayerName(source)
    elseif CFG.PlayerName == 'steam' then
        author = GetPlayerName(source)
    end
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author, message, source, playerJob)
    end
end)

RegisterNetEvent("LGF_Chat:SendAutoMessage")
AddEventHandler("LGF_Chat:SendAutoMessage", function(data)
    TriggerClientEvent("chatMessage", -1, data.author, data.message, data.playerId, data.playerJob, data.bgColor, data.icon)
end)

RegisterNetEvent("LGF_Chat:CreateSendMessage")
AddEventHandler("LGF_Chat:CreateSendMessage", function(data)
    TriggerClientEvent("chatMessage", -1, data.author, data.message, data.playerId, data.playerJob, data.bgColor, data.icon)
end)

function CreateSendMessage(data)
    TriggerEvent("LGF_Chat:CreateSendMessage", data)
end

function SendAutoMessage(data)
    TriggerEvent("LGF_Chat:SendAutoMessage", data)
end

exports('CreateSendMessage', CreateSendMessage)
exports('SendAutoMessage', SendAutoMessage)

CreateThread(function()
    while true do
        for _, data in ipairs(CFG.AutoMessageData) do
            SendAutoMessage({
                message = data.message,
                author = data.author,
                bgColor = data.bgColor,
                icon = data.icon,
                playerJob = 'Automate Message',
            })
            Wait(data.time * 1000)
        end
    end
end)

function ServerFunction:SendDiscordMessage(playerId, playerName, typeChat, description)
    local webhookUrl = CFG.Webhook.URL
    if webhookUrl == '' then return end
    local Logo = CFG.Webhook.ImageURL or nil
    local embed = {
        title = "New Chat Message",
        color = 16711680,
        description = string.format([[
            **Player Name:** %s
            **Player ID:** %s
            **Chat Type:** %s
            **Description:** %s
        ]], playerName, tostring(playerId), typeChat, description),
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        footer = {
            text = "Chat Log System",
            icon_url = Logo
        },
        thumbnail = {
            url = Logo
        },
        author = {
            name = "Server Log",
            icon_url = Logo
        }
    }

    local data = {
        username = "Chat Logger",
        embeds = { embed },
        avatar_url = Logo
    }

    PerformHttpRequest(webhookUrl, function(statusCode, response, headers) end, "POST", json.encode(data), { ["Content-Type"] = "application/json" })
end

return ServerFunction
