{
  description = "keytar";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";

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
