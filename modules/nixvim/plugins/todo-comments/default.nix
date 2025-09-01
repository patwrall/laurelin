{ config
, lib
, ...
}:
{
  plugins.todo-comments = {
    enable = true;

    lazyLoad = {
      enable = false;
      settings = {
        before.__raw = lib.mkIf config.plugins.lz-n.enable (
          ''
            function()
          ''
          + lib.optionalString config.plugins.fzf-lua.enable ''
            require('lz.n').trigger_load('fzf-lua')
          ''
          + lib.optionalString config.plugins.trouble.enable ''
            require('lz.n').trigger_load('trouble.nvim')
          ''
          + lib.optionalString config.plugins.telescope.enable ''
            require('lz.n').trigger_load('telescope')
          ''
          + lib.optionalString (config.telperion.picker.engine == "snacks") ''
            require('lz.n').trigger_load('snacks.nvim')
          ''
          + ''
            end
          ''
        );
        keys = lib.mkIf (config.telperion.picker.engine == "snacks") [
          {
            __unkeyed-1 = "<leader>ft";
            __unkeyed-2 = ''<CMD>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<CR>'';
            desc = "Find TODOs";
          }
        ];
        cmd = [
          "TodoLocList"
          "TodoQuickFix"
        ];
      };
    };
  };
}
