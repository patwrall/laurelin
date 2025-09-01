{ config
, lib
, pkgs
, ...
}:
{
  extraConfigLuaPre =
    lib.mkIf
      (
        config.plugins.snacks.enable
        && lib.hasAttr "profiler" config.plugins.snacks.settings
        && config.plugins.snacks.settings.profiler.enabled
      )
      (
        lib.mkOrder 1 # Lua
          ''
            if vim.env.PROF then
              local snacks = "${pkgs.vimPlugins.snacks-nvim}"
              vim.opt.rtp:append(snacks)
              require("snacks.profiler").startup({
                startup = {
                  event = "UIEnter",
                },
              })
            end
          ''

      );

  plugins = {
    snacks = {
      enable = true;

      settings = {
        profiler.enabled = true;
      };
    };
  };
}
