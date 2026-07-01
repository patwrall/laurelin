{ config, lib, ... }:
{
  plugins.snacks.settings.toggle.enabled = true;

  keymaps = lib.mkIf config.plugins.snacks.enable [
    {
      mode = "n";
      key = "<leader>udd";
      action.__raw = "function() Snacks.toggle.diagnostics():toggle() end";
      options.desc = "Buffer Diagnostics toggle";
    }
    {
      mode = "n";
      key = "<leader>udD";
      action.__raw = "function() Snacks.toggle.diagnostics({ buf = nil }):toggle() end";
      options.desc = "Global Diagnostics toggle";
    }
    {
      mode = "n";
      key = "<leader>ues";
      action.__raw = "function() Snacks.toggle.option('spell', { name = 'Spelling' }):toggle() end";
      options.desc = "Spell toggle";
    }
    {
      mode = "n";
      key = "<leader>uew";
      action.__raw = "function() Snacks.toggle.option('wrap', { name = 'Wrap' }):toggle() end";
      options.desc = "Word Wrap toggle";
    }
    {
      mode = "n";
      key = "<leader>uaa";
      action.__raw = "function() Snacks.toggle.animate():toggle() end";
      options.desc = "Toggle Animations";
    }
    {
      mode = "n";
      key = "<leader>uei";
      action.__raw = "function() Snacks.toggle.indent():toggle() end";
      options.desc = "Toggle Indent Guides";
    }
    {
      mode = "n";
      key = "<leader>ueh";
      action.__raw = "function() Snacks.toggle.inlay_hints():toggle() end";
      options.desc = "Toggle Inlay Hints";
    }
    {
      mode = "n";
      key = "<leader>uen";
      action.__raw = "function() Snacks.toggle.line_number():toggle() end";
      options.desc = "Toggle Line Numbers";
    }
    {
      mode = "n";
      key = "<leader>upp";
      action.__raw = "function() Snacks.toggle.profiler():toggle() end";
      options.desc = "Toggle Profiler";
    }
    {
      mode = "n";
      key = "<leader>uph";
      action.__raw = "function() Snacks.toggle.profiler_highlights():toggle() end";
      options.desc = "Toggle Profiler Highlights";
    }
    {
      mode = "n";
      key = "<leader>ups";
      action.__raw = "function() Snacks.profiler.scratch() end";
      options.desc = "Profiler Scratch (adjust options)";
    }
    {
      mode = "n";
      key = "<leader>uss";
      action.__raw = "function() Snacks.toggle.scroll():toggle() end";
      options.desc = "Toggle Smooth Scroll";
    }
    {
      mode = "n";
      key = "<leader>utt";
      action.__raw = "function() Snacks.toggle.treesitter():toggle() end";
      options.desc = "Toggle Treesitter Highlight";
    }
    {
      mode = "n";
      key = "<leader>utr";
      action.__raw = "function() Snacks.toggle.words():toggle() end";
      options.desc = "Toggle Reference Highlighting";
    }
    {
      mode = "n";
      key = "<leader>ueo";
      action.__raw = ''
        function()
          local curr = vim.wo.foldcolumn
          if curr ~= "0" then vim.g.last_active_foldcolumn = curr end
          vim.wo.foldcolumn = curr == "0" and (vim.g.last_active_foldcolumn or "1") or "0"
          vim.notify("Fold Column " .. (vim.wo.foldcolumn ~= "0" and "enabled" or "disabled"), vim.log.levels.INFO)
        end
      '';
      options.desc = "Toggle Fold Column";
    }
    {
      mode = "n";
      key = "<leader>ueW";
      action.__raw = ''
        function()
          if not vim.g.whitespace_characters_enabled then
            vim.cmd('set listchars=eol:¬,tab:>→,trail:~,extends:>,precedes:<,space:·')
            vim.cmd('set list')
          else
            vim.cmd('set nolist')
          end
          vim.g.whitespace_characters_enabled = not vim.g.whitespace_characters_enabled
          vim.notify("Whitespace characters " .. (vim.g.whitespace_characters_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
        end
      '';
      options.desc = "Toggle Whitespace Characters";
    }
  ];
}
