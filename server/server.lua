---@param source number
---@return number | false
lib.callback.register('lastbiljob:rewardworker', function(source, v)
    if not v or not source then return end
    local pedCoords, playerCoords = v.npcxyz, GetEntityCoords(GetPlayerPed(source))
    local distance = #(pedCoords - playerCoords)
    if distance > 2.0 then
        return false
    end
    local user = framework.playerId(source)
    if user then
        local reward = math.random(Config.Rewards.min, Config.Rewards.max)
        framework.addMoney(user, reward)
        return reward
    end
    return false
end)