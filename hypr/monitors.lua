----------------
--- MONITORS ---
----------------

hl.monitor({
    output = "DP-1",
    mode = "2560x1440@165",
    position = "0x0",
    scale = 1
})
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1200@60",
    position = "-1920x0",
    scale = 1
})
hl.monitor({
    output = "DP-3",
    mode = "3840x2160@60",
    position = "0x-1080",
    scale = 2
})

hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
hl.workspace_rule({ workspace = "5", monitor = "DP-3" })
