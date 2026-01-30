-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.quit_when_all_windows_are_closed = false

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- Hide tab bar
config.enable_tab_bar = false

-- or, changing the font size and color scheme.
config.font_size = 14
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.color_scheme = "Catppuccin Mocha"

-- Enable transparency with black background
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20
config.colors = {
	background = "#000000",
}

-- Finally, return the configuration to wezterm:
return config
