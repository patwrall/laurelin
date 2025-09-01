{ config
, lib
, ...
}:
{
  plugins.yazi = {
    enable = config.laurelin.editor.fileManager == "yazi";

    lazyLoad = {
      settings = {
        cmd = [
          "Yazi"
        ];
      };
    };
  };

  keymaps = lib.optionals (config.laurelin.editor.fileManager == "yazi") [
    {
      mode = "n";
      key = "<leader>e";
      action = "<CMD>Yazi<CR>";
      options = {
        desc = "Yazi (current file)";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<CMD>Yazi toggle<CR>";
      options = {
        desc = "Yazi (resume)";
      };
    }
  ];
}
