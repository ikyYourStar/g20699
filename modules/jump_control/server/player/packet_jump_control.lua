---
--- Generated by PluginCreator
--- jump_control handler
--- DateTime:2023-03-03
---

local handles = T(Player, "PackageHandlers")

function handles:requestPlayFallEffect(packet)
    local effectInfo = {
        includeSelf = true,
        action = 'play',
        effectName = World.cfg.jump_controlSetting.fallEffectName,
        time = World.cfg.jump_controlSetting.fallEffectTime,
        scale = World.cfg.jump_controlSetting.fallEffectScale,
        pos = packet.pos,
        yaw = packet.yaw,
        sound="player_jump_end",
        objID=self.objID
    }
    self:doPlaySceneEffect(effectInfo)
end
