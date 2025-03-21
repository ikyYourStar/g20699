---
--- Generated by PluginCreator
--- scene_object handler
--- DateTime:2023-03-23
---

local handles = T(Player, "PackageHandlers")
---@type LuaTimer
local LuaTimer = T(Lib, "LuaTimer")
--function handles:Xxxxx(packet)
--end

local timers = {}

--- 停止播放
---@param instanceId any
local stopPlayActor = function(instanceId)
    if timers[instanceId] then
        LuaTimer:cancel(timers[instanceId])
        timers[instanceId] = nil
    end
end

--- 播放动画
---@param instance Instance
---@param actionName any
local playActor = function(instance, actionName, actionTime, callback)
    if not instance:isValid() then
        return
    end
    ---@type ActorNode
    local actorNode = nil
    local childCount = instance:getChildrenCount()
    if childCount > 0 then
        actorNode = instance:getChildAt(0)
    end
    if not actorNode then
        return
    end

    local instanceId = actorNode:getInstanceID()
    local ticker = math.ceil((actionTime or 0.8) * 20)
    
    local isActorInited = actorNode:isActorInited()
    if isActorInited then
        actorNode:playSkill(actionName)
    end

    LuaTimer:scheduleTicker(function()
        if not instance:isValid() then
            stopPlayActor(instanceId)
            return
        end
        if isActorInited then
            ticker = ticker - 1
            if ticker <= 0 then
                stopPlayActor(instanceId)
                if callback then
                    callback(actorNode)
                end
            end
        else
            --- 播放动画
            if actorNode:isActorInited() then
                isActorInited = true
                actorNode:playSkill(actionName)
            end
        end    
    end, 1)
end

--- 打开宝箱
---@param packet any
function handles:S2CTreasureBoxOpen(packet)
    local instanceId = packet.instanceId
    local objId = packet.objId
    
    --- 特殊处理
    ---@type Instance
    local instance = Instance.getByInstanceId(instanceId)
    if instance and instance:isValid() then
        instance.isVisible = false
        -- stopPlayActor(instanceId)
        -- playActor(instance, "g2065_model_equip_box_01", 2, function(actorNode)
            
        -- end)
    end
end

--- 宝箱复活
---@param packet any
function handles:S2CTreasureBoxReborn(packet)
    local instanceIds = packet.ids
    for _, instanceId in pairs(instanceIds) do
        stopPlayActor(instanceId)
        --- 特殊处理
        ---@type Instance
        local instance = Instance.getByInstanceId(instanceId)
        if instance and instance:isValid() then
            --- 处理表现
            instance.isVisible = true
        end
    end
end

--- 场景物品破坏
---@param packet any
function handles:S2CSceneObjectBroken(packet)
    local instanceId = packet.instanceId
    local objId = packet.objId
    
    --- 特殊处理
    ---@type Instance
    local instance = Instance.getByInstanceId(instanceId)
    if instance and instance:isValid() then
        stopPlayActor(instanceId)
        playActor(instance, "g2065_model_equip_box_01", 2, function(actorNode)
            
        end)
    end
end

--- 场景破坏道具复活
---@param packet any
function handles:S2CBrokenObjectReborn(packet)
    local instanceIds = packet.ids
    for _, instanceId in pairs(instanceIds) do
        stopPlayActor(instanceId)
        --- 特殊处理
        ---@type Instance
        local instance = Instance.getByInstanceId(instanceId)
        if instance and instance:isValid() then
            --- 处理表现
        end
    end
end