{
  description = "Autarchy: Omarchy, ported to FyxOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fyxos = {
      url = "github:FyxOS/FyxOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stable: a pinned Omarchy release. latest: Omarchy's main branch.
    omarchy-stable = {
      url = "github:basecamp/omarchy/v4.0.4";
      flake = false;
    };
    omarchy-latest = {
      url = "github:basecamp/omarchy/quattro";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, fyxos, omarchy-stable, omarchy-latest }:
    let
      system = "x86_64-linux";
      module = import ./modules/autarchy.nix;
    in
    {
      nixosModules.stable = module omarchy-stable;
      nixosModules.latest = module omarchy-latest;
      nixosModules.default = self.nixosModules.stable;

      checks.${system}.stable = import ./tests/session.nix {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ fyxos.nixosModules.default self.nixosModules.stable ];
      };
    };
}
