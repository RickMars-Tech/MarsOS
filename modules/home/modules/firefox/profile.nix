{
  id = 0;
  name = "default";
  isDefault = true;
  search = {
    force = true;
    engines = import ./search-engines.nix;
    default = "Startpage";
  };
  containersForce = true;
  containers = {
    sinenomine = {
      id = 1;
      icon = "chill";
      color = "purple";
    };
    nublado = {
      id = 2;
      icon = "chill";
      color = "blue";
    };
  };
  settings = import ./settings.nix;
}
