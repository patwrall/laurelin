{ config, lib, ... }:
{
  plugins.snacks.settings.dim.enabled = true;

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>usd";
      action.__raw = ''
        function()
          Snacks.toggle.dim():toggle()
        end
      '';
      options.desc = "Toggle Dim";
    }
  ];
}
