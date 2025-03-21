---
--- Generated by PluginCreator
--- monster_manager mainLua
--- DateTime:2023-03-01
---

require "common.entity_monster_manager"
require "common.event_monster_manager"
require "common.config.monster_region_config"
require "common.define_monster_manager"
if World.isClient then
    require "client.player.player_monster_manager"
    require "client.player.packet_monster_manager"
    require "client.entity.entity_monster_manager"
    require "client.entity.entity_value_func_monster_manager"
    require "client.gm_monster_manager"
else
    require "server.player.player_monster_manager"
    require "server.player.packet_monster_manager"
    require "server.entity.entity_monster_manager"
    require "server.monster_born_helper"
    require "server.gm_monster_manager"
end

local handlers = {}

if World.isClient then

else
    ---@type MonsterBornHelper
    local MonsterBornHelper = T(Lib, "MonsterBornHelper")

    function handlers.monsterRegionInit(partId, map)
        local part = Instance.getByInstanceId(partId)
        if part and part:isValid() then
            MonsterBornHelper:pushOneRegionInfo(part, map)
        end
    end

    function handlers.doDestroyMonster(objID)
        MonsterBornHelper:destroyOneRegionMonster(objID)
    end

    function handlers.doCreateMonster(map, monsterId, pos)
        return  MonsterBornHelper:createOneMonster(map, monsterId, pos)
    end
end

return function(name, ...)
	if type(handlers[name]) ~= "function" then
		return
	end
	return handlers[name](...)
end
