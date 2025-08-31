{ config
, pkgs
, ...
}: {

  extraPackages = with pkgs; [
    ghostscript
  ];

  plugins = {
    snacks = {
      enable = true;

      settings = {
        image.enabled = true;
        indent.enabled = true;
        scroll.enabled = true;
        statuscolumn = {
          enabled = true;

          folds = {
            open = true;
            git_hl = config.plugins.gitsigns.enable;
          };
        };
      };
    };
  };
}
