---
--- Generated by PluginCreator
--- npc_system entity_common
--- DateTime:2023-03-29
---

local ValueDef = T(Entity, "ValueDef")
-- key				            = {isCpp,	client,	toSelf,	toOther,	init,	               saveDB}
--ValueDef.xxx 					= {false,   false,  true,   false,      0,                      true}
local Entity = Entity

ValueDef.dialogRecord 		 = {false,   true,  true,   false, {},                      true}
ValueDef.dialogDrawTime 		 = {false,   false,  true,   false, {},                      true}
ValueDef.dialogDrawCounts 		 = {false,   false,  true,   false, {},                      true}
ValueDef.dialogTotalDrawCounts 		 = {false,   false,  true,   false, {},                      true}
ValueDef.dialogDayDrawCounts 		 = {false,   false,  true,   false, {},                      true}
ValueDef.dialogFreeDrawTime 		 = {false,   false,  true,   false, 0,                      true} -- 上次VIP特权抽奖的时间

function Entity:setDialogFreeDrawTime(value)
    self:setValue("dialogFreeDrawTime", value)
end

function Entity:getDialogFreeDrawTime()
    return self:getValue("dialogFreeDrawTime") or 0
end

function Entity:setDialogDayDrawCounts(value)
    self:setValue("dialogDayDrawCounts", value)
end

function Entity:getDialogDayDrawCounts()
    return self:getValue("dialogDayDrawCounts") or {}
end

function Entity:setDialogTotalDrawCounts(value)
    self:setValue("dialogTotalDrawCounts", value)
end

function Entity:getDialogTotalDrawCounts()
    return self:getValue("dialogTotalDrawCounts") or {}
end

function Entity:setDialogDrawCounts(value)
    self:setValue("dialogDrawCounts", value)
end

function Entity:getDialogDrawCounts()
    return self:getValue("dialogDrawCounts") or {}
end

function Entity:setDialogDrawTime(value)
    self:setValue("dialogDrawTime", value)
end

function Entity:getDialogDrawTime()
    return self:getValue("dialogDrawTime") or {}
end

function Entity:setDialogRecord(value)
    self:setValue("dialogRecord", value)
end

function Entity:getDialogRecord()
    return self:getValue("dialogRecord") or {}
end

function Entity:getOneDialogRecord(npcId, dialogId)
    local dialogRecord = self:getDialogRecord()
    if not dialogRecord[npcId] then
        return 0
    end
    if not dialogRecord[npcId][dialogId] then
        return 0
    end
    return dialogRecord[npcId][dialogId]
end

function Entity:isNPC()
    if self:cfg().isNPC then
        return true
    end
    return false
end

-- 当前是否可以免费抽奖
function Entity:isCanUseFreeLuckyDraw()
    if World.isClient then
        local engine_version = EngineVersionSetting:getEngineVersion()
        if engine_version < 20083 then
            return false
        end
    end
    local subscribeVipStage = self:getSubscribeVipStage()
    if subscribeVipStage == Define.SubscribeVIPStage.Height then
        local dialogFreeDrawTime = self:getDialogFreeDrawTime()
        if dialogFreeDrawTime == 0 then
            return true
        end
        if Lib.isSameDay(dialogFreeDrawTime, os.time()) then
            return false
        end
        return true
    end
    return false
end