{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkDefault mkOption mkMerge mkIf types trim toKDL concatStringsSep optional optionalString getExe;
  cfg = config.programs.niri;
in {
  disabledModules = ["programs/wayland/niri.nix"];

  options.programs.niri = {
    enable = mkEnableOption "Niri, a scrollable-tiling Wayland compositor";

    package = mkPackageOption pkgs "niri" {};

    useNautilus =
      mkEnableOption "Nautilus as file-chooser for xdg-desktop-portal-gnome"
      // {
        default = true;
      };

    xwaylandSatellitePackage = mkPackageOption pkgs "xwayland-satellite" {
      nullable = true;
      extraDescription = "Set to `null` to disable XWayland support.";
    };

    withUWSM =
      mkEnableOption "UWSM support"
      // {
        default = false;
        description = ''
          Launch Niri with the Universal Wayland Session Manager. This has better
          systemd support and automatically starts `graphical-session.target` and
          `wayland-session@niri.target`.
        '';
      };

    withXDG =
      mkEnableOption "XDG portal support"
      // {
        default = true;
        description = "Enable XDG portal support for Niri.";
      };

    settings = mkOption {
      type = with types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {description = "KDL value";};
      in
        submodule {
          options._children = mkOption {
            type = listOf anything;
            default = [];
          };
          freeformType = attrsOf valueType;
        };
      default = {};
      description = "Niri configuration as Nix attrs, converted to KDL.";
    };

    checkConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Validate the generated config.kdl using `niri validate`.";
    };

    extraConfigEarly = mkOption {
      type = types.lines;
      default = "";
      description = "KDL lines prepended before the generated settings.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "KDL lines appended after the generated settings.";
    };
  };

  config = mkIf cfg.enable (let
    settings = trim (toKDL cfg.settings);
    text = concatStringsSep "\n" (lib.filter (s: s != "") [
      (optionalString (cfg.extraConfigEarly != "") cfg.extraConfigEarly)
      (optionalString (settings != "") settings)
      (optionalString (cfg.extraConfig != "") cfg.extraConfig)
    ]);
    configFile = pkgs.writeTextFile {
      name = "niri-config.kdl";
      inherit text;
      checkPhase = optionalString cfg.checkConfig ''
        ${getExe cfg.package} validate --config "$target"
      '';
    };
  in
    mkMerge [
      {
        environment.systemPackages =
          [cfg.package]
          ++ optional (cfg.xwaylandSatellitePackage != null) cfg.xwaylandSatellitePackage
          ++ optional (cfg.useNautilus) pkgs.nautilus;

        services.dbus.packages = mkIf cfg.useNautilus [pkgs.nautilus];

        services = {
          displayManager.sessionPackages = mkIf (!cfg.withUWSM) [cfg.package];
          gnome.gnome-keyring.enable = lib.mkDefault true;
          graphical-desktop.enable = true;
          xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
        };

        security.polkit.enable = true;
        programs = {
          dconf.enable = mkDefault true;
          nautilus-open-any-terminal.enable = cfg.useNautilus;
        };
        systemd.packages = mkIf (!cfg.withUWSM) [cfg.package];

        # system.extraDependencies = optional (text != "") configFile;
        # xdg.configFile."niri/config.kdl" = mkIf (text != "") {
        #   source = configFile;
        # };
        environment.etc."niri/config.kdl" = mkIf (text != "") {
          source = configFile;
        };
      }

      (mkIf cfg.withUWSM {
        programs.uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "A scrollable-tiling Wayland compositor";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      })

      (mkIf cfg.withXDG {
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = mkDefault true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          configPackages = [cfg.package];
        };
      })
    ]);
}
