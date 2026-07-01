{ config, lib, ... }:
{
  plugins.inc-rename = {
    enable = true;

    lazyLoad.settings.event = [ "DeferredUIEnter" ];

    settings = {
      cmd_name = "IncRename";
      hl_group = "Substitute";
      preview_empty_name = false;
      show_message = true;
      save_in_cmdline_history = true;
      input_buffer_type = "snacks";
    };
  };

  keymaps = lib.optionals config.plugins.inc-rename.enable [
    {
      mode = "n";
      key = "grn";
      action.__raw = ''
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end
      '';
      options = { expr = true; desc = "Rename Symbol"; };
    }
    {
      mode = "n";
      key = "gR";
      action.__raw = ''
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end
      '';
      options = { expr = true; desc = "Start IncRename"; };
    }
  ];
}
