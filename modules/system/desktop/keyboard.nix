{pkgs, ...}: {
  environment.systemPackages = with pkgs; [brightnessctl];
  services.actkbd = {
    enable = true;
    bindings = let
      bright = "${pkgs.brightnessctl}/bin/brightnessctl";
      step = "10";
    in [
      #= Backlight
      {
        keys = [224];
        events = ["key"];
        # -N is used to ensure that value >= minBrightness
        command = "${bright} set ${step}%-";
      }
      {
        keys = [225];
        events = ["key"];
        command = "${bright} set ${step}%+";
      }
    ];
  };
}
