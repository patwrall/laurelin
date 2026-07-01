{ lib
, self
, inputs
, ...
}:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) foldlAttrs;
  inherit (lib.lists) optional;
  pluginsPath = ./plugins;
in
{
  imports = (foldlAttrs
    (
      prev: name: type:
        prev ++ optional (type == "directory") (pluginsPath + "/${name}")
    ) [ ]
    (readDir pluginsPath))
  ++
  [
    # keep-sorted start
    ../laurelin/options.nix
    ./autocommands.nix
    ./diagnostics.nix
    ./keymaps.nix
    ./lsp.nix
    ./lua.nix
    ./options.nix
    ./performance.nix
    # keep-sorted end
  ];

  nixpkgs = {
    overlays = lib.attrValues self.overlays;
    source = inputs.nixpkgs;
    config = {
      allowUnfree = true;
      # FIXME: pnpm 9 unsafe ignore for stylelint-lsp
      permittedInsecurePackages = [
        "pnpm-9.15.9"
      ];
    };
  };
}
