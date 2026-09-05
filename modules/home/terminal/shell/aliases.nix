{
  flake.modules.nixos.alss =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) getExe;
    in
    {
      environment.shellAliases = {
        # Stats
        top = "${getExe pkgs.bottom} -m";
        nfetch = "${getExe pkgs.nerdfetch}";

        # Files & Archive Management
        grep = "${getExe pkgs.ripgrep} --color=auto";
        cat = "${getExe pkgs.bat} --style header --style snip --style changes";
        man = "${getExe pkgs.bat-extras.batman}";
        la = "${getExe pkgs.eza} -a --color=always --group-directories-first --grid --icons auto";
        ls = "${getExe pkgs.eza} -al --color=always --group-directories-first --grid --icons auto";
        ll = "${getExe pkgs.eza} -l --color=always --group-directories-first --octal-permissions --icons auto";
        lt = "${getExe pkgs.eza} -aT --color=always --group-directories-first --icons auto";
        tree = "${getExe pkgs.eza} -T --all --icons auto";
        cp = "${getExe pkgs.xcp}";
        search = "${getExe pkgs.skim} --ansi";
        restore = "${getExe pkgs.trashy} -r ";
        ls-trash = "${getExe pkgs.trashy} list";
        clc-trash = "${getExe pkgs.trashy} empty --all";
        clc = "clear";
        untar = "tar -xvf";
        untargz = "tar -xzvf";
        untarxz = "tar -xJvf";

        # Disk Usage
        du = "${getExe pkgs.dust}"; # Better disk usage analyzer
        df = "${getExe pkgs.duf}"; # Better df alternative

        # See Governor used
        see-governor = "${getExe pkgs.bat} --style plain /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";

        # Macchanger
        changemac = "${getExe pkgs.macchanger} -r"; # = Generates a random MAC and sets it
        resetmac = "${getExe pkgs.macchanger} -p"; # = Resets the MAC address to the permanent

        yt-dwl-music = ''${getExe pkgs.yt-dlp} -x --audio-format mp3 -o "%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" '';
        yt-dwl-video = ''${getExe pkgs.yt-dlp} -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 -o "%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" '';

        bonsai = "${getExe pkgs.cbonsai} -l -i";
      };
    };
}
