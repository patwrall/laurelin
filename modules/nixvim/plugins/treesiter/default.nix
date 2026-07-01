{ config
, self
, system
, ...
}:
{
  plugins = {
    treesitter = {
      enable = true;

      folding.enable = true;
      highlight.enable = true;
      indent.enable = true;

      grammarPackages = config.plugins.treesitter.package.allGrammars ++ [
        self.packages.${system}.tree-sitter-norg-meta
      ];
      nixvimInjections = true;

      settings = {
        highlight = {
          additional_vim_regex_highlighting = true;
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
    };

    ts-autotag.enable = true;

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        max_lines = 4;
        min_window_height = 40;
        multiwindow = true;
        separator = "-";
      };
    };
  };
}
