{ config
, ...
}:
{
  plugins = {
    noice = {
      enable = config.laurelin.editor.commandlineUI == "noice";

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        # Hides the title above noice boxes
        cmdline = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
              opts = {
                border = {
                  text = {
                    top = "Cmd";
                  };
                };
              };
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "^%?";
              icon = " ";
              lang = "regex";
            };
            filter = {
              pattern = "^:%s*!";
              icon = "";
              lang = "bash";
              opts = {
                border = {
                  text = {
                    top = "Bash";
                  };
                };
              };
            };
            lua = {
              pattern = "^:%s*lua%s+";
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "󰋖";
            };
            input = { };
          };
        };

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };

          # snacks.notifier handles progress; noice does cmdline only
          progress.enabled = false;
          signature.enabled = !config.plugins.lsp-signature.enable;
        };

        popupmenu.backend = "nui";
        # Doesn't support the standard cmdline completions
        # popupmenu.backend = "cmp";

        presets = {
          bottom_search = false;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };

        routes = [
          {
            filter = { event = "msg_show"; kind = "search_count"; };
            opts.skip = true;
          }
          {
            filter = { event = "msg_show"; find = "written"; };
            opts.skip = true;
          }
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "search hit BOTTOM"; }
                { find = "search hit TOP"; }
              ];
            };
            opts.skip = true;
          }
          {
            filter = { event = "msg_show"; find = "Pattern not found"; };
            opts.skip = true;
          }
          {
            filter = { event = "notify"; find = "No information available"; };
            opts.skip = true;
          }
          {
            filter = { event = "msg_show"; min_height = 20; };
            view = "split";
            opts.enter = true;
          }
          {
            # skip progress messages from noisy LSP servers
            filter = {
              event = "lsp";
              kind = "progress";
              cond.__raw = ''
                function(message)
                  local client = vim.tbl_get(message.opts, 'progress', 'client')
                  local servers = { 'jdtls' }
                  for _, value in ipairs(servers) do
                    if value == client then return true end
                  end
                end
              '';
            };
            opts.skip = true;
          }
        ];

        views = {
          cmdline_popup = {
            border = {
              style = "single";
            };
          };

          confirm = {
            border = {
              style = "single";
              text = {
                top = "";
              };
            };
          };
        };
      };
    };

  };
}
