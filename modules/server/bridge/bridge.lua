---@diagnostic disable: need-check-nil, undefined-field
local Core = {}
local LGF = GetResourceState('LegacyFramework'):find('start') and exports['LegacyFramework']:ReturnFramework() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

local Shared = require 'utils.utils'



function Core:GetPlayerJob(player)
    if LGF then
        local Job = LGF.SvPlayerFunctions.GetJobPlayer(player)
        Shared:GetDebug(Job)
        return Job
    elseif ESX then
        local Job = ESX.GetPlayerFromId(player)?.job?.name or "unemployed"
        Shared:GetDebug(Job)
        return Job
    end
end

function Core:GetPlayerName(player)
    if LGF then
        local PlayerData = LGF.SvPlayerFunctions.GetPlayerData(player)[1]
        local PlayerName = string.format('%s %s', PlayerData.firstName, PlayerData.lastName)
        Shared:GetDebug(PlayerName)
        return PlayerName
    elseif ESX then
        local PlayerData = ESX.GetPlayerFromId(player)
        local PlayerName = PlayerData.getName()
        Shared:GetDebug(PlayerName)
        return PlayerName
    end
end

function Core:GetPlayerGroup(player)
    if LGF then
        local PlayerData = LGF.SvPlayerFunctions.GetPlayerData(player)[1]
        local Group = PlayerData?.playerGroup
        Shared:GetDebug(Group)
        return Group
    elseif ESX then
        local PlayerData = ESX.GetPlayerFromId(player)
        local Group = PlayerData.getGroup()
        Shared:GetDebug(Group)
        return Group
    end
end



function Core:SvNotification(source, msg, title, icon)
    if LGF then
        TriggerClientEvent('Legacy:AdvancedNotification', source, {
            icon = icon,
            message = msg,
            title = title,
            duration = 5,
            colorIcon = "#FFA500",
            position = 'top-right'
        })
    end
    if ESX then
        TriggerClientEvent('ox_lib:notify', source,
            {
                icon = icon,
                title = title,
                position = 'top-right',
                description = msg,
                duration = 6000
            })
    end
end

return Core
