{ config, lib, ... }:
{
  plugins.snacks.settings.zen.enabled = true;

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>usZ";
      action = "<cmd>lua Snacks.toggle.zen():toggle()<CR>";
      options.desc = "Toggle Zen Mode";
    }
    {
      mode = "n";
      key = "<leader>usz";
      action = "<cmd>lua Snacks.toggle.zoom():toggle()<CR>";
      options.desc = "Toggle Zoom (Maximize)";
    }
  ];
}
