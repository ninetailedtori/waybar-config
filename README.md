# waybar-config
My personal Waybar config!

## How to use
1. Install waybar, and the requisite packages for it as well.
2. Copy the required .config/waybar files to your .config/waybar directory.
3. Rename the sway, sway-hide or hyprland configs to config.jsonc unless you want to generate custom services like I did hahah. I'll post the custom services as well, which will be in .services, but you'll need to install them yourself, into the `~/.config/systemd/user/` directory.
4. Copy the .local/share/bin files to your .local/share/bin directory.
5. Run `chmod +x ~/.local/share/bin/*`, to allow execution of all the scripts in the directory.
6. Restart waybar and enjoy!
