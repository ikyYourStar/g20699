---
--- Generated by PluginCreator
--- fly_new_tips player
--- DateTime:2023-04-17
---

local Player = Player
function Player:pushClientShowOneFlyTips(itemInfo, isBoard)
    local packet = {
        pid = "SyncClientShowOneFlyTips",
        itemInfo = itemInfo
    }
    if isBoard then
        self:sendPacketToTracking(packet, true)
    else
        self:sendPacket(packet)
    end
end
