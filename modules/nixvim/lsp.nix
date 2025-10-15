{ config
, lib
, pkgs
, ...
}:
{
  imports = [
    #   # keep-sorted start
    ./lsp/ccls.nix
    ./lsp/clangd.nix
    ./lsp/harper-ls.nix
    ./lsp/helm-ls.nix
    ./lsp/lspconfig.nix
    ./lsp/nil-ls.nix
    ./lsp/nixd.nix
    ./lsp/rust-analyzer.nix
    ./lsp/typos-lsp.nix
    #   # keep-sorted end
  ];

  lsp = {
    inlayHints.enable = true;

    servers = {
      "*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
      angularls.enable = true;
      bashls.enable = true;
      biome.enable = true;
      cmake.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      emmylua_ls = {
        enable = true;
        package = pkgs.emmylua-ls;
      };
      fish_lsp.enable = true;
      fsautocomplete.enable = true;
      fsharp_language_server = {
        enable = false;
        # TODO: package FSharpLanguageServer
        # cmd = [ "${pkgs.fsharp-language-server}/FSharpLanguageServer.dll" ];
      };
      # FIXME: broken upstream
      gdscript = {
        enable = true;
        package = pkgs.gdtoolkit_4;
      };

      gopls.enable = true;
      html.enable = true;
      java_language_server.enable = !config.plugins.jdtls.enable;
      jdtls.enable = !config.plugins.jdtls.enable;
      jsonls.enable = true;
      kulala_ls.enable = true;
      marksman.enable = true;
      nushell.enable = true;
      pyright.enable = true;
      qmlls.enable = true;
      ruff.enable = true;
      sqls.enable = true;
      statix.enable = true;
      stylelint_lsp.enable = true;
      tailwindcss.enable = true;
      taplo.enable = true;
      ts_ls.enable = !config.plugins.typescript-tools.enable;
      yamlls.enable = true;
    };
  };

  keymapsOnEvents.LspAttach = [
    (lib.mkIf (!config.plugins.conform-nvim.enable) {
      action.__raw = ''vim.lsp.buf.format'';
      mode = "v";
      key = "<leader>lf";
      options = {
        silent = true;
        buffer = false;
        desc = "Format selection";
      };
    })
    # Diagnostic keymaps
    {
      key = "<leader>lH";
      mode = "n";
      action = lib.nixvim.mkRaw "vim.diagnostic.open_float";
      options = {
        silent = true;
        desc = "Lsp diagnostic open_float";
      };
    }
    {
      mode = "n";
      key = "<leader>cl";
      action.__raw = "require('snacks').picker.lsp_config";
      options.desc = "LSP Info";
    }
    {
      mode = "n";
      key = "gd";
      action.__raw = "vim.lsp.buf.definition";
      options.desc = "Goto Definition";
    }
    {
      mode = "n";
      key = "gr";
      action.__raw = "vim.lsp.buf.references";
      options = {
        desc = "References";
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "gI";
      action.__raw = "vim.lsp.buf.implementation";
      options.desc = "Goto Implementation";
    }
    {
      mode = "n";
      key = "gy";
      action.__raw = "vim.lsp.buf.type_definition";
      options.desc = "Goto T[y]pe Definition";
    }
    {
      mode = "n";
      key = "gD";
      action.__raw = "vim.lsp.buf.declaration";
      options.desc = "Goto Declaration";
    }
    {
      mode = "n";
      key = "K";
      action.__raw = "vim.lsp.buf.hover";
      options.desc = "Hover";
    }
    {
      mode = "n";
      key = "gK";
      action.__raw = "vim.lsp.buf.signature_help";
      options.desc = "Signature Help";
    }
    {
      mode = "i";
      key = "<c-k>";
      action.__raw = "vim.lsp.buf.signature_help";
      options.desc = "Signature Help";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ca";
      action.__raw = "vim.lsp.buf.code_action";
      options.desc = "Code Action";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cc";
      action.__raw = "vim.lsp.codelens.run";
      options.desc = "Run Codelens";
    }
    {
      mode = "n";
      key = "<leader>cC";
      action.__raw = "vim.lsp.codelens.refresh";
      options.desc = "Refresh & Display Codelens";
    }
    {
      mode = "n";
      key = "<leader>cr";
      action.__raw = "vim.lsp.buf.rename";
      options.desc = "Rename";
    }
  ]
  ++ lib.optionals (!config.plugins.glance.enable) [
    {
      action = "<CMD>PeekDefinition textDocument/definition<CR>";
      mode = "n";
      key = "<leader>lp";
      options = {
        desc = "Preview definition";
      };
    }
    {
      action = "<CMD>PeekDefinition textDocument/typeDefinition<CR>";
      mode = "n";
      key = "<leader>lP";
      options = {
        desc = "Preview type definition";
      };
    }
  ]
  ++ lib.optionals (!config.plugins.conform-nvim.enable) [
    # Format keymap (if conform-nvim is not enabled)
    {
      key = "<leader>lf";
      mode = "n";
      action = lib.nixvim.mkRaw "vim.lsp.buf.format";
      options = {
        silent = true;
        desc = "Lsp buf format";
      };
    }
  ]
  ++
  lib.optionals
    (
      !config.plugins.fzf-lua.enable
        || (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
    )
    [
      # Code action keymap (if fzf-lua is not enabled)
      {
        key = "<leader>la";
        mode = "n";
        action = lib.nixvim.mkRaw "vim.lsp.buf.code_action";
        options = {
          silent = true;
          desc = "Lsp buf code_action";
        };
      }
    ];

  plugins = {
    lsp-format.enable = !config.plugins.conform-nvim.enable && config.plugins.lsp.enable;
    lsp-signature.enable = config.plugins.lsp.enable;
    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>l";
        group = "LSP";
        icon = " ";
      }
    ];
  };
}
