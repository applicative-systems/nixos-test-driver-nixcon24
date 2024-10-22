{
  description = "NixOS Integration Test Driver Demo for Nixcon 2024";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    perSystem = { pkgs, system, ... }: {

      packages.default = pkgs.testers.runNixOSTest ./test.nix;

      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ (import ./overlay.nix) ];
        config = { };
      };
    };
  };
}