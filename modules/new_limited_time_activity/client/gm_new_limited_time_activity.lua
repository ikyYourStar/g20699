---
--- Generated by PluginCreator
--- new_limited_time_activity gm
--- DateTime:2023-04-17
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
--GMItem["new_limited_time_activity/一个彩蛋"] = function()
--end
