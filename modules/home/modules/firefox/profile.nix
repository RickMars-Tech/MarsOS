{
  id = 0;
  name = "default";
  isDefault = true;
  search = {
    force = true;
    default = "ddg";
    order = ["ddg" "google"];
  };
  settings = import ./settings.nix;
}
