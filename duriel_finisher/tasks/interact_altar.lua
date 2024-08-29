local utils      = require "core.utils"
local enums      = require "data.enums"
local tracker    = require "core.tracker"
local explorer   = require "core.explorer"
local settings   = require "core.settings"

local last_reset = 0
local task = {
    name = "Interact Altar",
    shouldExecute = function()
        --console.print("Checking if the task 'Exit Pit' should be executed.")

        local is_in_boss_zone = false
        if utils.match_player_zone("Boss_WT4_") then
            is_in_boss_zone = true
        end
        

        return utils.player_on_quest(get_current_world():get_current_zone_name()) and not utils.loot_on_floor() and utils.get_altar()
    end,
    Execute = function()
        --console.print("Executing the task: Interact Altar.")
        explorer.is_task_running = true  -- Set the flag
        --console.print("Setting explorer task running flag to true.")
        explorer:clear_path_and_target()
      --  console.print("Clearing path and target in explorer.")

        local altar = utils.get_altar()
        if altar then
            loot_manager.interact_with_object(altar)
            if utils.distance_to(altar) <= 2 then
                
                if settings.tormented then
                    utility.summon_boss_next_recipe()
                end

                utility.summon_boss()

                settings.altar_activated = true
            end
        end

        explorer.is_task_running = false  -- Reset the flag
  --      console.print("Setting explorer task running flag to false.")
    end
}

return task