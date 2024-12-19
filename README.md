<div align = center>
<br>
# MarsOS❄️
<br>
 MarsOS is a simple way to replicate my setup on any NixOS system via a Flake. 
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
</div>

# Guide to Setup
<br>

Run this command to ensure Git are installed:
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
--This Flake is built specifically for Thinkpad/Intel systems, later I will add more modularity to support AMD systems but at the moment it should only be used for systems similar to mine (I use a Thinkpad T420) to avoid errors.

--The NixOS base must have been installed using GPT and UEFI since by default only Systemd-boot is supported, for GRUB you will have to edit the flake.

--Preferably Install a Minimal environment without DE.


# Special Thanks
<br>
Other configurations that I have learned a lot from:


**[Tyler Kelley ]**

**[Liassica]**

**[Ryan Yin]**
<br>

<!----------------------------------{ Thanks }--------------------------------->
[Tyler Kelley ]: https://gitlab.com/Zaney/zaneyos
[Liassica]: https://codeberg.org/Liassica/nixos-config
[Ryan Yin]: https://github.com/ryan4yin/nixos-and-flakes-book

