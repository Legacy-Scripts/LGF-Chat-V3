local Core = require 'modules.client.bridge.bridge'
local PlaySound = PlaySound
local EnableSystemPrint = CFG.EnableSystemPrint
local Waiting = Citizen.Wait

AddEventHandler("onClientResourceStart", function(resName)
    Waiting(500)
    Functions:RefreshCommands()
end)

AddEventHandler("onClientResourceStop", function(resName)
    Waiting(500)
    Functions:RefreshCommands()
end)

RegisterNUICallback("closeChat", function(data, cb)
    Functions:CloseChat()
end)

RegisterNetEvent("chat:addSuggestions", function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({ action = "addSugestion", suggestion = suggestion })
    end
end)


RegisterNUICallback("sendMessage", function(data, cb)
    local message = data.message
    if message:sub(1, 1) == "/" then
        return ExecuteCommand(data.message:sub(2))
    end
    TriggerServerEvent("_chat:messageEntered", message, Core:GetJobPlayer())
    Functions:CloseChat()
    cb()
end)


RegisterNetEvent("__cfx_internal:serverPrint")
AddEventHandler("__cfx_internal:serverPrint", function(msg)
    if EnableSystemPrint then
        SendNUIMessage({
            action = "ConsolePrint",
            Message = {
                content = msg
            },
        })
    end
end)

RegisterNetEvent("chatMessage")
AddEventHandler("chatMessage", function(author, message, playerId, playerJob, bgcolor, icon)
    if CFG.EnableSoundMessage then
        PlaySound(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 0, 0, 1)
    end
    SendNUIMessage({
        action = 'sendMessage',
        message = message,
        author = author,
        playerId = playerId,
        playerJob = playerJob,
        bgcolor = bgcolor or '#312B2B',
        icon = icon or 'comments'
    })
end)



function Functions:ClearChat()
    SendNUIMessage({
        action = "clearChat"
    })
end

RegisterNetEvent('LGF_Chat:ClearChat', Functions.ClearChat)
