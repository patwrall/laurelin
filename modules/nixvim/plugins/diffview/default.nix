{ config, lib, ... }:
{
  plugins.diffview = {
    enable = true;

    lazyLoad.settings = {
      ft = "diff";
      cmd = [ "DiffviewOpen" "DiffviewClose" "DiffviewFileHistory" ];
    };
  };

  keymaps = lib.mkIf config.plugins.diffview.enable [
    {
      mode = "n";
      key = "<leader>gdv";
      action.__raw = ''
        function()
          local ok, lib = pcall(require, "diffview.lib")
          local has_view = ok and lib.get_current_view() ~= nil
          if has_view then
            vim.cmd('DiffviewClose')
          else
            vim.cmd('DiffviewOpen')
          end
        end
      '';
      options.desc = "Toggle Diffview";
    }
    {
      mode = "n";
      key = "<leader>gdh";
      action = "<cmd>DiffviewFileHistory %<CR>";
      options.desc = "File History";
    }
    {
      mode = "n";
      key = "<leader>gdH";
      action = "<cmd>DiffviewFileHistory<CR>";
      options.desc = "Branch History";
    }
  ];
}
