{ lib, ... }:
{
  plugins.treesitter-textobjects = {
    enable = true;

    settings = {
      # mini.ai handles text-object select (a/i keys) — disable to avoid conflict
      select.enable = false;

      move = {
        enable = true;
        set_jumps = true;

        goto_next_start = {
          "]m" = "@function.outer";
          "]c" = "@class.outer";
          "]o" = { query = "@loop.*"; query_group = "textobjects"; };
          "]s" = { query = "@local.scope"; query_group = "locals"; };
          "]z" = { query = "@fold"; query_group = "folds"; };
        };
        goto_next_end = {
          "]M" = "@function.outer";
          "]C" = "@class.outer";
        };
        goto_previous_start = {
          "[m" = "@function.outer";
          "[c" = "@class.outer";
          "[o" = { query = "@loop.*"; query_group = "textobjects"; };
        };
        goto_previous_end = {
          "[M" = "@function.outer";
          "[C" = "@class.outer";
        };
      };
    };
  };

  # Repeatable move with ; and ,
  keymaps = [
    {
      mode = [ "n" "x" "o" ];
      key = ";";
      action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_next";
      options.desc = "Repeat last move next";
    }
    {
      mode = [ "n" "x" "o" ];
      key = ",";
      action.__raw = "require('nvim-treesitter-textobjects.repeatable_move').repeat_last_move_previous";
      options.desc = "Repeat last move previous";
    }
  ];
}
