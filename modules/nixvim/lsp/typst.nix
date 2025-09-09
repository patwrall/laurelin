{ pkgs
, ...
}: {
  plugins.lsp = {
    enable = true;
    servers.typst-lsp = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    typst
    tinymist
  ];
}
