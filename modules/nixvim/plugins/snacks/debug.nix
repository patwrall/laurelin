{ config, lib, ... }:
{
  extraConfigLuaPre = lib.mkIf config.plugins.snacks.enable ''
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function() Snacks.debug.backtrace() end
    vim.print = dd
  '';

  plugins.snacks.settings.debug.enabled = true;

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>dX";
      action = "<cmd>lua Snacks.debug.run()<CR>";
      options.desc = "Run Buffer";
    }
    {
      mode = "x";
      key = "<leader>dX";
      action = "<cmd>lua Snacks.debug.run()<CR>";
      options.desc = "Run Selection";
    }
    {
      mode = "n";
      key = "<leader>dS";
      action = "<cmd>lua Snacks.debug.stats()<CR>";
      options.desc = "Show Debug Stats";
    }
  ];
}
