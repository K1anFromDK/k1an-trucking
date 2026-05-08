local framework = require 'bridge.init'

if Config.Framework == 'vrp' then
    if exports.vrp.getObject() then
        framework.getBase = exports.vrp.getObject()
    else
        local Proxy = module("vrp", "lib/Proxy")
        framework.getBase = Proxy.getInterface("vRP")
    end

    ---@param source number
    ---@return number
    framework.playerId = function(source)
        return framework.getBase.getUserId(source)
    end

    ---@param playerId number
    ---@param amount number
    framework.addMoney = function(playerId, amount)
        local oldMoney = framework.getBase.getMoney(playerId)
        framework.getBase.giveBankMoney(playerId, amount)
        Wait(100)
        local newMoney = framework.getBase.getMoney(playerId)
        if not oldMoney == newMoney then
            return true
        end
        return false
    end
end