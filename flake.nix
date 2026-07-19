{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pkgs-by-name.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        imports = [ inputs.pkgs-by-name.flakeModule ];

        systems = lib.systems.flakeExposed;

        perSystem = { pkgs, ... }: {
          pkgsDirectory = ./nix/pkgs;

          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              gradle_8
              jdk25
            ];
          };
        };
      }
    );
}
