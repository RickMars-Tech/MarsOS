{ pkgs, ... }: {

#= Service
    services.printing = {
        enable = true;
        drivers = with pkgs; [
            gutenprint
            #hplipWithPlugin
            hplip
        ];
    };

#= Packages
    environment.systemPackages = with pkgs; [
        hplip
    ];
}
