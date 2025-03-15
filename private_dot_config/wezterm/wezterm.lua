local wezterm = require("wezterm")

local act = wezterm.action
local config = {
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
	font_rules = {
		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font("JetBrains Mono", { weight = "Black", stretch = "Normal", style = "Normal" }),
		},
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font("JetBrains Mono", { weight = "Black", stretch = "Normal", style = "Italic" }),
		},
	},
}
config.send_composed_key_when_left_alt_is_pressed = false

return config
