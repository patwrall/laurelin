{ config, lib, ... }:
{
  # mini.pairs disabled — blink-pairs handles autopairs
  plugins.mini.modules = lib.mkIf (!config.plugins.blink-pairs.enable) {
    pairs = { };
  };
}
