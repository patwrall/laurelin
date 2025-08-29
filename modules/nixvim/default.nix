{ lib
, self
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
    ./keymaps.nix
    ./options.nix
    # keep-sorted end
  ];

  nixpkgs = {
    overlays = lib.attrValues self.overlays;
    config.allowUnfree = true;
  };
}
