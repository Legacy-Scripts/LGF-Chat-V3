local Core = {}
local LGF = GetResourceState('LegacyFramework'):find('start') and exports['LegacyFramework']:ReturnFramework() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil
local LC = GetResourceState('LGF_Core'):find('start') and exports['LGF_Core']:GetCoreData() or nil
local Shared = require 'utils.utils'


function Core:LoadPlayer()
    if LGF then
        return LGF.PlayerFunctions.PlayerLoaded()
    elseif ESX then
        return ESX.IsPlayerLoaded()
    elseif LC then
        return true
    end
    return false
end

function Core:GetPlayerData()
    if LGF then
        local PlayerData = LGF.PlayerFunctions.GetClientData()[1]
        return PlayerData
    elseif ESX then
        local PlayerData = ESX.GetPlayerData()
        return PlayerData
    elseif LC then
        local PlayerData = lib.callback.await('LGF_CHAT:GetPlayerData', false)
        return PlayerData
    end
end

function Core:GetPlayerName()
    if LGF then
        local PlayerData = Core:GetPlayerData()
        if PlayerData and PlayerData.firstName and PlayerData.lastName then
            local playerName = string.format("%s %s", PlayerData.firstName, PlayerData.lastName)
            return playerName
        else
            warn('missing Name')
            return nil
        end
    elseif LC then
        local PlayerData = Core:GetPlayerData()
        if PlayerData and PlayerData.name then
            return PlayerData.name
        else
            warn('missing Name')
            return nil
        end
    elseif ESX then
        local PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.name then
            return PlayerData.name
        else
            warn('missing Name')
            return nil
        end
    else
        return GetPlayerName(cache.playerId)
    end
end

function Core:GetJobPlayer()
    if LGF then
        local PlayerData = Core:GetPlayerData()
        local job = PlayerData?.nameJob
        return job
    elseif ESX then
        local xPlayer = Core:GetPlayerData()
        local job = xPlayer.job.name or 'uknown'
        return job
    elseif LC then
        local Job = Core:GetPlayerData().job
        print(Job)
        return Job
    else
        return warn('missing data')
    end
end

function Core:GetNotify(icon, msg, title)
    if LGF then
        LGF.Utils.AdvancedNotify({
            icon = icon,
            colorIcon = "#FFA500",
            message = msg,
            title = title,
            position = "top-right",
            bgColor = "#000000",
            duration = 6
        })
    elseif ESX or LC then
        lib.notify({
            title = title,
            description = msg,
            type = 'inform',
            icon = icon,
        })
    end
end

return Core
