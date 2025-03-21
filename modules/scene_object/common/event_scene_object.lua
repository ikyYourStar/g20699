---
--- Generated by PluginCreator
--- scene_object event
--- DateTime:2023-03-23
---


Event.EVENT_SCENE_OBJECT_TELEPORT_MAP = Event.register("EVENT_SCENE_OBJECT_TELEPORT_MAP")
Event.EVENT_SCENE_OBJECT_TELEPORT_WAIT = Event.register("EVENT_SCENE_OBJECT_TELEPORT_WAIT")

if World.isClient then
--    Event.EVENT_SCENE_OBJECT_XXX = Event.register("XXX_XXX_XX")
    Event.EVENT_SCENE_OBJECT_TRIGGER_TELEPORT = Event.register("EVENT_SCENE_OBJECT_TRIGGER_TELEPORT")

    Event.EVENT_SCENE_OBJECT_TRIGGER_MISSION_TELEPORT = Event.register("EVENT_SCENE_OBJECT_TRIGGER_MISSION_TELEPORT")
else
    Event.EVENT_SCENE_OBJECT_OBTAIN_ITEM = Event.register("EVENT_SCENE_OBJECT_OBTAIN_ITEM")
    Event.EVENT_SCENE_OBJECT_OBTAIN_ABILITY = Event.register("EVENT_SCENE_OBJECT_OBTAIN_ABILITY")
    Event.EVENT_SCENE_OBJECT_OBTAIN_TREASURE_BOX = Event.register("EVENT_SCENE_OBJECT_OBTAIN_TREASURE_BOX")
    Event.EVENT_SCENE_OBJECT_INIT_MAP = Event.register("EVENT_SCENE_OBJECT_INIT_MAP")

    Event.EVENT_SCENE_OBJECT_HIT_PART = Event.register("EVENT_SCENE_OBJECT_HIT_PART")

    Event.EVENT_SCENE_OBJECT_SET_BORN_MAP = Event.register("EVENT_SCENE_OBJECT_SET_BORN_MAP")
end
