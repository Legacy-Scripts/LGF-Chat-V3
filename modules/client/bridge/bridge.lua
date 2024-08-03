local Core = {}
local Legacy = GetResourceState('LEGACYCORE'):find('start') and exports['LEGACYCORE']:GetCoreData() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil
local QBX = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

local Shared = require 'utils.utils'

function Core:LoadPlayer()
    if Legacy then
        return Legacy.DATA:IsPlayerLoaded()
    elseif ESX then
        return ESX.IsPlayerLoaded()
    elseif QBX then
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
    elseif QBX then
        local PlayerData = exports.qbx_core:GetPlayerData()
        return PlayerData
    end
end

function Core:GetPlayerName()
    if Legacy then
        local Name = Core:GetPlayerData()?.playerName
        print(Name)
        return Name

    elseif QBX then
        local Player = exports.qbx_core:GetPlayerData()
        local PlayerName = ("%s %s"):format(Player.charinfo.firstname, Player.charinfo.lastname)
        return PlayerName
    elseif ESX then
        local xPlayer = ESX.GetPlayerData()
        local firstName = xPlayer.firstName
        local lastName = xPlayer.lastName
        if firstName and lastName then
            local playerName = string.format("%s %s", firstName, lastName)
            return playerName
        end
    else
        return GetPlayerName(cache.playerId)
    end
end

function Core:GetJobPlayer()
    if Legacy then
        return Core:GetPlayerData()?.JobName
    elseif ESX then
        local xPlayer = Core:GetPlayerData()
        local job = xPlayer.job.name or 'uknown'
        return job
    elseif QBX then
        local PlayerData = exports.qbx_core:GetPlayerData()
        return PlayerData.job.name
    else
        return warn('missing data')
    end
end

function Core:GetNotify(icon, msg, title)
    if ESX or QBX or Legacy then
        lib.notify({
            title = title,
            description = msg,
            type = 'inform',
            icon = icon,
        })
    end
end

return Core
