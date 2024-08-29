local gui = {}
local plugin_label = "bosser"

local function create_checkbox(key)
    return checkbox:new(false, get_hash(plugin_label .. "_" .. key))
end

gui.loot_modes_options = {
    "Nothing",  -- will get stuck
    "Sell",     -- will sell all and keep going
    "Salvage",  -- will salvage all and keep going
    "Stash",    -- nothing for now, will get stuck, but in future can be added
}

gui.loot_modes_enum = {
    NOTHING = 0,
    SELL = 1,
    SALVAGE = 2,
    STASH = 3,
}

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = create_checkbox("main_toggle"),
    settings_tree = tree_node:new(1),
    melee_logic = create_checkbox("melee_logic"),
    elite_only_toggle = create_checkbox("elite_only"),
    loot_modes = combo_box:new(0, get_hash("bosser_loot_modes")),
    only_uber = create_checkbox("only_uber"),
    tormented = create_checkbox("tormented")
}

function gui.render()
    if not gui.elements.main_tree:push("Bosser") then return end

    gui.elements.main_toggle:render("Enable", "Enable the bot")

    if gui.elements.settings_tree:push("Settings") then
        gui.elements.melee_logic:render("Melee", "Do we need to move into Melee?")
        gui.elements.elite_only_toggle:render("Elite Only", "Do we only want to seek out elites?")
        gui.elements.only_uber:render("Uber Only", "Do we only want loot uber items?")
        gui.elements.tormented:render("Tormented Boss", "Spawn the Tormented boss version")
        gui.elements.loot_modes:render("Loot Modes", gui.loot_modes_options, "Nothing and Stash will get you stuck for now")
        gui.elements.settings_tree:pop()
    end
  

    gui.elements.main_tree:pop()
end

return gui
