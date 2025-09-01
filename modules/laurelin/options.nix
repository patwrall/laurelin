{ lib
, ...
}: {
  options.laurelin = {
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

    editor = {
      searchPlugin = lib.mkOption {
        type = lib.types.enum [
          "grug-far"
          "none"
        ];
        default = "grug-far";
        description = "Search and replace plugin to use";
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
