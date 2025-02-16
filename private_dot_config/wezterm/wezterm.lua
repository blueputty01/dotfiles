local wezterm = require("wezterm")

return {
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
