-- Colors & scalars
border_col_active        = 0xffc678dd
border_col_normal        = 0xff444444
border_width             = 1
outer_border_col_active  = 0xff222222
outer_border_col_normal  = 0xff222222
outer_border_width       = 4
gaps                     = 10
master_width             = 60
float_x                  = 100
float_y                  = 100
float_w                  = 802
float_h                  = 500
zoom_level               = 0.5
motion_throttle_hz       = 85

-- Terminal command
termcmd = { "st-wl" }

-- Autostart commands
autostart = {
	"sh $HOME/.config/mojito/status.sh"
	.. " | mojito -f \"Tadepe:style=Bold:pixelsize=16:antialias=false\""
	.. " -g 1900x20+10 &",
	"swall -m scaled $HOME/Pictures/wallpapers/rgb.png &",
}

-- Keybindings: { type, mods, key, action, arg }
binds = {
	-- Spawners
	{ "key", "mod1",        "Return",  "spawn",      { "st-wl" } },
	{ "key", "mod1",        "space",   "spawn",      { "neumenu_run", "-fn", "tadepe", "-nb", "#000000", "-sb", "#c678dd", "-sf", "#000000" } },
	{ "key", "mod1",        "b",       "spawn",      { "firefox" } },

	-- Window management
	{ "key", "mod1 shift",  "e",       "quit",       nil },
	{ "key", "mod1",        "Tab",     "focus_next", nil },
	{ "key", "mod1 shift",  "Tab",     "focus_prev", nil },
	{ "key", "mod1",        "q",       "kill_sel",   nil },
	{ "key", "mod1",        "t",       "toggle_float", nil },
	{ "key", "mod1 shift",  "t",       "toggle_float_global", nil },
	{ "key", "mod1",        "f",       "fullscreen", nil },
	{ "key", "mod1",        "d",       "draw_mode_toggle", nil },

	-- Tiling
	{ "key", "mod1",        "l",       "master_resize", 10 },
	{ "key", "mod1",        "h",       "master_resize", -10 },
	{ "key", "mod1",        "k",       "stack_resize",  10 },
	{ "key", "mod1",        "j",       "stack_resize",  -10 },
	{ "key", "mod1 shift",  "k",       "master_next",   nil },
	{ "key", "mod1 shift",  "j",       "master_prev",   nil },

	-- Floating move
	{ "key", "mod1",        "Left",    "float_move_x", -10 },
	{ "key", "mod1",        "Right",   "float_move_x",  10 },
	{ "key", "mod1",        "Up",      "float_move_y", -10 },
	{ "key", "mod1",        "Down",    "float_move_y",  10 },

	-- Floating resize (left/top anchored)
	{ "key", "mod1 shift",  "Left",    "float_resize_w",  6 },
	{ "key", "mod1 shift",  "Right",   "float_resize_w", -6 },
	{ "key", "mod1 shift",  "Up",      "float_resize_h",  6 },
	{ "key", "mod1 shift",  "Down",    "float_resize_h", -6 },

	-- Floating resize (right/bottom anchored)
	{ "key", "mod1 ctrl",   "Left",    "float_resize_w_right",   -6 },
	{ "key", "mod1 ctrl",   "Right",   "float_resize_w_right",    6 },
	{ "key", "mod1 ctrl",   "Up",      "float_resize_h_bottom",  -6 },
	{ "key", "mod1 ctrl",   "Down",    "float_resize_h_bottom",   6 },

	-- Floating scale
	{ "key", "mod1",        "equal",   "float_scale",  6 },
	{ "key", "mod1",        "minus",   "float_scale", -6 },

	-- Mouse
	{ "button", "mod1",     "BTN_LEFT",  "mouse_move",   nil },
	{ "button", "mod1",     "BTN_RIGHT", "mouse_resize", nil },
	{ "button", "any",      "BTN_LEFT",  "mouse_click",  nil },

	-- Workspaces (goto)
	{ "key", "mod1", "1", "workspace_goto",  1 },
	{ "key", "mod1", "2", "workspace_goto",  2 },
	{ "key", "mod1", "3", "workspace_goto",  3 },
	{ "key", "mod1", "4", "workspace_goto",  4 },
	{ "key", "mod1", "5", "workspace_goto",  5 },
	{ "key", "mod1", "6", "workspace_goto",  6 },
	{ "key", "mod1", "7", "workspace_goto",  7 },
	{ "key", "mod1", "8", "workspace_goto",  8 },
	{ "key", "mod1", "9", "workspace_goto",  9 },

	-- Workspaces (moveto)
	{ "key", "mod1 shift", "1", "workspace_moveto",  1 },
	{ "key", "mod1 shift", "2", "workspace_moveto",  2 },
	{ "key", "mod1 shift", "3", "workspace_moveto",  3 },
	{ "key", "mod1 shift", "4", "workspace_moveto",  4 },
	{ "key", "mod1 shift", "5", "workspace_moveto",  5 },
	{ "key", "mod1 shift", "6", "workspace_moveto",  6 },
	{ "key", "mod1 shift", "7", "workspace_moveto",  7 },
	{ "key", "mod1 shift", "8", "workspace_moveto",  8 },
	{ "key", "mod1 shift", "9", "workspace_moveto",  9 },
}
