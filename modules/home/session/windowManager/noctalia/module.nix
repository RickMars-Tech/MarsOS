{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optional mapAttrsToList;
  cfg = config.programs.noctalia-shell;

  jsonFormat = pkgs.formats.json {};
  tomlFormat = pkgs.formats.toml {};

  generateJson = name: value:
    if lib.isString value
    then pkgs.writeText "noctalia-${name}.json" value
    else if builtins.isPath value || lib.isStorePath value
    then value
    else jsonFormat.generate "noctalia-${name}.json" value;

  generateToml = name: value:
    if lib.isString value
    then pkgs.writeText "noctalia-${name}.toml" value
    else if builtins.isPath value || lib.isStorePath value
    then value
    else tomlFormat.generate "noctalia-${name}.toml" value;

  jsonOrPathType = types.oneOf [jsonFormat.type types.str types.path];
  tomlOrPathType = types.oneOf [tomlFormat.type types.str types.path];
in {
  options.programs.noctalia-shell = {
    enable = mkEnableOption "Noctalia shell";

    package = mkOption {
      type = types.nullOr types.package;
      default = pkgs.noctalia-shell;
      description = "The noctalia-shell package to use.";
    };

    # systemd.enable = mkEnableOption "Noctalia shell systemd service";
    # systemd.target = mkOption {
    #   type = types.str;
    #   default = "graphical-session.target";
    #   description = "Systemd target to bind the service to.";
    # };

    settings = mkOption {
      type = jsonOrPathType;
      default = {};
    };

    colors = mkOption {
      type = jsonOrPathType;
      default = {};
    };

    plugins = mkOption {
      type = jsonOrPathType;
      default = {};
    };

    user-templates = mkOption {
      type = tomlOrPathType;
      default = {};
    };

    pluginSettings = mkOption {
      type = types.attrsOf jsonOrPathType;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    # assertions = [
    #   {
    #     assertion = !cfg.systemd.enable || cfg.package != null;
    #     message = "noctalia-shell: package must not be null when systemd service is enabled.";
    #   }
    # ];

    environment.systemPackages = optional (cfg.package != null) cfg.package;

    security.pam.services.noctalia = {
      unixAuth = true;
      enableGnomeKeyring = true;
    };

    # systemd.user.services.noctalia-shell = mkIf cfg.systemd.enable {
    #   description = "Noctalia Shell - Wayland desktop shell";
    #   documentation = ["https://docs.noctalia.dev"];
    #   after = [cfg.systemd.target];
    #   partOf = [cfg.systemd.target];
    #   wantedBy = [cfg.systemd.target];
    #   restartTriggers =
    #     optional (cfg.settings != {}) (generateJson "settings" cfg.settings)
    #     ++ optional (cfg.colors != {}) (generateJson "colors" cfg.colors)
    #     ++ optional (cfg.plugins != {}) (generateJson "plugins" cfg.plugins)
    #     ++ optional (cfg.user-templates != {}) (generateToml "user-templates" cfg.user-templates)
    #     ++ mapAttrsToList (name: value: generateJson "${name}-settings" value) cfg.pluginSettings;
    #   environment = {
    #     PATH = lib.mkForce null;
    #   };
    #   serviceConfig = {
    #     ExecStart = lib.getExe cfg.package;
    #     Restart = "on-failure";
    #   };
    # };
    xdg.configFile =
      lib.filterAttrs (_: v: v != null) {
        "noctalia/settings.json" = mkIf (cfg.settings != {}) {
          source = generateJson "settings" cfg.settings;
        };
        "noctalia/colors.json" = mkIf (cfg.colors != {}) {
          source = generateJson "colors" cfg.colors;
        };
        "noctalia/plugins.json" = mkIf (cfg.plugins != {}) {
          source = generateJson "plugins" cfg.plugins;
        };
        "noctalia/user-templates.toml" = mkIf (cfg.user-templates != {}) {
          source = generateToml "user-templates" cfg.user-templates;
        };
      }
      # Plugin settings individuales
      // lib.mapAttrs' (
        name: value:
          lib.nameValuePair "noctalia/plugins/${name}/settings.json" {
            source = generateJson "${name}-settings" value;
          }
      )
      cfg.pluginSettings;
  };
}
