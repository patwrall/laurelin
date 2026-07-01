{ config, lib, ... }:
{
  plugins.snacks.settings.terminal = {
    enabled = true;
    win = {
      style = "terminal";
      wo.winhighlight = "Normal:Normal,NormalNC:Normal,SignColumn:Normal";
    };
    shell.__raw = "vim.fn.exepath('fish') ~= '' and vim.fn.exepath('fish') or vim.fn.getenv('SHELL')";
  };

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<C-/>";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options.desc = "Toggle Terminal";
    }
    {
      mode = "t";
      key = "<C-/>";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options.desc = "Toggle Terminal";
    }
    {
      mode = "n";
      key = "<leader>ueT";
      action = "<cmd>lua Snacks.terminal.toggle()<CR>";
      options.desc = "Toggle Terminal";
    }
  ];
}
