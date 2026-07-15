_:
{
  plugins.smartcolumn = {
    enable = false;

    lazyLoad.settings.event = [ "BufReadPost" "BufNewFile" ];

    settings = {
      colorcolumn = "80";
      disabled_filetypes = [
        "checkhealth"
        "dashboard"
        "help"
        "lspinfo"
        "markdown"
        "ministarter"
        "noice"
        "snacks_dashboard"
        "text"
      ];
      custom_colorcolumn = {
        go = [ "100" "130" ];
        java = [ "100" "140" ];
        nix = [ "100" "120" ];
        rust = [ "80" "100" ];
      };
      scope = "file";
    };
  };
}
