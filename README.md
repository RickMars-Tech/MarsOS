<h1 align="center">:snowflake: MarsOS :snowflake:</h1>
<p align="center"> 
 MarsOS is a simple way to replicate my setup on any NixOS system via a Flake.

 [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
<p/>

</div>

![](./img/wezterm.png)

![](./img/fuzzel.png)

![](./img/desktop.png)

![](./img/niri.png)

## Components

|                             | NixOS(Wayland)                                                                                                      |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Window Manager**          | [Niri][Niri]                                                                                                        |
| **Terminal Emulator**       | [Wezterm][Wezterm]                                                                                                  |
| **Bar**                     | [Waybar][Waybar]                                                                                                    |
| **Application Launcher**    | [Fuzzel][Fuzzel]                                                                                                    |
| **Notification Daemon**     | [Dunst][Dunst]                                                                                                      |
| **Display Manager**         | [GreetD][GreetD] + [TuiGreet][TuiGreet]                                                                             |
| **Network Management Tool** | [IWD][IWD] + [NetworkManager][NetworkManager]                                                                       |
| **System resource monitor** | [Bottom][Bottom]                                                                                                    |
| **File Manager**            | [Yazi][Yazi] & [Nautilus][Nautilus]                                                                                 |
| **Shell**                   | [Fish][Fish]                                                                                                        |
| **Media Player**            | [MPV][MPV]                                                                                                          |
| **Text Editor**             | [Helix][Helix]                                                                                                      |
| **Fonts**                   | [Nerd fonts][Nerd fonts]                                                                                            |
| **Image Viewer**            | [IMV][IMV]                                                                                                          |
| **Wallpaper**               | [Nix-ArtWork][Nix-ArtWork]                                                                                          |


# Guide to Setup
<br>

Install git with Nix-shell:
```bash
nix-shell -p git
```

Clone the Repo:
```bash
git clone https://github.com/RickMars-Tech/MarsOS.git
cd MarsOS
```

Give permissions to the script and Run it:
```bash
sudo chmod +x setup
./setup
```
<br>


# Important.
1. This Flake is built specifically for Thinkpad/Intel systems, later I will add more modularity to support AMD systems but at the moment it should only be used for systems similar to mine (I use a Thinkpad T420) to avoid errors.
2. The NixOS base must have been installed using GPT and UEFI since by default only Systemd-boot is supported, for GRUB you will have to edit the flake.
3. Preferably Install a Minimal environment without DE.


# References

Thanks to these folks who have inspired me and taught me a lot:

**[Tyler Kelley ]**

**[Liassica]**

**[Ryan Yin]**

<!----------------------------------{ Thanks }--------------------------------->
[Tyler Kelley ]: https://gitlab.com/Zaney/zaneyos
[Liassica]: https://codeberg.org/Liassica/nixos-config
[Ryan Yin]: https://github.com/ryan4yin/nixos-and-flakes-book

<!--------------------------------{ Components }------------------------------->
[Niri]: https://github.com/YaLTeR/niri
[Wezterm]: https://wezterm.org/
[Waybar]: https://github.com/Alexays/Waybar
[Fuzzel]: https://codeberg.org/dnkl/fuzzel
[Dunst]: https://github.com/dunst-project/dunst
[GreetD]: https://sr.ht/~kennylevinsen/greetd/
[TuiGreet]: https://github.com/apognu/tuigreet
[IWD]: https://git.kernel.org/pub/scm/network/wireless/iwd.git
[NetworkManager]: https://gitlab.freedesktop.org/NetworkManager/NetworkManager
[Bottom]: https://github.com/ClementTsang/bottom
[Yazi]: https://github.com/sxyazi/yazi
[Nautilus]: https://github.com/GNOME/nautilus
[Fish]: https://fishshell.com/
[MPV]: https://github.com/mpv-player/mpv
[Helix]: https://helix-editor.com/
[Nerd fonts]: https://www.nerdfonts.com/
[IMV]: https://sr.ht/~exec64/imv/
[Nix-ArtWork]: https://github.com/NixOS/nixos-artwork
