-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("playerctld daemon &")
    hl.exec_cmd("swaync")
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("awww-daemon & udiskie")
    hl.exec_cmd("qs")
    hl.exec_cmd("awww img ~/.config/wallpapers/inabakumori_wallpaper_1.webp")
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'") -- GTK3 apps
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'") -- GTK4 apps
    hl.exec_cmd("pypr & hypridle")
    hl.exec_cmd("wlsunset -l 53.36681292618379 -L 14.650595233724927")
    hl.exec_cmd("systemctl --user start mpd")
    hl.exec_cmd("sleep 3 && mpd-mpris")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("fcitx5 -d")
end)
