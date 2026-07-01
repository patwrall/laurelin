{ config, lib, ... }:
{
  plugins.typst-preview = {
    enable = config.laurelin.editor.typst;

    # Lazy loading configuration
    lazyLoad.settings = {
      event = [
        "DeferredUIEnter"
      ];
    };

    settings = { };
  };

  keymaps = lib.optionals config.plugins.typst-preview.enable [
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>TypstPreviewToggle<cr>";
      options = {
        desc = "Toggle Typst Preview";
      };
    }
  ];
}
