---
--- Generated by PluginCreator
--- game_role_common entity_func
--- DateTime:2023-03-03
---

local Entity = Entity
local ValueFunc = T(Entity, "ValueFunc")
--function Entity.ValueFunc:xxx(value)
--    Lib.emitEvent(Event.xxx,1,value)
--end

function Entity.ValueFunc:curHp(value)
    self.curHp = value
    --- 只有自己才派发事件
    if Me and Me.objID == self.objID then
        Lib.emitEvent(Event.EVENT_GAME_ROLE_COMMON_UPDATE_CURRENT_HP, value)
    end
    if self:isMonster() then
        Lib.emitEvent(Event.EVENT_GAME_ROLE_COMMON_UPDATE_MONSTER_HP, self.objID, value)

        --- 副本怪物，触发对话
        if self:isMissionMonster() then
            self:checkTriggerMissionDialog()
        end
    end
end

function Entity.ValueFunc:curMp(value)
    --- 只有自己才派发事件
    if Me and Me.objID == self.objID then
        Lib.emitEvent(Event.EVENT_GAME_ROLE_COMMON_UPDATE_CURRENT_MP, value)
    end
end

function Entity.ValueFunc:curLv(value)
    --self:setHeadText(0, -1, "LV." .. value)
    self:updateShowName()
end

function Entity.ValueFunc:dangerValue(value, oldValue)
    if Me and Me.objID == self.objID then
        if not Me.isFirstLoginDanger then
            Me.isFirstLoginDanger = true
            return
        end
        local oldValue = oldValue or 0
        if oldValue > value then
            local content = Lang:toText({"g2069_danger_sub_tips", oldValue - value})
            Plugins.CallTargetPluginFunc("fly_new_tips", "pushFlyNewTipsText", content)
        elseif oldValue < value then
            local content = Lang:toText({"g2069_danger_add_tips", value - oldValue})
            Plugins.CallTargetPluginFunc("fly_new_tips", "pushFlyNewTipsText", content)
        end
    end
end