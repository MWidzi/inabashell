--------------------------------------------------------------------------------
-- INABAKUMORI (稲葉曇) THEMED HYPRLAND ANIMATIONS
--
-- Inspired by the rhythmic, mechanical glide of "Lagtrain" (ラグトレイン),
-- the springy tactile pop of "Lost Umbrella" (ロストアンブレラ), and the soft,
-- melancholic rain & overcast atmosphere.
--------------------------------------------------------------------------------

-- Custom Bézier Curves
-- 1. lagtrain: Smooth initial pickup with a silky, non-overshooting train glide to a halt
hl.curve("lagtrain",     { type = "bezier", points = { {0.22, 1.00}, {0.36, 1.00} } })

-- 2. lostUmbrella: Snappy tactile umbrella pop with a subtle 3% cushion overshoot (for specialWorkspace)
hl.curve("lostUmbrella", { type = "bezier", points = { {0.15, 1.20}, {0.30, 1.05} } })

-- 3. railGlide: Weighted commuter rail momentum for moving windows and scrolling columns
hl.curve("railGlide",    { type = "bezier", points = { {0.22, 1.00}, {0.38, 1.00} } })

-- 4. mistFade: Gentle, atmospheric ease-in-out like rain and overcast skies
hl.curve("mistFade",     { type = "bezier", points = { {0.35, 0.00}, {0.15, 1.00} } })

-- 5. snapClose: Brisk, clean closure without dragging or delay
hl.curve("snapClose",    { type = "bezier", points = { {0.15, 0.00}, {0.05, 1.00} } })

-- 6. floatPlay: Airy, buoyant float for subtle transitions
hl.curve("floatPlay",    { type = "bezier", points = { {0.05, 0.95}, {0.15, 1.02} } })

-- Compatibility / Fallback Curves
hl.curve("linear",       { type = "bezier", points = { {0.00, 0.00}, {1.00, 1.00} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.50, 0.50}, {0.75, 1.00} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0.00}, {0.10, 1.00} } })

--------------------------------------------------------------------------------
-- Animation Tree
--------------------------------------------------------------------------------

-- Global base
hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "lagtrain" })

-- Windows (Smooth, prompt opening and closure)
hl.animation({ leaf = "windows",     enabled = true, speed = 4.0, bezier = "lagtrain" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3.8, bezier = "lagtrain",  style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2.2, bezier = "snapClose", style = "popin 88%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "railGlide" })

-- Fading (atmospheric rain & overcast feel)
hl.animation({ leaf = "fade",        enabled = true, speed = 3.0, bezier = "mistFade" })
hl.animation({ leaf = "fadeIn",      enabled = true, speed = 2.6, bezier = "mistFade" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 2.0, bezier = "snapClose" })
hl.animation({ leaf = "fadeSwitch",  enabled = true, speed = 2.8, bezier = "mistFade" })
hl.animation({ leaf = "fadeDim",     enabled = true, speed = 3.0, bezier = "mistFade" })
hl.animation({ leaf = "fadeShadow",  enabled = true, speed = 3.2, bezier = "mistFade" })

-- Layers (Walker, SwayNC, Rofi, Quickshell)
-- Note: lagtrain has zero overshoot, preventing Walker from drifting left and SwayNC from feeling gigantic
hl.animation({ leaf = "layers",        enabled = true, speed = 3.6, bezier = "lagtrain" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3.4, bezier = "lagtrain",  style = "popin 88%" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 2.0, bezier = "snapClose", style = "popin 88%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2.6, bezier = "mistFade" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "snapClose" })

-- Workspaces (Smooth commuter train car transitions)
hl.animation({ leaf = "workspaces",    enabled = true, speed = 3.8, bezier = "lagtrain", style = "slidefade 20%" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3.8, bezier = "lagtrain", style = "slidefade 20%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.8, bezier = "lagtrain", style = "slidefade 20%" })

-- Special Workspaces (Pypr scratchpads dropping in - kept exactly as you liked)
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 3.2, bezier = "lagtrain",     style = "slidefadevert 20%" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 3.2, bezier = "lostUmbrella", style = "slidefadevert 20%" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2.2, bezier = "snapClose",    style = "slidefadevert 20%" })

-- Borders & Zoom
hl.animation({ leaf = "border",      enabled = true, speed = 3.4,  bezier = "lagtrain" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 12.0, bezier = "linear" })
hl.animation({ leaf = "zoomFactor",  enabled = true, speed = 3.8,  bezier = "lagtrain" })


