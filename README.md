<h1 align="center">:snowflake: MarsOS :snowflake:</h1>
<p align="center"> 
 MarsOS is a simple way to replicate my setup on any NixOS system via a Flake.

</p>

</div>

![](./assets/niri-overview.png)

![](./assets/niri-term.png)

- Wallpaper: [Bochi Rock Linux](https://imgur.com/bochi-rock-linux-wallpaper-mO5tavs)
- OG Wallpaper: [Bocchi Runner 2049 by Carlo Montie](https://www.pixiv.net/en/artworks/108083186) 

<details>
<summary>Environment Software</summary>

|                             | NixOS(Wayland)                                  |
| --------------------------- | ----------------------------------------------- |
| **Window Manager**          | [Niri][Niri]                                    |
| **Terminal Emulator**       | [Wezterm][Wezterm] + [Zellij][Zellij]           |
| **Bar**                     | [Ironbar][Ironbar] + [BongoCat][BongoCat]       |
| **Application Launcher**    | [Fuzzel][Fuzzel]                                |
| **Notification Daemon**     | [SwayNC][SwayNC]                                |
| **Session Manager**         | [GreetD][GreetD] + [TuiGreet][TuiGreet]         |
| **Network Management Tool** | [IWD][IWD] + [NetworkManager][NetworkManager]   |
| **System Resource Monitor** | [Bottom][Bottom] & [Zenith][Zenith]             |
| **File Manager**            | [Yazi][Yazi] & [Nautilus][Nautilus]             |
| **Shell**                   | [Fish][Fish]                                    |
| **Text Editor**             | [Helix][Helix]                                  |
| **Fonts**                   | [Nerd fonts][Nerd fonts]                        |
| **Image Viewer**            | [IMV][IMV]                                      |
| **Multimedia Player**       | [MPV][MPV]                                      |

</details>

# Guide to Setup
<br>

Use Git with to clone the Repo:
```bash
nix run nixpkgs#git -- clone https://github.com/RickMars-Tech/MarsOS.git
```

Update the Flake(Optional):
```bash
sudo nix flake update
```

Change Directorie and Generate Hardware Config:
```bash
cd MarsOS/
sudo nixos-generate-config --show-hardware-config > ./hosts/{Host-Directory}/hardware.nix
```

Rebuild System:
```bash
sudo nixos-rebuild boot --flake .#{host}
```

<br>


# Important.
1. This Flake is created specifically for my systems (boltz and rift), you can create your own configuration through the options I create, editing configuration files and/or creating your own modifications, feel free to copy/take the configurations you want.
2. I use the Default Boot Loader Systemd-boot, I have no plans to create modules/configurations for GRUB, so you will have to configure it yourself if you want to use it.
3. Preferably Install a Minimal environment without DE.


# References

Configurations that have inspired and taught me a lot (Sorry for stealing from you guys):

**[Gvolpe]**

**[Tyler Kelley]**

**[Liassica]**

**[Ryan Yin]**

<!----------------------------------{ Thanks }--------------------------------->
[Gvolpe]: https://github.com/Rexcrazy804/Zaphkiel
[Tyler Kelley]: https://gitlab.com/Zaney/zaneyos
[Liassica]: https://codeberg.org/Liassica/nixos-config
[Ryan Yin]: https://github.com/ryan4yin/nixos-and-flakes-book

<!--------------------------------{ Components }------------------------------->
[Niri]: https://github.com/YaLTeR/niri
[Wezterm]: https://wezterm.org/
[Ironbar]: https://github.com/JakeStanger/ironbar
[BongoCat]: https://github.com/saatvik333/wayland-bongocat
[Zellij]: https://zellij.dev/
[Fuzzel]: https://codeberg.org/dnkl/fuzzel
[SwayNC]: https://github.com/ErikReider/SwayNotificationCenter
[GreetD]: https://sr.ht/~kennylevinsen/greetd/
[TuiGreet]: https://github.com/apognu/tuigreet
[IWD]: https://git.kernel.org/pub/scm/network/wireless/iwd.git
[NetworkManager]: https://gitlab.freedesktop.org/NetworkManager/NetworkManager
[Bottom]: https://github.com/ClementTsang/bottom
[Zenith]: https://github.com/bvaisvil/zenith
[Yazi]: https://github.com/sxyazi/yazi
[Nautilus]: https://apps.gnome.org/Nautilus/
[Fish]: https://fishshell.com/
[Helix]: https://helix-editor.com/
[Nerd fonts]: https://www.nerdfonts.com/
[IMV]: https://sr.ht/~exec64/imv/
[MPV]: https://mpv.io/
[Nix-ArtWork]: https://github.com/NixOS/nixos-artwork
