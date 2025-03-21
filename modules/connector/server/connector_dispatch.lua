---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 10184.
--- DateTime: 2021/4/20 16:28
---
---@class SConnectorDispatch : IConnectorDispatch
---@field super IConnectorDispatch
local SConnectorDispatch = class("SConnectorDispatch", require "common.i_connector_dispatch")

function SConnectorDispatch:ctor()
    self.super.ctor(self)
end

---@protected
---@param type number 消息类型
---@param targets number[] 接收者userId列表
---@param data table 接收数据
function SConnectorDispatch:onMsgReceive(type, targets, data)
    local intercept = self.super.onMsgReceive(self, type, targets, data)
    if intercept then
        ---服务器拦截了该消息，不发送给客户端
        return
    end
    local param = {
        type = type,
        targets = targets,
        data = data
    }
    if #targets == 0 or tostring(targets[1]) == "0" then
        WorldServer.BroadcastPacket({
            pid = "ConnectorMsgReceive",
            data = param
        })
        Lib.emitEvent(Event.EVENT_SERVER_CONNECTOR_MSG, param)
    else
        for _, userId in pairs(targets) do
            local player = Game.GetPlayerByUserId(userId)
            if player and player:isValid() then
                player:sendPacket({
                    pid = "ConnectorMsgReceive",
                    data = param
                })
            end
        end
    end
end

T(Lib, "ConnectorDispatch", SConnectorDispatch.new())