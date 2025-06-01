-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.term = 'xterm-256color'
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.default_prog = { "powershell.exe", "-NoLogo" }

-- Colors
config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
    cursor_bg = "white",
    cursor_border = "white"
}

-- or, changing the font size and color scheme.
config.font_size = 12
config.window_background_opacity = 0.7

-- Window frame
config.initial_cols = 80
config.initial_rows = 28
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

-- Finally, return the configuration to wezterm:
return config