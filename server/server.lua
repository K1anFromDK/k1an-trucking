local vRP = exports.vrp.getObject() -- ændre denne til jeres egen måde at import vrp på.

lib.callback.register('lastbiljob:rewardworker', function(source, v)
    if not v then return end
    local user = vRP.getUserId(source)
    if user then
        local reward = math.random(Config.Rewards.min, Config.Rewards.max)
        vRP.giveBankMoney(user, reward)
        return reward
    end
    return false
end)