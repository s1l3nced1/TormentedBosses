local utils = require "core.utils"
local enums = require "data.enums"
local explorer = require "core.explorer"
local settings   = require "core.settings"
local tracker    = require "core.tracker"

local start_time = 0

local task = {
    name = "Finish Boss Dungeon",
    shouldExecute = function()

        local is_in_boss_room = false
        local player_position = get_player_position() -- If player is in boss room, dont explore! FIGHT :)
        if player_position:dist_to(enums.positions.getBossRoomPosition(get_current_world():get_current_zone_name())) < 25 then
            is_in_boss_room = true
        end

       -- console.print("Checking if the task 'Finish Boss Dungeon' should be executed.")
        return not utils.player_on_quest(get_current_world():get_current_zone_name()) and is_in_boss_room and not settings.can_exit and settings.altar_activated
    end,
    Execute = function()
       -- console.print("Executing the task: Finish Boss Dungeon.")
        explorer.is_task_running = true  -- Set the flag
       -- console.print("Setting explorer task running flag to true.")
        explorer:clear_path_and_target()
       -- console.print("Clearing path and target in explorer.")
        
       

        local items = loot_manager.get_all_items_chest_sort_by_distance()
        if #items > 0 then
            -- Fix for instant exit shit
            local item_to_loot = false
            for _, item in pairs(items) do
                local item_data = item:get_item_info()

                if get_local_player():get_item_count() < 33 then
                    if item_data then
                        settings.first_item_dropped = true

                        -- Always Pickup BossSummoning Items
                        if loot_manager.is_lootable_item(item, true, false) then
                            if item_data:get_name():match("BossSummoning") then
                                explorer:set_custom_target(item:get_position())
                                explorer:move_to_target()

                                loot_manager.loot_item(item, true, true)
                                item_to_loot = true

                                tracker.start_time = 0
                            end
                        end

                        if settings.only_uber then
                            if utils.is_uber_item(item_data:get_sno_id()) then
                                if loot_manager.is_lootable_item(item, true, false) and item_data:get_rarity() > 4 then
                                    explorer:set_custom_target(item:get_position())
                                    explorer:move_to_target()

                                    loot_manager.loot_item(item, true, true)
                                    item_to_loot = true

                                    utils.addUber(item, item_data:get_sno_id())

                                    tracker.start_time = 0
                                end
                            end
                        else
                            if loot_manager.is_lootable_item(item, true, false) then
                                if item_data:get_rarity() > 4 then
                                    explorer:set_custom_target(item:get_position())
                                    explorer:move_to_target()

                                    loot_manager.loot_item(item, true, true)
                                    item_to_loot = true

                                    tracker.start_time = 0
                                end
                            end
                        end                  
                    end
                else
                   -- console.print("Inventory is full!")
                end
            end

            if tracker.start_time == 0 and item_to_loot == false then
            --    console.print("No items.. Setting start time.")
                tracker.start_time = get_time_since_inject()
            end
        end

        -- Check if 5 seconds have passed
        if tracker.start_time > 0 and get_time_since_inject() > tracker.start_time + 15 then
            console.print("15 seconds have passed, resetting start time and task running flag.")
            tracker.start_time = 0  -- Reset the start time for the next execution
            settings.can_exit = true
            explorer.is_task_running = false  -- Reset the flag
            return task
        end
    end
}

return task
