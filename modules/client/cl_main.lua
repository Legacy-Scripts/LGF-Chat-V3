---@diagnostic disable: missing-parameter
Functions = {}

local Shared = require 'utils.utils'
local Core = require 'modules.client.bridge.bridge'
local States = LocalPlayer.state
local suggs = {}
States.Chat = false



function Functions:OpenMainChat()
    Shared:GetDebug('Open Chat')
    SetPauseMenuActive(false)
    SendNUIMessage({
        action = "showChatMain",
        playerData = {
            playerId = cache.serverId,
            playerName = Core:GetPlayerName(),
            playerJob = Core:GetJobPlayer()
        }
    })
    SetNuiFocus(true, true)
    States.Chat = true
end

function Functions:AddMessage(Message)
    SendNUIMessage({
        action = "addMessage",
        Message = {
            content = Message.content
        },
        playerData = {
            playerId = cache.serverId,
            playerName = Message.author,
            playerJob = Core:GetJobPlayer()
        }
    })
end

function Functions:RefreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        local suggestions = {}
        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(("command.%s"):format(command.name)) and command.name ~= "openChat" and not suggs["/" .. command.name] then
                table.insert(suggestions, { name = "/" .. command.name, help = "" })
            end
        end

        TriggerEvent("chat:addSuggestions", suggestions)
    end
end

function Functions:CloseChat()
    Shared:GetDebug('Close Chat')
    SetPauseMenuActive(true)
    States.Chat = false
    SetNuiFocus(false, false)
end

function Functions:OpenOn()
    return not States.invOpen
        and not IsPauseMenuActive()
end

lib.addKeybind({
    name = 'chat_lgf',
    description = 'open chat',
    defaultKey = CFG.CommandOpenChat,
    onPressed = function(self)
        if Functions:OpenOn() and Core:LoadPlayer() then
            Functions:OpenMainChat()
        end
    end,
})

RegisterCommand('clearchat', function()
    Shared:GetDebug('Clear Chat')
    Core:GetNotify("fa-solid fa-info-circle", 'Chat Cleared Succesfully', 'LGF CHAT')
    Functions:ClearChat()
end)

CreateThread(function()
    DisableMultiplayerChat(false)
    SetTextChatEnabled(false)
end)
