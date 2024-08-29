local utils      = require "core.utils"
local enums      = require "data.enums"
local tracker    = require "core.tracker"
local explorer   = require "core.explorer"
local settings   = require "core.settings"

local last_reset = 0
local task = {
    name = "Exit Boss",
    shouldExecute = function()
        --console.print("Checking if the task 'Exit Pit' should be executed.")

        local is_in_boss_zone = false
        if utils.match_player_zone("Boss_WT4_") then
            is_in_boss_zone = true
        end
        

        return not utils.player_on_quest(get_current_world():get_current_zone_name()) and not utils.loot_on_floor() and is_in_boss_zone and settings.first_item_dropped and settings.can_exit
    end,
    Execute = function()
       -- console.print("Executing the task: Exit Boss.")
        explorer.is_task_running = true  -- Set the flag
       -- console.print("Setting explorer task running flag to true.")
        explorer:clear_path_and_target()
      --  console.print("Clearing path and target in explorer.")
        
        if tracker.finished_time == 0 then
            console.print("Setting finished time in tracker.")
            tracker.finished_time = get_time_since_inject()
        end

        if tracker.finished_time > 0 and get_time_since_inject() > tracker.finished_time + 10 then
            if get_time_since_inject() - last_reset > 10 then
                last_reset = get_time_since_inject()
                reset_all_dungeons()
                tracker.finished_time = 0
                tracker.start_time = 0
                settings.can_exit = false
                settings.first_item_dropped = false
                settings.altar_activated = false

                -- Count Up runs!
                settings.solved_runs = settings.solved_runs + 1

                --console.print("Resetting all dungeons at time: " .. get_time_since_inject())
            end
        end

        -- Check if the player is no longer on the quest 'pit_started'
        if not utils.match_player_zone("Boss_WT4_") then
          --  console.print("Player is no longer on the boss quest. Exiting task.")
            explorer.is_task_running = false  -- Reset the flag
            return task
        end

        explorer.is_task_running = false  -- Reset the flag
      --  console.print("Setting explorer task running flag to false.")
    end
}

return task