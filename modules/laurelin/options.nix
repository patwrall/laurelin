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

    editor = {
      searchPlugin = lib.mkOption {
        type = lib.types.enum [
          "grug-far"
          "none"
        ];
        default = "grug-far";
        description = "Search and replace plugin to use";
      };
    };
  };
}
