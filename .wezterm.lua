-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- config.front_end = "WebGpu"

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 144
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.font = wezterm.font("MonoLisa Nerd Font Medium")
config.harfbuzz_features = { 'zero', 'ss18', 'ss11' } -- dashed 0, better @, hexa ligature
-- config.font = wezterm.font("Monocraft Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font Mono")
-- config.font = wezterm.font("JetBrains Mono Regular")
config.cell_width = 1
config.window_background_opacity = 0.9
config.prefer_egl = true
config.font_size = 14.0
config.line_height = 0.9

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
-- config.tab_bar_at_bottom = true

-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

-- color scheme toggling
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Cloud (terminal.sexy)" then
		overrides.color_scheme = "Night Owl (Gogh)"
	else
		overrides.color_scheme = "Cloud (terminal.sexy)"
	end
	window:set_config_overrides(overrides)
end)

-- keymaps
config.keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- For example, changing the color scheme:
config.color_scheme = "Night Owl (Gogh)"


config.window_frame = {
	font = wezterm.font({ family = "Monolisa", weight = "Medium" }),
	active_titlebar_bg = "#01111d",
	inactive_titlebar_bg = "#01111d",
	inactive_titlebar_border_bottom = "#272B3B",
	active_titlebar_border_bottom = "#262A39",
	--active_titlebar_bg = "#181616",
}

config.colors = {
	tab_bar = {
		background = "#011627",
		
		active_tab = {
			bg_color = "#0b2942",
			fg_color = "#d2dee7",
		},
		inactive_tab = {
			bg_color = "#01111d",
			fg_color = "#5f7e97",
		},
		new_tab = {
			bg_color = "#01111d",
			fg_color = "#d2dee7",
		}
	}
}

-- config.window_decorations = "TITLE | RESIZE"
config.window_decorations = "NONE | RESIZE"
config.default_prog = { "powershell.exe", "-NoLogo" }

wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local tab, pane, window = mux.spawn_window(cmd or {})
	-- window:gui_window():toggle_fullscreen() -- toggle fullscreen because maximize alone make a weird pixel line at the top
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config