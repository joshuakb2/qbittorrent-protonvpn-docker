{
  description = "Joshua's protonvpn-protected qbittorrent docker cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosModules.qbittorrent-container = import ./module.nix;
      nixosModules.default = self.nixosModules.qbittorrent-container;
    };
}
