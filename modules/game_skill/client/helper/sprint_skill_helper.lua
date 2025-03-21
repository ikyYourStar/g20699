---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/3/9 16:17
---

---@class SprintSkillHelper
local SprintSkillHelper = T(Lib, "SprintSkillHelper")
local socket = require("socket")
---@type SkillConfig
local SkillConfig = T(Config, "SkillConfig")
---@type AttributeSystem
local AttributeSystem = T(Lib, "AttributeSystem")

function SprintSkillHelper:init()
    self.enterSkillList = {}
    self.enterSprintStep = 0

    self.lastSprintTime=0
    self.startRecoverTime =0
    self.sprintNumMax= 8
    self.curSprintNum=self.sprintNumMax
    self.sprintRecoverTimeDelay=(World.cfg.game_skillSetting.sprintParam and World.cfg.game_skillSetting.sprintParam.recoverTimeDelay)
            and World.cfg.game_skillSetting.sprintParam.recoverTimeDelay or 0.5
    self.checkSprintRecoverTimer=World.Timer(1,self.checkRecoverSprintNum,self)
    Lib.subscribeEvent(Event.EVENT_GAME_ROLE_COMMON_ATTRIBUTE_CHANGE, function(player, id)
        if player.objID == Me.objID then
            if id == Define.ATTR.DASH_COUNT then
                local dashCount = AttributeSystem:getAttributeValue(Me, Define.ATTR.DASH_COUNT)
                if dashCount ~= self.sprintNumMax then
                    self:setSprintMaxNum(dashCount)
                end
            end
        end
    end)
    World.Timer(5,function ()
        Lib.emitEvent(Event.EVENT_SPRINT_NUM_CHANGE,self.curSprintNum)
    end)
end

local forwardDirectionX = 0
local forwardDirectionZ = 1
local currentYaw=0

local function applyDirection()
    local currentYawRad = math.rad(currentYaw or -Me:getBodyYaw())
    local x, z = math.sin(currentYawRad), math.cos(currentYawRad)

    forwardDirectionX = x
    forwardDirectionZ = z
end

function SprintSkillHelper:enterSprintSkillState(freeEntity)
    self.enterSprintStep = self.enterSprintStep + 1
    self:updateSprintRunState(freeEntity)
    --Lib.emitEvent(Event.EVENT_PLAY_SOUND, "player_sprint")
    Me:playerSoundAndBroadcast("player_sprint")
    Me:setPlayerActionInf(nil)
    self:changeSprintNum(-1)
    self:breakSprintNumRecover()
end

function SprintSkillHelper:exitSprintSkillState(freeEntity)
    self.enterSprintStep = self.enterSprintStep - 1
    self:updateSprintRunState(freeEntity)
end

function SprintSkillHelper:updateSprintRunState(freeEntity)
    if self.enterSprintStep > 0 then
        if self.sprintTimer then
            self.sprintTimer()
            self.sprintTimer = nil
        end
        freeEntity:setCalcYawBySpeedDir(1,Define.CalcYawPriority.FlyLimit)
        Me:setPlayerBodyRotation(false,Define.BodyRotationPriority.FlyLimit)
        local forwardSpeed = World.cfg.game_skillSetting.initSprintSpeed
        self.sprintTimer = World.LightTimer("SprintSkillHelper:enterSprintSkillState", 1, function()
            currentYaw = -Me:getBodyYaw()
            if forwardSpeed < World.cfg.game_skillSetting.maxSprintSpeed then
                forwardSpeed = forwardSpeed + World.cfg.game_skillSetting.accelerationSprint
            end
            applyDirection()
            Me:moveUntilCollide(Lib.v3(0, World.cfg.game_skillSetting.upOffsetPosY, 0) * forwardSpeed)
            Me:moveUntilCollide(Lib.v3(forwardDirectionX, 0, forwardDirectionZ) * forwardSpeed)
            Me:moveUntilCollide(Lib.v3(0, World.cfg.game_skillSetting.downOffsetPosY, 0) * forwardSpeed)
            return true
        end)
        freeEntity:enterStateType(Define.RoleStatus.SPRINT)
    else
        if self.sprintTimer then
            self.sprintTimer()
            self.sprintTimer = nil
        end
        freeEntity:exitStateType(Define.RoleStatus.SPRINT)
        freeEntity:setCalcYawBySpeedDir(nil,Define.CalcYawPriority.FlyLimit)
        Me:setPlayerBodyRotation(nil,Define.BodyRotationPriority.FlyLimit)
    end

    if self.enterSprintStep == 1 then
        freeEntity:updateSprintFallGravity()
    elseif self.enterSprintStep <= 0 then
        freeEntity:updateSprintFallGravity()
    end
end

function SprintSkillHelper:isInSprintState()
    return self.enterSprintStep>0
end

function SprintSkillHelper:canSprint()
    return self.curSprintNum>0
end

function SprintSkillHelper:setSprintMaxNum(num)
    --print("+++++++++++++++++SprintSkillHelper:setSprintMaxNum",num)
    if num then
        self.sprintNumMax=num
    end
end

function SprintSkillHelper:changeSprintNum(num)
    if num then
        self.curSprintNum=math.min(self.curSprintNum+num,self.sprintNumMax)
        --print("++++++++++++++++SprintSkillHelper:changeSprintNum",num,self.curSprintNum)
        Lib.emitEvent(Event.EVENT_SPRINT_NUM_CHANGE,self.curSprintNum)
    end
end

function SprintSkillHelper:breakSprintNumRecover()
    Lib.emitEvent(Event.EVENT_SPRINT_NUM_RECOVER,0)
    self.startRecoverTime=-1
    self.lastSprintTime=socket.gettime()
end

function SprintSkillHelper:checkRecoverSprintNum()
    if self.curSprintNum>=self.sprintNumMax then
        return true
    end
    if socket.gettime() - self.lastSprintTime < self.sprintRecoverTimeDelay then
        return true
    end
    if self.startRecoverTime < 0 then
        self.startRecoverTime=socket.gettime()
    end

    local sprintRecoverCD=0.45
    local sprintCfg=SkillConfig:getSkillConfig(Me:getSprintSkillId())
    if sprintCfg then
        sprintRecoverCD=sprintCfg.sprintRecoverCD/1000
    end

    Lib.emitEvent(Event.EVENT_SPRINT_NUM_RECOVER,self:getRecoverProgress(sprintRecoverCD))
    if socket.gettime() - self.startRecoverTime >= sprintRecoverCD then
        self:changeSprintNum(1)
        self.startRecoverTime =socket.gettime()
    end
    return true
end

function SprintSkillHelper:getRecoverProgress(CD)
    --print("---------------getRecoverProgress",socket.gettime(),self.startRecoverTime)
     return (socket.gettime() - self.startRecoverTime) /CD
end


SprintSkillHelper:init()
