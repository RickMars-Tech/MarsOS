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
              # Usar el paquete de nixpkgs en vez de "nix run github:..." :
              # el wrapper no tiene "nix" en PATH, requeriría red/build y
              # superaba el timeout, por lo que el MCP nunca arrancaba.
              command = [ (pkgs.lib.getExe pkgs.mcp-nixos) ];
              enabled = true;
              timeout = 20000;
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
