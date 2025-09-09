{ config, lib, ... }:
{
  plugins.typst-preview = {
    enable = true;

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
