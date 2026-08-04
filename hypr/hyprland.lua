------------------------------
---- sources to all files ----
------------------------------

hl.dsp.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
require("binds")
require("animations")
require("monitors")
require("programs")
require("visuals")
require("rules")
require("input")
require("autostart")
require("env_vars")
