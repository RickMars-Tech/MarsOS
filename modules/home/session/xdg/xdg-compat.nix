{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.xdg;
  fileType = lib.types.submodule {
    options = {
      text = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
      };
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
      mutable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If true, copy the file instead of symlinking, allowing the application to modify it";
      };
      recursive = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If true, symlink each file inside the source directory individually";
      };
    };
  };
  userOpts = _: {
    options = {
      configFiles = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      cacheFiles = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      dataFiles = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      stateFiles = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      homeFiles = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
    };
  };
  mkLinkScript = baseDir: name: file: let
    target =
      if file.text != null
      then pkgs.writeText name file.text
      else file.source;
    fullPath = "${baseDir}/${name}";
    parentDir = builtins.dirOf fullPath;
  in
    if file.recursive
    then ''
      mkdir -p "${fullPath}"
      chown ${username}:users "${fullPath}"
      for f in "${target}"/*; do
        [ -e "$f" ] || continue
        ln -sf "$f" "${fullPath}/$(basename "$f")"
      done
    ''
    else if file.mutable
    then ''
      mkdir -p "${parentDir}"
      chown ${username}:users "${parentDir}"
      if [ -L "${fullPath}" ]; then
        rm -f "${fullPath}"
        cp "${target}" "${fullPath}"
        chown ${username}:users "${fullPath}"
        chmod +w "${fullPath}"
      elif [ -e "${fullPath}" ]; then
        :
      else
        cp "${target}" "${fullPath}"
        chown ${username}:users "${fullPath}"
        chmod +w "${fullPath}"
      fi
    ''
    else ''
      if [ -L "${parentDir}" ]; then
        rm -f "${parentDir}"
      fi
      mkdir -p "${parentDir}"
      chown ${username}:users "${parentDir}"
      ln -sf "${target}" "${fullPath}"
    '';
in {
  options = {
    users.users = lib.mkOption {type = lib.types.attrsOf (lib.types.submodule userOpts);};
    home = {
      homeDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/home/${username}";
      };
      file = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
    };
    xdg = {
      configHome = lib.mkOption {
        type = lib.types.path;
        default = "/home/${username}/.config";
      };
      cacheHome = lib.mkOption {
        type = lib.types.path;
        default = "/home/${username}/.cache";
      };
      dataHome = lib.mkOption {
        type = lib.types.path;
        default = "/home/${username}/.local/share";
      };
      stateHome = lib.mkOption {
        type = lib.types.path;
        default = "/home/${username}/.local/state";
      };
      runtimeDir = lib.mkOption {
        type = lib.types.str;
        default = "/run/user/1000";
      };
      configFile = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      cacheFile = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      dataFile = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
      stateFile = lib.mkOption {
        type = lib.types.attrsOf fileType;
        default = {};
      };
    };
  };
  config = {
    users.users.${username} = {
      configFiles = cfg.configFile;
      cacheFiles = cfg.cacheFile;
      dataFiles = cfg.dataFile;
      stateFiles = cfg.stateFile;
      homeFiles = config.home.file;
    };
    environment.sessionVariables = {
      XDG_CONFIG_HOME = cfg.configHome;
      XDG_CACHE_HOME = cfg.cacheHome;
      XDG_DATA_HOME = cfg.dataHome;
      XDG_STATE_HOME = cfg.stateHome;
    };
    system.activationScripts.xdgUserFiles = lib.stringAfter ["users"] ''
      ${lib.concatStringsSep "\n" (
        lib.flatten (
          lib.mapAttrsToList (
            user: userCfg:
              (lib.mapAttrsToList (mkLinkScript cfg.configHome) userCfg.configFiles)
              ++ (lib.mapAttrsToList (mkLinkScript cfg.cacheHome) userCfg.cacheFiles)
              ++ (lib.mapAttrsToList (mkLinkScript cfg.dataHome) userCfg.dataFiles)
              ++ (lib.mapAttrsToList (mkLinkScript cfg.stateHome) userCfg.stateFiles)
              ++ (lib.mapAttrsToList (mkLinkScript config.home.homeDirectory) userCfg.homeFiles)
          )
          config.users.users
        )
      )}
    '';
  };
}
