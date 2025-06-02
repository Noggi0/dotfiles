## dotfiles 

Here are my dotfiles for my Night Owl theme on Arch Linux.

Setup:
```bash
yay -S rofi neovim dunst hyprland hyprpaper hyprlock waybar clipse wezterm wlogout
```

You can then copy the corresponding directories in your `~/.config/` folder.

Wezterm.lua file should go in your HOME folder.

Wallpapers go wherever you want, just keep in mind that it will break Hyprpaper and the `wallpaper.sh` script.

In the `scripts/` folder, you will notice multiple files named `volume`. There is a Python and Bash variant. Pick your poison.

- wezterm.lua   == wezterm config
- settings.json == vscode settings

