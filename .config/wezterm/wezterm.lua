
local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

return {
    window_close_confirmation = 'NeverPrompt',

    front_end = 'OpenGL',
    color_scheme = 'Default (dark) (terminal.sexy)',
    -- font = wezterm.font('Fira Code'),
    font_size = 11,
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
    },
    animation_fps = 60,
    max_fps = 120,
    prefer_egl = true,
    -- Set the leader key
    leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 },
    -- Key bindings
    keys = {
       -- Activate Copy Mode
       { key = " ", mods ="LEADER", action = wezterm.action.ActivateCopyMode },
       
       -- Paste from Copy Mode
       { key = "]", mods ="LEADER", action = wezterm.action.PasteFrom("PrimarySelection") },

       -- Split panes
       { key = "-", mods = "LEADER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
       { key = "=", mods = "LEADER", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },

       -- Pane navigation
       { key = "h", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Left" } },
       { key = "j", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Down" } },
       { key = "k", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Up" } },
       { key = "l", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Right" } },

       -- Resize panes
       { key = "H", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
       { key = "J", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
       { key = "K", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
       { key = "L", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },

       -- Create and switch tabs
       { key = "c", mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
       { key = "1", mods = "LEADER", action = wezterm.action { ActivateTab = 0 } },
       { key = "2", mods = "LEADER", action = wezterm.action { ActivateTab = 1 } },
       { key = "3", mods = "LEADER", action = wezterm.action { ActivateTab = 2 } },

       -- go las tab
       { key = "Space", mods ="LEADER|CTRL", action = wezterm.action.ActivateLastTab },

       -- Close panes and tabs
       { key = "x", mods = "LEADER", action = wezterm.action { CloseCurrentPane = { confirm = false } } },
       { key = "&", mods = "LEADER|SHIFT", action = wezterm.action { CloseCurrentTab = { confirm = false } } },

       -- sessionizer
       { key = "f", mods  = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },

       -- notes
       { key = 'n', mods = "LEADER",
            action = wezterm.action.SplitPane {
                direction = 'Down',
                command = { args = { 'ripnote' } },
            },
        },

       	--disable defaults
    	{ key = 'LeftArrow', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
		{ key = 'RightArrow', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
		{ key = 'UpArrow', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
		{ key = 'DownArrow', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
    }
}
