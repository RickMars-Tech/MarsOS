_: {
<<<<<<< HEAD
  # imports = [
  #   ./nix-ld.nix
  # ];

=======
>>>>>>> 46ceea6
  #= Enable Nix-Shell, Flakes and More...
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000; # Increases the Download Buffer to prevent it from filling up
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      sandbox = "relaxed";
      trusted-users = ["rick"];
    };
    #= Clean Nix
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
