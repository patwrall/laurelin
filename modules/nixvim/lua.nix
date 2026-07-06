{
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';

  extraConfigLuaPost = ''
    -- markview bug: set_query calls vim.treesitter.start before evaluating its condition,
    -- causing "parser not found" errors for snacks_* buffers. Patching markview.actions
    -- doesn't work because autocmds capture the function reference as an upvalue at load
    -- time. Patch vim.treesitter.start directly — it's always a table lookup so this wins.
    local _orig_ts_start = vim.treesitter.start
    vim.treesitter.start = function(buf, lang, ...)
      local ft = buf and vim.bo[buf] and vim.bo[buf].ft or ""
      if (lang or ft):match("^snacks_") then return end
      return _orig_ts_start(buf, lang, ...)
    end
  '';
}
