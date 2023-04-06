{
  description = "A very basic flake";

  inputs = { utils.url = "github:numtide/flake-utils"; };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        backendApp = pkgs.buildGoModule {
          name = "backend";
          src = ./backend;
          vendorSha256 = "sha256-sGSBPztiLa0Ngq8zHIZUoqeQJ0CYivDcJl5/fnhZ/+0=";
        };
        corePackages = with pkgs; [ nodejs-slim-19_x nodePackages.pnpm ];
      in {
        # packages
        packages.frontendContainer = pkgs.dockerTools.buildImage {
          name = "nix-docker-frontend";
          tag = "latest";
          created = "now";
          config = { Cmd = [ "${pkgs.nodejs-slim-19_x}/bin/node" ]; };
        };
        packages.backendContainer = pkgs.dockerTools.buildImage {
          name = "nix-docker-backend";
          tag = "latest";
          created = "now";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ backendApp ];
            pathsToLink = [ "/bin" ];
          };
          config = { Cmd = [ "/bin/nix-docker-example-backend" ]; };
        };
        # dev environment
        devShells.dev = pkgs.mkShell { packages = corePackages; };
        devShells.test =
          pkgs.mkShell { packages = corePackages ++ (with pkgs; [ hello ]); };
        devShells.deploy =
          pkgs.mkShell { packages = corePackages ++ (with pkgs; [ sshpass ]); };

      });
}
