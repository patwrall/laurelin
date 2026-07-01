{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    imagemagick
    ghostscript
    typst
    tectonic
  ];

  plugins.snacks.settings.image = {
    enabled = true;
    doc = {
      enabled = true;
      inline = true;
      float = true;
      max_width = 100;
      max_height = 50;
    };
  };
}
