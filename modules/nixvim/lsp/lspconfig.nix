{ config
, lib
, ...
}:
{
  extraConfigLuaPre =
    lib.mkIf config.plugins.lspconfig.enable # Lua
      ''
        require('lspconfig.ui.windows').default_options = {
          border = "rounded"
        }
      '';

  plugins = {
    lspconfig.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "K";
      action.__raw = "vim.lsp.buf.hover";
      options = {
        desc = "LSP Hover Documentation";
      };
    }
  ];
}
