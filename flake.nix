{
  description = "keytar";

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      defaultPackage = (pkgs.callPackage ./. { inherit pkgs system; }).package;
    }) // {
      overlay = final: prev: {
        keytar-cli = (prev.callPackage ./. { pkgs=prev; }).package;
      };
    };
}
