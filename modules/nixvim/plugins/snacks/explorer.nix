{ config
, lib
, ...
}:
lib.mkIf (config.laurelin.picker.engine == "snacks") {
  plugins.snacks.settings.explorer = {
    win = {
      width = 30;
      position = "left";
      border = "single";
      title = " Explorer";
      title_pos = "center";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>fe";
      action.__raw = "function() require('snacks').explorer({ cwd = laurelin.root() }) end";
      options.desc = "Explorer (root dir)";
    }
    {
      mode = "n";
      key = "<leader>fE";
      action.__raw = "function() require('snacks').explorer() end";
      options.desc = "Explorer (cwd)";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<leader>fe";
      options = {
        desc = "Explorer (root dir)";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<leader>fE";
      options = {
        desc = "Explorer (cwd)";
        remap = true;
      };
    }
  ];
}
