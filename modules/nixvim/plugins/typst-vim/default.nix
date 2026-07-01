{ config, ... }:
{
  plugins.typst-vim = {
    enable = config.laurelin.editor.typst;

    settings = { };
  };
}
