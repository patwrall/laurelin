{ config
, lib
, pkgs
, ...
}:
{
  plugins.cord = {
    enable = true;

    package = pkgs.vimPlugins.cord-nvim.overrideAttrs (_: {
      nvimRequireCheck = false;
    });

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
