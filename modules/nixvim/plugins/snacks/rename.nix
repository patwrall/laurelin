{ config, lib, ... }:
{
  plugins.snacks.settings.rename.enabled = true;

  autoGroups.snacks_rename_integration.clear = true;

  autoCmd = lib.optionals config.plugins.snacks.enable [
    (lib.mkIf config.plugins.mini-files.enable {
      event = "User";
      pattern = "MiniFilesActionRename";
      group = "snacks_rename_integration";
      callback.__raw = ''
        function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end
      '';
    })
  ];

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>lR";
      action = "<cmd>lua Snacks.rename.rename_file()<CR>";
      options.desc = "Rename File";
    }
  ];
}
