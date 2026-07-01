{ config, ... }:
{
  plugins = {
    telescope = {
      enable = config.laurelin.editor.telescope;
      lazyLoad.settings.cmd = [
        "Telescope"
      ];
    };
  };
}
