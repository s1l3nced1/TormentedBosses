local gui = require "gui"
local settings = {
    enabled = false,
    elites_only = false,
    is_stuck = false,
    only_uber = false,
    first_item_dropped = false,
    can_exit = false,
    altar_activated = false,
    tormented = false,
    solved_runs = 0,
    found_ubers = {}
}

function settings:update_settings()
    settings.enabled = gui.elements.main_toggle:get()
    settings.elites_only = gui.elements.elite_only_toggle:get()
    settings.loot_modes = gui.elements.loot_modes:get()
    settings.only_uber = gui.elements.only_uber:get()
    settings.tormented = gui.elements.tormented:get()
end

return settings
