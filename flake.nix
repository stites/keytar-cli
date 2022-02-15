{
  description = "keytar";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.flake-utils.follows = "utils";
  inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, utils, devshell }:
    { overlay = final: prev: {
        keytar-cli = (prev.callPackage ./. { pkgs=prev; }).package;
    }; } // (utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
	overlays = [ devshell.overlay ];
      };
    in {
      defaultPackage = (pkgs.callPackage ./. { inherit pkgs system; }).package;
      devShell = pkgs.devshell.mkShell {
        commands = [{
	  name = "update-nix";
	  command = ''
	    ${pkgs.yarn}/bin/yarn install
	    ${pkgs.yarn2nix}/bin/yarn2nix > ./yarn.nix
	  '';
	}];
      };
    }));
}
