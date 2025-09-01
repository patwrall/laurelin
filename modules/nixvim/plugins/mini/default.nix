{ config
, lib
, ...
}:
{
  imports = [
    ./diff.nix
    ./files.nix
    ./fuzzy.nix
    ./git.nix
    ./hipatterns.nix
    ./indentscope.nix
    ./map.nix
    ./pairs.nix
    ./starter.nix
    ./surround.nix
  ];

  plugins = {
    mini = {
      enable = true;
      mockDevIcons = true;

      modules = {
        ai = { };
        align = { };
        basics = { };
        bracketed = { };
        icons = { };
        snippets = lib.mkIf (config.laurelin.editor.snippetEngine == "mini-snippets") {
          snippets = {
            __unkeyed-1.__raw =
              lib.mkIf config.plugins.friendly-snippets.enable # Lua
                "require('mini.snippets').gen_loader.from_file('${config.plugins.friendly-snippets.package}/snippets/global.json')";
            __unkeyed-2.__raw = "require('mini.snippets').gen_loader.from_lang()";
          };
        };
      };
    };
  };
}
