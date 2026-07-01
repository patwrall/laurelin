{ config, lib, ... }:
{
  plugins.snacks.settings.words = {
    enabled = true;
    debounce = 100;
    foldopen = true;
    jumplist = true;

    filter.__raw = ''
      function(buf)
        if vim.g.snacks_words == false or vim.b[buf].snacks_words == false then
          return false
        end
        local ft = vim.bo[buf].filetype
        local deny_filetypes = { "dirvish", "fugitive", "neo-tree", "nvim-tree" }
        for _, denied_ft in ipairs(deny_filetypes) do
          if ft == denied_ft then return false end
        end
        if vim.api.nvim_buf_line_count(buf) > 3000 then return false end
        return true
      end
    '';
  };

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "]]";
      action = "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>";
      options.desc = "Next Reference";
    }
    {
      mode = "n";
      key = "[[";
      action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>";
      options.desc = "Previous Reference";
    }
  ];
}
