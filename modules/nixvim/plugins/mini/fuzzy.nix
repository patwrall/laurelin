{ config
, lib
, ...
}:
{
  plugins.mini.modules = lib.mkIf config.laurelin.editor.telescope { fuzzy = { }; };

  plugins.telescope.settings.defaults = lib.mkIf config.laurelin.editor.telescope {
    file_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
    generic_sorter.__raw = ''require('mini.fuzzy').get_telescope_sorter'';
  };
}
