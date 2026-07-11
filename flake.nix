{

   description = "Flake one";

   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
   };

   outputs = { self, nixpkgs, ... }:
     let
       lib = nixpkgs.lib;
     in {
     nixosConfigurations = {
       frbl-x1-nixos = lib.nixosSystem {
         system = "x86_64-linux";
	 modules = [ ./configuration.nix ];
       };
     };
   };
}
