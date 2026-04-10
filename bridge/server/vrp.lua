if Config.Framework == 'vrp' then
    local framework = {}


    framework.getBase = exports.vrp.getObject()

    ---@param source number
    ---@return number
    framework.playerId = function(source)
        return framework.getBase.getUserId(source)
    end

    ---@param playerId number
    ---@param amount number
    framework.addMoney = function(playerId, amount)
        return framework.getBase.giveBankMoney(playerId, amount)
    end
end
