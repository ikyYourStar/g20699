---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 10184.
--- DateTime: 2021/4/20 15:20
---
require "server.connector_event"
require "server.connector_dispatch"
require "common.i_connector_center"
require "server.service.connector_center_service"

local v_type = type

---@type ConnectorClient
local ConnectorClient
---@class SConnectorCenter : ConnectorCenter
local SConnectorCenter = T(Lib, "ConnectorCenter")
---@type ConnectorCenterService
local ConnectorCenterService = T(Lib, "ConnectorCenterService")
---@type ConnectorFilter
local ConnectorFilter = T(Lib, "ConnectorFilter")
---@type table
local SendMsgCache = {}
---@type table<number, number>
local FakeId2UserId = T(SConnectorCenter, "FakeId2UserId")
---@type table<number, number>
local UserId2FakeId = {}

local cjson = require("cjson")

function onConnectorMsgHandler(name, ...)
    local func = SConnectorCenter[name]
    if not func then
        return
    end
    func(SConnectorCenter, ...)
end

function SConnectorCenter:initRegisterGameEvent()
    Lib.subscribeEvent(Event.EVENT_PLAYER_LOGIN, function(player)
        local userId = player.platformUserId
        self:onUserIn(userId)
    end)

    Lib.subscribeEvent(Event.EVENT_PLAYER_LOGOUT, function(userId)
        self:onUserOut(userId)
    end)
end

function SConnectorCenter:start()
    Lib.logWarning("SConnectorCenter  start!!!!!!!!!!!!!!!!!")
    self.isReconnecting = false
    self:createConnect()
    Lib.subscribeEvent(Event.EVENT_CONNECTOR_MSG, function(data)
        if data.room then
            SConnectorCenter:sendRoomMsg(data["type"], data["userId"], data["data"])
        else
            SConnectorCenter:sendMsg(data["type"], data["userId"], data["data"])
        end
    end)
end

function SConnectorCenter:createConnect()
    self.isReconnecting = true
    AsyncProcess.GetConnectorListApi(function(_, responseData)
        local data = responseData.data
        if not data or not data.addr then
            Lib.logError("-------------AsyncProcess.GetConnectorListApi not data-----------------\n", Lib.v2s(data))
            return
        end
        Lib.logInfo("[SConnectorCenter:createConnect]")
        Lib.pv(data)
        local address = Lib.splitString(data.addr, ":")
        local host = address[1]
        if PlatformUtil.isPlatformWindows() then
            --if true then -- pc test
            local testHost = ({
                ["192.168.1.69"] = "52.82.23.100",
                ["192.168.1.4"] = "52.82.22.197",
                ["192.168.1.229"] = "52.83.140.52",
            })[host]

            host = testHost or host
        end
        local port = tonumber(address[2])
        ConnectorManager.Instance():createConnect(host, port)
    end)
end

---@private
function SConnectorCenter:onConnected()
    self.isReconnecting = false
    ConnectorClient = ConnectorManager.Instance():getConnectorClient()
    ConnectorCenterService:sendConnected()
end

---@private
function SConnectorCenter:onDisconnected()
    ConnectorCenterService:sendDisconnected(false)
end

function SConnectorCenter:sendCacheMsg()
    for _, cache in pairs(SendMsgCache) do
        self:sendMsg(unpack(cache))
    end
    SendMsgCache = {}
end

function SConnectorCenter:onUserIn(userId)
    if not ConnectorClient then
        return
    end
    if PlatformUtil.isPlatformWindows() then
        math.randomseed(os.time())
        local fakeId = math.random(5, 9) * math.random(51, 99) * math.random(501, 999)
        FakeId2UserId[fakeId] = userId
        UserId2FakeId[userId] = fakeId
    end
    ConnectorCenterService:sendUserIn(userId)
end

function SConnectorCenter:onUserOut(userId)
    if not ConnectorClient then
        return
    end
    ConnectorCenterService:sendUserOut(userId)
    if PlatformUtil.isPlatformWindows() then
        local fakeId = UserId2FakeId[userId]
        UserId2FakeId[userId] = nil
        FakeId2UserId[fakeId] = nil
    end
end

---ConnectorCenter发送消息
---@param type number 消息类型
---@param userId number 发送者userId
---@param data string | table 发送数据
function SConnectorCenter:sendMsg(type, userId, data)
    if v_type(data) == "table" then
        data = cjson.encode(data)
    end
    local result = ConnectorFilter:onSendMsgFilter(type, userId, data)
    if result == true then
        return
    end
    if not ConnectorClient then
        return
    end
    if userId ~= 0 and not Game.GetPlayerByUserId(userId) then
        return
    end
    if v_type(result) == "string" then
        data = result
        if SConnectorCenter.isDebug then
            Lib.logInfo("[SConnectorCenter:sendMsg] result=" .. result)
        end
    end
    if self.isReconnecting then
        table.insert(SendMsgCache, { type, userId, data })
        return
    end
    local oldUserId = userId
    if PlatformUtil.isPlatformWindows() then
        for uid, fid in pairs(UserId2FakeId) do
            data = data:gsub(uid, fid)
        end
        userId = UserId2FakeId[userId] or userId
    end
    if SConnectorCenter.isDebug then
        Lib.logInfo("[SConnectorCenter:sendMsg] type=" .. type)
        Lib.logInfo("[SConnectorCenter:sendMsg] userId=" .. tostring(userId) .. " [" .. oldUserId .. "]")
        Lib.logInfo("[SConnectorCenter:sendMsg] data=" .. data)
    end
    ConnectorClient:sendMsg(type, userId, data)
end

---ConnectorCenter发送消息[Room]
---@param type number 消息类型
---@param userId number 发送者userId
---@param data string | table 发送数据
function SConnectorCenter:sendRoomMsg(type, userId, data)
    if v_type(data) == "table" then
        data = cjson.encode(data)
    end
    local result = ConnectorFilter:onSendMsgFilter(type, userId, data)
    if result == true then
        return
    end
    if userId ~= 0 and not Game.GetPlayerByUserId(userId) then
        return
    end
    if v_type(result) == "string" then
        data = result
        if SConnectorCenter.isDebug then
            Lib.logInfo("[SConnectorCenter:sendRoomMsg] result=" .. result)
        end
    end
    local oldUserId = userId
    if PlatformUtil.isPlatformWindows() then
        for uid, fid in pairs(UserId2FakeId) do
            data = data:gsub(uid, fid)
        end
        userId = UserId2FakeId[userId] or userId
    end
    if SConnectorCenter.isDebug then
        Lib.logInfo("[SConnectorCenter:sendRoomMsg] type=" .. type)
        Lib.logInfo("[SConnectorCenter:sendRoomMsg] userId=" .. tostring(userId) .. " [" .. oldUserId .. "]")
        Lib.logInfo("[SConnectorCenter:sendRoomMsg] data=" .. data)
    end
    Server.CurServer:sendConnectorMsg(type, userId, data)
end

SConnectorCenter:initRegisterGameEvent()