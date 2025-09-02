{ pkgs
, lib
, config
, ...
}:
{
  plugins = {
    codesnap = {
      enable = true;
      package = pkgs.vimPlugins.codesnap-nvim;

      lazyLoad = {
        settings = {
          cmd = [
            "CodeSnap"
            "CodeSnapSave"
            "CodeSnapHighlight"
            "CodeSnapSaveHighlight"
            "CodeSnapASCII"
          ];
        };
      };

      settings = {
        save_path = "$XDG_PICTURES_DIR/screenshots/code";
        mac_window_bar = true;
        title = "CodeSnap.nvim";
        watermark = "";
        has_breadcrumbs = false;
        has_line_number = true;
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.codesnap.enable [
      {
        __unkeyed-1 = "<leader>c";
        mode = "v";
        group = "Codesnap";
        icon = "󰄄 ";
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.codesnap.enable [
    {
      mode = "v";
      key = "<leader>cc";
      action = "<cmd>CodeSnap<CR>";
      options = {
        desc = "Copy";
      };
    }
    {
      mode = "v";
      key = "<leader>cs";
      action = "<cmd>CodeSnapSave<CR>";
      options = {
        desc = "Save";
      };
    }
    {
      mode = "v";
      key = "<leader>ch";
      action = "<cmd>CodeSnapHighlight<CR>";
      options = {
        desc = "Highlight";
      };
    }
    {
      mode = "v";
      key = "<leader>cH";
      action = "<cmd>CodeSnapSaveHighlight<CR>";
      options = {
        desc = "Save Highlight";
      };
    }
    {
      mode = "v";
      key = "<leader>cA";
      action = "<cmd>CodeSnapASCII<CR>";
      options = {
        desc = "ASCII Copy";
      };
    }
  ];
}
