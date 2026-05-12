require("staging") --- For testing things without constant reloads

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "eDP-1",
	mode = "2400x1600@120",
	position = "0x0",
	scale = "1",
})

-------------------------
---- GENERAL ALIASES ----
-------------------------
--- These are replaced when processed in the nix store
local terminal = "XXX_ALACRITTY_XXX";
local fileManager = "XXX_THUNAR_XXX";
local menu = "XXX_VICINAE_XXX";
local clipboard_hist = "XXX_CLIPBOARD_HIST_XXX";
local browser = "XXX_FIREFOX_XXX";
local editor = "XXX_ZED_XXX";
local screenshot = "XXX_SCREENSHOT_XXX";
local wpctl = "XXX_WIREPLUMBER_XXX"
local brightnessctl = "XXX_BRIGHTNESSCTL_XXX";
local hyprlock = "XXX_HYPRLOCK_XXX";
local cursor = "rose-pine-hyprcursor";

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("XXX_START_HYPRPOLKITAGENT_XXX")
	hl.exec_cmd("XXX_START_HYPRCTL_NUMLOCK_XXX")
	hl.exec_cmd("XXX_START_HYPRCTL_SETCURSOR_XXX")
	hl.exec_cmd("XXX_START_HYPRCTL_DISPATCH_XXX")

	hl.exec_cmd("XXX_START_HYPRPAPER_XXX")
	hl.exec_cmd("XXX_START_VICINAE_XXX")

	hl.exec_cmd("sleep 5; $hyprscripts/check_setup_warnings.sh &")

	hl.exec_cmd("XXX_START_BITWARDEN_DESKTOP_XXX")

	--- XXX_EXTRA_STARTUP_XXX
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
	general = {
		gaps_in          = 5,
		gaps_out         = 10,

		border_size      = 2,

		col              = {
			active_border   = { colors = { "XXX_COL_ACTIVE_BORDER_XXX" } },
			inactive_border = "XXX_COL_INACTIVE_BORDER_XXX",
		},

		resize_on_border = true,
		allow_tearing    = true,
		layout           = "dwindle",

		snap             = { enabled = true, monitor_gap = 20, window_gap = 20 }

	},

	group = {
		col      = {
			border_active   = { colors = { "XXX_COL_ACTIVE_BORDER_XXX" } },
			border_inactive = "XXX_COL_INACTIVE_BORDER_XXX",
		},

		groupbar = {
			scrolling         = false,
			font_size         = 14,
			height            = 22,
			gradients         = true,
			gradient_rounding = 10,
			indicator_height  = 0,
			text_color        = "XXX_GROUPBAR_TEXT_COLOR_XXX",
		}
	},

	decoration = {
		rounding         = 5,
		rounding_power   = 5,

		active_opacity   = 1.0,
		inactive_opacity = 0.9,

		shadow           = { enabled = false, },
		blur             = { enabled = false, },
	},

	animations = { enabled = true },

	dwindle = {
		preserve_split = true,
	}
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

----------------
----  MISC  ----
----------------
hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo   = true,
		focus_on_activate       = true
	},
})

---------------
---- BINDS ----
---------------

--- Open Programs
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + C", hl.dsp.exec_cmd(editor))

hl.bind("SUPER + V", hl.dsp.exec_cmd(clipboard_hist))

--- Window Behavior
hl.bind("SUPER + X", hl.dsp.window.kill())
hl.bind("SUPER + Q", hl.dsp.window.fullscreen_state({ internal = 3, client = 0 }))
hl.bind("ALT + F4", hl.dsp.window.signal({ signal = 9 }))

hl.bind("SUPER + ALT+ G", hl.dsp.group.toggle())
hl.bind("ALT + TAB", hl.dsp.group.next())

hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(screenshot))

--- Focus Interactions
hl.bind("SUPER + SHIFT + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + ALT + left", hl.dsp.window.resize({ x = -10, y = 0 }))
hl.bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 10, y = 0 }))
hl.bind("SUPER + ALT + up", hl.dsp.window.resize({ x = 0, y = 10 }))
hl.bind("SUPER + ALT + down", hl.dsp.window.resize({ x = 0, y = -10 }))

hl.bind("SUPER + SHIFT + ALT + left", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + ALT + right", hl.dsp.window.resize({ x = 200, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + ALT + up", hl.dsp.window.resize({ x = 0, y = 200, relative = true }))
hl.bind("SUPER + SHIFT + ALT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

--- Power Control
hl.bind("SUPER + L", hl.dsp.exec_cmd(hyprlock))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(wpctl .. " set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(wpctl .. " set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(wpctl .. " set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(wpctl .. " set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightnessctl .. " -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightnessctl .. " -e4 -n2 set 5%-"),
	{ locked = true, repeating = true })

----------------------
---- WINDOW RULES ----
----------------------
hl.window_rule({
	name     = "fix-xwayland-drags",
	match    = {
		class      = "^$",
		title      = "^$",
		xwayland   = true,
		float      = true,
		fullscreen = false,
		pin        = false,
	},

	no_focus = true,
})

local suppressMaximizeRule = hl.window_rule({
	name           = "suppress-maximize-events",
	match          = { class = ".*" },

	suppress_event = "maximize",
})

local function mkFloatRuleClass(value)
	return hl.window_rule({ match = { class = value }, float = true, center = true })
end


mkFloatRuleClass("org.pulseaudio.pavucontrol")
mkFloatRuleClass("blueman-manager")
mkFloatRuleClass("nm-connection-editor")
mkFloatRuleClass("waypaper")
mkFloatRuleClass("Tk")
mkFloatRuleClass("tuned-gui")
mkFloatRuleClass(".blueman-manager-wrapped")
mkFloatRuleClass("xdg-desktop-portal-gtk")
mkFloatRuleClass("firefox match:title Extension")
mkFloatRuleClass("thunar")
mkFloatRuleClass("Bitwarden")
mkFloatRuleClass("hyprpwcenter")

hl.window_rule({ match = { title = "flameshot" }, float = true, center = true })

for i = 1, 6 do
	hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
hl.workspace_rule({ workspace = "1", default = true })


hl.layer_rule({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0, no_anim = true })
