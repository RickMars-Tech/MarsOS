{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.opencode =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myOpencode
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.myOpencode = inputs.wrapper-modules.wrappers.opencode.wrap {
        inherit pkgs;
        settings = {
          mcp = {
            nixos = {
              type = "local";
              command = [
                "nix"
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
              enabled = true;
              timeout = 10000;
            };
            gh_grep = {
              type = "remote";
              url = "https://mcp.grep.app/";
              enabled = true;
              timeout = 10000;
            };
            deepwiki = {
              type = "remote";
              url = "https://mcp.deepwiki.com/mcp";
              enabled = true;
              timeout = 10000;
            };
            context7 = {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
              enabled = true;
              timeout = 10000;
            };
          };
        };
      };
    };
}
