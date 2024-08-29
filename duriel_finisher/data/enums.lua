local enums = {
    triggers = {
        altar = "DRLG_Generic_Boss_Trigger",
        dungeon_entrance = "Portal_Dungeon_Generic"
    },
    positions = {
        boss_room = {
            ["Boss_WT4_S2VampireLord"] = vec3:new(-10.556, -10.419, -3.120),
            ["Boss_WT4_Duriel"] = vec3:new(-3.616, -2.309, -3.689) 
        }
    }
}

enums.positions.getBossRoomPosition = function(world_name)
    local pos = enums.positions.boss_room[world_name]
    if pos == nil then
        return vec3:new(0,0,0)
    end
    return pos
end

return enums