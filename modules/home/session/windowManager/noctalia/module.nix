{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optional;
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
    environment.systemPackages = optional (cfg.package != null) cfg.package;

    security.pam.services.noctalia = {
      unixAuth = true;
      enableGnomeKeyring = true;
    };

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
