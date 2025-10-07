{ config
, lib
, ...
}:
{
  plugins.cord = {
    enable = true;

    lazyLoad.settings = {
      event = [
        "DeferredUIEnter"
      ];
    };

    settings = {
      idle = {
        enabled = false;
      };
    };
  };

  keymaps = lib.optionals config.plugins.cord.enable [
    {
      mode = "n";
      key = "<leader>ude";
      action = "<cmd>Cord enable<CR>";
      options = {
        desc = "Enable Discord Presence";
      };
    }
    {
      mode = "n";
      key = "<leader>udd";
      action = "<cmd>Cord disable<CR>";
      options = {
        desc = "Disable Discord Presence";
      };
    }
  ];
}
