{ lib
, self
, ...
}: {
  nixpkgs = {
    overlays = lib.attrValues self.overlays;
    config.allowUnfree = true;
  };
}
