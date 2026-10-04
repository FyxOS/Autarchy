{
  description = "Hyprland - Omarchy: Omarchy, ported to Omnix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    omnix = {
      url = "github:Omnix-Linux/Omnix";
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

  outputs = { self, nixpkgs, omnix, omarchy-stable, omarchy-latest }:
    let
      system = "x86_64-linux";
      module = import ./modules/autarchy.nix;
    in
    {
      nixosModules.stable = module omarchy-stable;
      nixosModules.latest = module omarchy-latest;
      nixosModules.default = self.nixosModules.stable;

      checks.${system} = nixpkgs.lib.genAttrs [ "stable" "latest" ] (variant:
        import ./tests/session.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ omnix.nixosModules.default self.nixosModules.${variant} ];
        });
    };
}
