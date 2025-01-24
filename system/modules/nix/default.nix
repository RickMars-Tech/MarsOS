{ inputs, ... }: {

    imports = [
        ./nix-ld.nix
    ];

    #= Enable Nix-Shell, Flakes and More...
    nix = {
        settings = {
            sandbox = true;
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = ["rick"];
            substituters = [
                "https://hyprland.cachix.org"
            ];
            trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
        };
    #= Clean Nix
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 1w";
        };
    #= Extra
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
}
