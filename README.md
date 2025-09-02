# waybar-config
My personal Waybar config!

![preview](https://github.com/ninetailedtori/waybar-config/blob/main/assets/waybar-config.png?raw=true "Preview of my waybar config.")

## Dependencies
- blueman-manager: for bluetooth support.
- pipewire, pipewire-pulse, wireplumber: for cava and volume control support.
- ddcui/ddcutil: brightness control support through I2C.
- swaylock/hyprlock: for lock screen support.
- wlogout: for logout menu support.
- playerctl: for waybar player support.
- swaync: for notification support.
- wttrbar: for weather support.
- waybar-module-pacman-updates: for pacman update widget support.
- waybar-module-music: this is in the works. I can't get it to function correctly yet, it's quite early in the project phase.
- NetworkManager: this can be replaced with iwd but you'd have to work it out yourself hahah.
- networkmanager_dmenu: dmenu support for NetworkManager!
- mpris: for mpris player support.

## How to use
1. Install waybar, and the dependencies you require.
2. Copy the required .config/waybar files to your .config/waybar directory.
3. Rename the sway, sway-hide or hyprland configs to config.jsonc unless you want to generate custom services like I did hahah. I'll post the custom services as well, which will be in .services, but you'll need to install them yourself, into the `~/.config/systemd/user/` directory.
4. Copy the .local/share/bin files to your .local/share/bin directory.
5. Run `chmod +x ~/.local/share/bin/*`, to allow execution of all the scripts in the directory.
6. Restart waybar and enjoy!

## Thanks to:
- Hyprdots, which provided the basis for some of the scripts I've used!
- sway, swaync, swayosd, which provided a lot of modular functionality behind IPC and notifiers for this project
- waybar itself, which provided a decent chunk of default scripts for custom modules, which I have customised here.
- Nerd Fonts, which provided a lovely patched font I've used to the fullest here :]
- And lastly, everyone here who's using my config! Thank you for sticking around <3
