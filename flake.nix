{
  description = "Wrapped helix editor with custom configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    helix,
    wrappers,
    treefmt-nix,
    ...
  } @ inputs: let
    forAllSystems = with nixpkgs.lib; genAttrs platforms.all;
    # Use the built-in helix wrapper module
    helix = wrappers.wrappers.helix;
    treefmtEval = forAllSystems (
      system:
        treefmt-nix.lib.evalModule (import nixpkgs {inherit system;}) {
          programs.alejandra.enable = true;
        }
    );
  in {
    formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
    wrappers.default = helix;
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [(_: prev: {helix = inputs.helix.packages.${system}.default;})];
        };
        langs = import ./languages.nix {inherit pkgs;};
        editor = import ./editor.nix {lib = pkgs.lib;};
        keybinds = import ./keybinds.nix {inherit pkgs;};
      in {
        default = helix.wrap {
          inherit pkgs;
          extraPackages = langs.extraPackages ++ keybinds.extraPackages;
          languages.language = langs.language;
          languages.language-server = langs.language-server;
          settings = editor // {keys = keybinds.keys;};
        };
      }
    );
  };
}
