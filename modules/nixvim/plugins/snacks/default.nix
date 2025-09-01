{ config
, pkgs
, ...
}: {
  imports = [
    # keep-sorted start block=yes newline_separated=no
    ./bigfile.nix
    ./bufdelete.nix
    ./explorer.nix
    ./gitbrowse.nix
    ./lazygit.nix
    ./picker.nix
    ./profiler.nix
    # keep-sorted end
  ];

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
