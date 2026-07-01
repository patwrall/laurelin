{ config
, lib
, ...
}:
lib.mkIf (config.laurelin.picker.tool == "snacks") {
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
  ];
}
