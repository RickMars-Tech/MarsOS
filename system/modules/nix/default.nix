{ inputs, ... }: {

    imports = [
        ./nix-ld.nix
        ./nix-index.nix
    ];

    #= Enable Nix-Shell, Flakes and More...
    nix = {
        settings = {
            sandbox = true;
            auto-optimise-store = true;
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = ["rick"];
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
