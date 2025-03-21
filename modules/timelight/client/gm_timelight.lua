---
--- Generated by PluginCreator
--- timelight gm
--- DateTime:2021-11-04
---

local path = Root.Instance():getGamePath():gsub("\\", "/") .. "lua/gm_client.lua"
local file, err = io.open(path, "r")
local GMItem
if file then
    GMItem = require("gm_client")
    file:close()
end
if not GMItem then
    GMItem = GM:createGMItem()
end

local TimeLight = T(Lib, "TimeLight")

GMItem["timelight/turn on low quality"] = function()
    EngineSceneManager.Instance():setLowQualityHdr(true)
end

GMItem["timelight/Turn off low quality"] = function()
    EngineSceneManager.Instance():setLowQualityHdr(false)
end

GMItem["timelight/Setting HDR Exposure"] = GM:inputStr(function(self, value)
    local exposure = tonumber(value)
    local engineSceneManager = EngineSceneManager.Instance()
    engineSceneManager:setExposure(exposure)
end,function(self)
    local engineSceneManager = EngineSceneManager.Instance()
    return engineSceneManager:getExposure()
end)

GMItem["timelight/Setting HDR Gamma"] = GM:inputStr(function(self, value)
    local gamma = tonumber(value)
    local engineSceneManager = EngineSceneManager.Instance()
    engineSceneManager:setGamma(gamma)
end,function(self)
    local engineSceneManager = EngineSceneManager.Instance()
    return engineSceneManager:getGamma()
end)