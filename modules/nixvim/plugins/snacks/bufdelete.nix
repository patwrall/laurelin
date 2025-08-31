{ config
, lib
, ...
}:
{
  plugins = {
    snacks = {
      enable = true;

      settings = {
        bufdelete.enabled = true;
      };
    };
  };

  keymaps =
    lib.mkIf
      (config.plugins.snacks.enable
        && lib.hasAttr "bufdelete" config.plugins.snacks.settings
        && config.plugins.snacks.settings.bufdelete.enabled)
      [
        {
          mode = "n";
          key = "<leader>bd";
          action = "<cmd>lua Snacks.bufdelete.delete()<cr>";
          options.desc = "Close Buffer";
        }
      ];
}
