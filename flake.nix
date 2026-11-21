{
  description = "wired: a black-and-white NixOS rice for dev work and study";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      username = "akemi";
      hostname = "navi";
      flakePath = "/home/${username}/wired-nixos";
      theme = import ./theme;
      specialArgs = {
        inherit
          username
          hostname
          flakePath
          theme
          ;
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/navi
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              extraSpecialArgs = specialArgs;
              users.${username} = import ./home;
            };
          }
        ];
      };
    };
}
