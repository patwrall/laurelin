{ config, lib, ... }:
{
  plugins.blink-pairs = {
    enable = true;

    lazyLoad.settings.event = [ "BufReadPost" "BufNewFile" ];
  };

  keymaps = lib.mkIf config.plugins.blink-pairs.enable [
    {
      key = "<leader>uep";
      mode = "n";
      action.__raw = ''
        function()
          vim.b.blink_pairs = vim.b[0].blink_pairs == false
          vim.notify("Buffer AutoPairs " .. (vim.b[0].blink_pairs ~= false and "enabled" or "disabled"), vim.log.levels.INFO)
        end
      '';
      options.desc = "Buffer AutoPairs toggle";
    }
    {
      key = "<leader>ueP";
      mode = "n";
      action.__raw = ''
        function()
          vim.g.blink_pairs = vim.g.blink_pairs == false
          vim.notify("Global AutoPairs " .. (vim.g.blink_pairs ~= false and "enabled" or "disabled"), vim.log.levels.INFO)
        end
      '';
      options.desc = "Global AutoPairs toggle";
    }
  ];
}
