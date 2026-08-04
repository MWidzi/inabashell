-----------------
--- AUTOSTART ---
-----------------

hl.dsp.exec_cmd("playerctld daemon &")
hl.dsp.exec_cmd("swaync")
hl.dsp.exec_cmd("elephant")
hl.dsp.exec_cmd("walker --gapplication-service")
hl.dsp.exec_cmd("systemctl --user start hyprpolkitagent")
hl.dsp.exec_cmd("awww-daemon & udiskie")
hl.dsp.exec_cmd("qs")
hl.dsp.exec_cmd("awww img ~/.config/wallpapers/inabakumori_wallpaper_1.webp")
hl.dsp.exec_cmd("hyprctl dispatch workspace 1")
hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'") -- GTK3 apps
hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'") -- GTK4 apps
hl.dsp.exec_cmd("pypr & hyprsunset & hypridle")
hl.dsp.exec_cmd("systemctl --user start mpd")
hl.dsp.exec_cmd("sleep 3 && mpd-mpris")
hl.dsp.exec_cmd("wl-paste --watch cliphist store")
