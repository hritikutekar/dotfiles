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
config.window_decorations = "RESIZE"
config.window_frame = {
	border_left_width = "0.5cell",
	border_right_width = "0.5cell",
	border_bottom_height = "0.25cell",
	border_top_height = "0.25cell",
	border_left_color = "#45475C",
	border_right_color = "#45475C",
	border_bottom_color = "#45475C",
	border_top_color = "#45475C",
}

-- or, changing the font size and color scheme.
config.font_size = 14
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.color_scheme = "Catppuccin Mocha"

-- Enable transparency with black background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.colors = {
	background = "#1E1E2E",
}

-- Finally, return the configuration to wezterm:
return config
