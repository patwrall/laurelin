{ config
, lib
, ...
}:
{
  config = {
    plugins.lensline = {
      enable = true;

      settings = {
        profiles = [
          {
            name = "default";
            providers = [
              {
                name = "references";
                enabled = true;
                quiet_lsp = true;
              }
              {
                name = "last_author";
                enabled = true;
                cache_max_files = 100;
              }
              {
                name = "diagnostics";
                enabled = true;
                min_level = "HINT";
              }
              {
                name = "complexity";
                enabled = true;
                min_level = "M";
              }
            ];
            style = {
              placement = "inline";
              prefix = "";
            };
          }
        ];
        limits = {
          exclude_gitignored = true;
          max_lines = 2000;
          max_lenses = 100;
        };
        debounce_ms = 300;
      };
    };

    keymaps = lib.mkIf config.plugins.lensline.enable [
      {
        mode = "n";
        key = "<leader>ul";
        action = "<cmd>LenslineToggle<CR>";
        options = {
          desc = "Lensline toggle";
        };
      }
    ];
  };
}
