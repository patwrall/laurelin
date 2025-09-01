{ lib
, ...
}: {
  options.laurelin = {
    completion = {
      engine = lib.mkOption {
        type = lib.types.enum [
          "blink"
          "none"
        ];
        default = "blink";
        description = "Completion engine to use";
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

    picker = {
      engine = lib.mkOption {
        type = lib.types.enum [
          "snacks"
          "none"
        ];
        default = "snacks";
        description = "Picker engine to use";
      };
    };
    performance = {

      optimizer = lib.mkOption {
        type = lib.types.enum [
          "snacks"
          "both"
          "none"
        ];
        default = "snacks";
        description = "Performance optimization strategy for large files";
      };

      optimizeEnable =
        lib.mkEnableOption "nixvim performance optimizations (byte compilation, plugin combining)"
        // {
          default = true;
        };
    };

    editor = {
      searchPlugin = lib.mkOption {
        type = lib.types.enum [
          "grug-far"
          "none"
        ];
        default = "grug-far";
        description = "Search and replace plugin to use";
      };

      fileManager = lib.mkOption {
        type = lib.types.enum [
          "yazi"
          "mini-files"
          "none"
        ];
        default = "mini-files";
        description = "File manager plugin to use";
      };

      diffViewer = lib.mkOption {
        type = lib.types.enum [
          "mini-diff"
          "none"
        ];
        default = "mini-diff";
        description = "Diff viewer plugin to use";
      };

      snippetEngine = lib.mkOption {
        type = lib.types.enum [
          "mini-snippets"
          "none"
        ];
        default = "mini-snippets";
        description = "Snippet engine to use";
      };

      commandlineUI = lib.mkOption {
        type = lib.types.enum [
          "noice"
          "none"
        ];
        default = "noice";
        description = "Command line UI enhancement to use";
      };
    };
  };
}
