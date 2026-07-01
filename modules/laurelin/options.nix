{ lib
, ...
}:
{
  options.laurelin = {
    ai = {
      plugins = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "avante"
            "claudecode"
            "copilot"
          ]
        );
        default = [ "claudecode" ];
        description = ''
          List of AI plugins to enable. Multiple can be active simultaneously.
          Set to [] to disable all AI features.
        '';
      };

      chatEnable = lib.mkEnableOption "AI chat functionality" // {
        default = true;
      };
    };

    completion = {
      tool = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "blink" ]);
        default = "blink";
        description = "Completion tool to use. null disables completion.";
      };
    };

    picker = {
      tool = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "snacks" ]);
        default = "snacks";
        description = "Fuzzy picker to use. null disables.";
      };
    };

    performance = {
      optimizer = lib.mkOption {
        type = lib.types.enum [
          "faster"
          "snacks"
          "both"
          "none"
        ];
        default = "snacks";
        description = "Performance optimization strategy for large files";
      };

      optimizeEnable = lib.mkEnableOption "nixvim performance optimizations (byte compilation, plugin combining)" // {
        default = true;
      };
    };

    loading = {
      strategy = lib.mkOption {
        type = lib.types.enum [
          "lazy"
          "eager"
        ];
        default = "lazy";
        description = "Plugin loading strategy";
      };
    };

    tasks = {
      runner = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "overseer" ]);
        default = "overseer";
        description = "Task runner plugin to use. null disables.";
      };
    };

    editor = {
      motion = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "flash" ]);
        default = "flash";
        description = "Motion/jump plugin to use. null disables.";
      };

      search = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "grug-far" ]);
        default = "grug-far";
        description = "Search and replace plugin to use. null disables.";
      };

      fileManager = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "yazi"
            "mini-files"
          ]
        );
        default = "yazi";
        description = "File manager plugin to use. null disables.";
      };

      debugUI = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "dap-ui" ]);
        default = "dap-ui";
        description = "Debug adapter UI to use. null disables.";
      };

      diffViewer = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "mini-diff" ]);
        default = "mini-diff";
        description = "Diff viewer plugin to use. null disables.";
      };

      snippet = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "mini-snippets" ]);
        default = "mini-snippets";
        description = "Snippet engine to use. null disables.";
      };

      commandlineUI = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "noice" ]);
        default = "noice";
        description = "Command line UI enhancement to use. null disables.";
      };

      httpClient = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "kulala" ]);
        default = null;
        description = "HTTP client plugin to use. null disables.";
      };

      # Specialized tooling — disabled by default
      jdtls = lib.mkEnableOption "nvim-jdtls Java LSP plugin (enables jdtls LSP server via plugin instead of lspconfig)";

      typescriptTools = lib.mkEnableOption "typescript-tools alternative TS LSP (overrides ts_ls from lspconfig)";

      typst = lib.mkEnableOption "typst writing tools (typst-vim + typst-preview)";

      telescope = lib.mkEnableOption "telescope.nvim fuzzy picker";
    };

    science = {
      enable = lib.mkEnableOption "scientific writing / notebook stack (molten, quarto, otter)";
    };
  };
}
