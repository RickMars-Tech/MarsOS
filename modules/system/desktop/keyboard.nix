{pkgs, ...}: {
  environment.systemPackages = with pkgs; [brightnessctl];
  services.actkbd = {
    enable = true;
    bindings = let
      bright = "${pkgs.brightnessctl}/bin/brightnessctl";
      step = "10";
    in [
      #= Backlight
      # Low
      {
        keys = [224];
        events = ["key"];
        command = "${bright} set ${step}%-";
      }
      # Up
      {
        keys = [225];
        events = ["key"];
        command = "${bright} set ${step}%+";
      }
    ];
  };
  console.keyMap = "la-latin1";
}
