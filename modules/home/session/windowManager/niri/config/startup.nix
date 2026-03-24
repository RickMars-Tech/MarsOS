{
  programs.niri.settings._children = [
    {spawn-at-startup = "systemctl --user reset-failed";}
    {spawn-at-startup = "systemctl --user show-environment | grep -v '^_=' | cut -d= -f1 | xargs systemctl --user import-environment";}
    {spawn-at-startup = ["noctalia-shell" "-d"];}
    {spawn-at-startup = ["wl-paste" "--watch" "cliphist" "store"];}
    {spawn-at-startup = ["wl-paste" "--type text" "--watch" "cliphist" "store"];}
  ];
}
