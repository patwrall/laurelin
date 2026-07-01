{ config, lib, ... }:
{
  plugins.gitsigns = {
    enable = true;

    lazyLoad.settings.event = [ "BufReadPost" "BufNewFile" ];

    settings = {
      current_line_blame = true;
      current_line_blame_opts = {
        delay = 1000;
        ignore_blank_lines = true;
        ignore_whitespace = true;
        virt_text = true;
        virt_text_pos = "eol";
      };
      signcolumn = true;
      update_debounce = 200;
    };
  };

  keymaps = lib.mkIf config.plugins.gitsigns.enable [
    # Navigation — use ]h/[h to avoid clash with treesitter-textobjects ]c/[c (class)
    {
      mode = "n";
      key = "]h";
      action.__raw = ''
        function()
          if vim.wo.diff then return ']h' end
          vim.schedule(function() require('gitsigns').nav_hunk('next') end)
          return '<Ignore>'
        end
      '';
      options = { expr = true; desc = "Next Hunk"; };
    }
    {
      mode = "n";
      key = "[h";
      action.__raw = ''
        function()
          if vim.wo.diff then return '[h' end
          vim.schedule(function() require('gitsigns').nav_hunk('prev') end)
          return '<Ignore>'
        end
      '';
      options = { expr = true; desc = "Previous Hunk"; };
    }
    # Stage / reset
    {
      mode = "n";
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage Hunk";
    }
    {
      mode = "v";
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage Hunk";
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action = "<cmd>Gitsigns undo_stage_hunk<CR>";
      options.desc = "Undo Stage Hunk";
    }
    {
      mode = "n";
      key = "<leader>ghS";
      action.__raw = "function() require('gitsigns').stage_buffer() end";
      options.desc = "Stage Buffer";
    }
    {
      mode = "n";
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset Hunk";
    }
    {
      mode = "v";
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset Hunk";
    }
    {
      mode = "n";
      key = "<leader>ghR";
      action.__raw = "function() require('gitsigns').reset_buffer() end";
      options.desc = "Reset Buffer";
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action.__raw = "function() require('gitsigns').preview_hunk() end";
      options.desc = "Preview Hunk";
    }
    {
      mode = "n";
      key = "<leader>ghb";
      action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
      options.desc = "Blame Line (full)";
    }
    {
      mode = "n";
      key = "<leader>ghq";
      action = "<cmd>Gitsigns setqflist<CR>";
      options.desc = "Hunks → Quickfix";
    }
    # Diffs
    {
      mode = "n";
      key = "<leader>gdg";
      action = "<cmd>Gitsigns diffthis<CR>";
      options.desc = "Diff This";
    }
    {
      mode = "n";
      key = "<leader>gdG";
      action = "<cmd>Gitsigns diffthis ~<CR>";
      options.desc = "Diff This ~";
    }
    # Toggles
    {
      mode = "n";
      key = "<leader>ugb";
      action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
      options.desc = "Toggle Blame";
    }
    {
      mode = "n";
      key = "<leader>ugw";
      action = "<cmd>Gitsigns toggle_word_diff<CR>";
      options.desc = "Toggle Word Diff";
    }
    # Text object
    {
      mode = [ "o" "x" ];
      key = "ih";
      action = "<cmd>Gitsigns select_hunk<CR>";
      options.desc = "Select Hunk";
    }
  ];
}
