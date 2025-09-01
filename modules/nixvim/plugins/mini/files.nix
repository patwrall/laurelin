{ config
, lib
, ...
}:
{
  plugins.mini.modules = lib.mkIf (config.laurelin.editor.fileManager == "mini-files") {
    files = { };
  };

  keymaps = lib.mkIf (config.laurelin.editor.fileManager == "mini-files") [
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>lua require('mini.files').open()<cr>";
      options = {
        desc = "Mini Files";
      };
    }
  ];
}
