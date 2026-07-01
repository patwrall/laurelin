_:
{
  plugins.fidget = {
    enable = true;

    settings = {
      progress = {
        poll_rate = 0;
        suppress_on_insert = false;
        ignore_done_already = false;
        ignore_empty_message = false;
        clear_on_detach.__raw = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';
        notification_group.__raw = ''
          function(msg)
            return msg.lsp_client.name
          end
        '';
        display = {
          render_limit = 10;
          done_ttl = 4;
          done_icon = "";
          progress_ttl.__raw = "math.huge";
          progress_icon = { __unkeyed-1 = "dots"; };
          skip_history = false;
        };
        lsp = {
          progress_ringbuf_size = 0;
          log_handler = false;
        };
      };

      notification = {
        poll_rate = 10;
        filter = "info";
        history_size = 128;
        # snacks.notifier owns vim.notify — fidget should NOT override it
        override_vim_notify = false;
        window = {
          normal_hl = "NormalFloat";
          winblend = 0;
          border = "rounded";
          zindex = 45;
          align = "bottom";
          relative = "editor";
        };
        view = {
          stack_upwards = false;
          icon_separator = " ";
          group_separator = "─";
          group_separator_hl = "Comment";
        };
      };

      logger = {
        level = "warn";
        path.__raw = "string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache'))";
      };
    };
  };
}
