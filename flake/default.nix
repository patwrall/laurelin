{ inputs
, lib
, self
, ...
}:
{
  imports = [
    ./apps.nix
    ./nixvim.nix
    ./overlays.nix
    ./pkgs-by-name.nix
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions = {
    dev = {
      module = ./dev;
      extraInputsFlake = ./dev;
    };
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };

  perSystem =
    { config
    , system
    , ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config = {
          allowUnfree = true;
          # FIXME: breaks git-hooks-nix installation
          # allowAliases = false;
        };
      };

      packages.default = config.packages.laurelin;
    };
}
