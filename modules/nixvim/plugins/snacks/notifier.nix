{ config, lib, ... }:
{
  plugins.snacks.settings.notifier = {
    enabled = true;
    style = "fancy";
  };

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>un";
      action = "<cmd>lua Snacks.notifier.hide()<CR>";
      options.desc = "Dismiss All Notifications";
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>lua Snacks.notifier.show_history()<CR>";
      options.desc = "Find Notifications";
    }
  ];
}
