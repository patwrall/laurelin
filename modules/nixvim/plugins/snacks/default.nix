{ config, ... }:
{
  imports = [
    # keep-sorted start block=yes newline_separated=no
    ./bigfile.nix
    ./bufdelete.nix
    ./debug.nix
    ./dim.nix
    # ./explorer.nix
    ./gitbrowse.nix
    ./image.nix
    ./lazygit.nix
    ./notifier.nix
    ./picker.nix
    ./profiler.nix
    ./rename.nix
    ./scope.nix
    ./scratch.nix
    ./terminal.nix
    ./toggle.nix
    ./words.nix
    ./zen.nix
    # keep-sorted end
  ];

  plugins.snacks = {
    enable = true;

    settings = {
      input.enabled = true;
      indent.enabled = true;
      quickfile.enabled = true;
      scroll.enabled = true;
      statuscolumn = {
        enabled = true;
        folds = {
          open = true;
          git_hl = config.plugins.gitsigns.enable;
        };
      };
      styles.input = {
        relative = "cursor";
        row = -4;
        col = 0;
      };
    };
  };
}
