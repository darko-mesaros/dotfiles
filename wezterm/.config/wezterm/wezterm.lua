-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = 'Campbell (Gogh)'
config.color_scheme = 'Dark Pastel (Gogh)'

-- FONTS
-- config.font = wezterm.font 'Iosevka Nerd Font Mono'
config.font = wezterm.font 'FiraCode Nerd Font Mono'
-- so the font increase with CTRL + works in a WM
config.adjust_window_size_when_changing_font_size = false

-- TAB BAR
config.enable_tab_bar = false

-- and finally, return the configuration to wezterm
return config
