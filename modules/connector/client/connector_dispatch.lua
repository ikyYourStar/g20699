---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 10184.
--- DateTime: 2021/4/20 16:28
---
---@class CConnectorDispatch : IConnectorDispatch
---@field super IConnectorDispatch
local CConnectorDispatch = class("CConnectorDispatch", require "common.i_connector_dispatch")

function CConnectorDispatch:ctor()
    self.super.ctor(self)
end

T(Lib, "ConnectorDispatch", CConnectorDispatch.new())