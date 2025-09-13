_:
{
  plugins.quarto = {
    enable = true;

    lazyLoad.settings = {
      event = [ "DeferredUIEnter" ];
    };

    settings = {
      codeRunner = {
        enabled = true;
        default_method = "molten";
      };

      lspFeatures = {
        enabled = true;
        languages = [
          "r"
          "python"
          "julia"
          "bash"
          "html"
        ];
      };
    };
  };
}
