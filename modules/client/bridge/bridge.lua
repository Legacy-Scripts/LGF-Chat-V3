local Core = {}
local Legacy = GetResourceState('LEGACYCORE'):find('start') and exports['LEGACYCORE']:GetCoreData() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil
local LC = GetResourceState('LGF_Core'):find('start') and exports['LGF_Core']:GetCoreData() or nil
local QBX = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

local Shared = require 'utils.utils'

function Core:LoadPlayer()
    if Legacy then
        return Legacy.DATA:IsPlayerLoaded()
    elseif ESX then
        return ESX.IsPlayerLoaded()
    elseif LC then
        return true
    elseif QBX then
        -- TriggerEvent('QBCore:Client:OnPlayerLoaded')
        return true
    end
    return false
end

function Core:GetPlayerData()
    if Legacy then
        local PlayerData = Legacy.DATA:GetPlayerObject()
        return PlayerData
    elseif ESX then
        local PlayerData = ESX.GetPlayerData()
        return PlayerData
    elseif LC then
        local PlayerData = lib.callback.await('LGF_CHAT:GetPlayerData', false)
        return PlayerData
    elseif QBX then
        local PlayerData = exports.qbx_core:GetPlayerData()
        return PlayerData
    end
end

function Core:GetPlayerName()
    if Legacy then
       return Legacy.DATA:GetPlayerObject().playerName
    elseif LC then
        local PlayerData = Core:GetPlayerData()
        if PlayerData and PlayerData.name then
            return PlayerData.name
        else
            warn('missing Name')
            return nil
        end
    elseif QBX then
        local Player = exports.qbx_core:GetPlayerData()
        local PlayerName = ("%s %s"):format(Player.charinfo.firstname, Player.charinfo.lastname)
        return PlayerName
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
    if Legacy then
        return Legacy.DATA:GetPlayerObject().JobName
    elseif ESX then
        local xPlayer = Core:GetPlayerData()
        local job = xPlayer.job.name or 'uknown'
        return job
    elseif QBX then
        local PlayerData = exports.qbx_core:GetPlayerData()
        return PlayerData.job.name
    elseif LC then
        local Job = Core:GetPlayerData().job
        print(Job)
        return Job
    else
        return warn('missing data')
    end
end

function Core:GetNotify(icon, msg, title)
    if ESX or LC or QBX or Legacy then
        lib.notify({
            title = title,
            description = msg,
            type = 'inform',
            icon = icon,
        })
    end
end

return Core
