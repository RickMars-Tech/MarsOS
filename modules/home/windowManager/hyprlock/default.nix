{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      # BACKGROUND
      background {
          monitor =
          #blur_size = 5
          #blur_passes = 4
          path = ~/wallpapers/montaña.jpg
      }

      general {
          no_fade_in = true
          no_fade_out = true
          hide_cursor = true
          grace = 0
          disable_loading_bar = true
      }

      # DATE
      label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%A, %d %b")"
        color = rgba(255, 255, 255, 0.9)
        font_size = 60
        font_family = Adwaita Sans, thin
        position = 50, 375
        valign = center
        halign = left
      }

      # TIME
      label {
        monitor =
        text = cmd[update:1000] echo -e "$(date +"%H")"
        color = rgba(172, 166, 180, 1)
        font_size = 90
        font_family = Adwaita Sans, Heavy
        position = 50, 180
        valign = center
        halign = left
      }

      label {
        monitor =
        text = cmd[update:1000] echo -e "$(date +"%M")"
        color = rgba(255, 255, 255, 1)
        font_size = 90
        font_family = Adwaita Sans, Heavy
        position = 50, 45
        valign = center
        halign = left
      }

      background {
          monitor =
          zindex = 1
          keep_aspect_ratio = true
          rounding = 0
          border_size = 0
          path = ~/wallpapers/nix-over.png
      }

      # PSWD PROMPT
      input-field {
          monitor =
          size = 310, 80
          outline_thickness = 2
          outer_color = rgba(0, 0, 0, 0.15)
          inner_color = rgba(0, 0, 0, 0.15)
          font_color = rgba(255, 255, 255, 1)
          fade_on_empty = false
          rounding = 20
          dots_size = 0.15
          dots_spacing = 0.35
          dots_center = true
          check_color = rgba(255, 255, 255, 1)
          placeholder_text = <span foreground="##ffffff">Enter Password</span>
          hide_input = false
          font_family = Adwaita Sans, Italic
          position = 10, -420
          valign = center
          halign = left
          zindex = 1
      }
    '';
  };
}
