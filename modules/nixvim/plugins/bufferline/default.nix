_:
{
  extraConfigLuaPre = ''
    _G.laurelin_bufferline_helpers = {}

    _G.laurelin_bufferline_helpers.close_command = function(n)
      vim.cmd("bdelete! " .. n)
    end

    _G.laurelin_bufferline_helpers.diagnostics_indicator = function(_, _, diag)
      local icons = { Error = " ", Warn = " ", Info = " ", Hint = " " }
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end

    _G.laurelin_bufferline_helpers.get_element_icon = function(opts)
      local devicons = require("nvim-web-devicons")
      local icon, _ = devicons.get_icon(opts.filename, opts.filetype)
      return icon
    end
  '';

  keymaps = [
    { mode = "n"; key = "<leader>bp"; action = "<cmd>BufferLineTogglePin<CR>"; options.desc = "Toggle Pin"; }
    { mode = "n"; key = "<leader>bP"; action = "<cmd>BufferLineGroupClose ungrouped<CR>"; options.desc = "Delete Non-Pinned Buffers"; }
    { mode = "n"; key = "<leader>br"; action = "<cmd>BufferLineCloseRight<CR>"; options.desc = "Delete Buffers to the Right"; }
    { mode = "n"; key = "<leader>bl"; action = "<cmd>BufferLineCloseLeft<CR>"; options.desc = "Delete Buffers to the Left"; }
    { mode = "n"; key = "<S-h>"; action = "<cmd>BufferLineCyclePrev<cr>"; options.desc = "Prev Buffer"; }
    { mode = "n"; key = "<S-l>"; action = "<cmd>BufferLineCycleNext<cr>"; options.desc = "Next Buffer"; }
    { mode = "n"; key = "[b"; action = "<cmd>BufferLineCyclePrev<cr>"; options.desc = "Prev Buffer"; }
    { mode = "n"; key = "]b"; action = "<cmd>BufferLineCycleNext<cr>"; options.desc = "Next Buffer"; }
    { mode = "n"; key = "[B"; action = "<cmd>BufferLineMovePrev<cr>"; options.desc = "Move Buffer Prev"; }
    { mode = "n"; key = "]B"; action = "<cmd>BufferLineMoveNext<cr>"; options.desc = "Move Buffer Next"; }
  ];

  plugins.bufferline = {
    enable = true;
    lazyLoad.settings.event = [ "DeferredUIEnter" ];
    settings = {
      options = {
        close_command.__raw = "_G.laurelin_bufferline_helpers.close_command";
        right_mouse_command.__raw = "_G.laurelin_bufferline_helpers.close_command";
        diagnostics_indicator.__raw = "_G.laurelin_bufferline_helpers.diagnostics_indicator";
        get_element_icon.__raw = "_G.laurelin_bufferline_helpers.get_element_icon";

        diagnostics = "nvim_lsp";
        always_show_bufferline = false;

        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
        ];
      };
    };
  };

  autoCmd = [
    {
      event = [ "BufAdd" "BufDelete" ];
      callback.__raw = ''
        function()
          vim.schedule(function()
            pcall(require, "bufferline")
          end)
        end
      '';
    }
  ];

  plugins.web-devicons.enable = true;
}
