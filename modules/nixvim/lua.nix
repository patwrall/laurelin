{
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';

  extraConfigLuaPost = ''
    -- markview bug: set_query (treesitter.start) is called before the condition check,
    -- so snacks_* buffers cause "parser not found" errors. Patch set_query to bail early.
    -- Listen on all LazyLoad events; bail until markview is available, then patch once.
    local _markview_patched = false
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function()
        if _markview_patched then return end
        local ok, actions = pcall(require, "markview.actions")
        if not ok or not actions.set_query then return end
        local orig = actions.set_query
        actions.set_query = function(buf, ...)
          local ft = vim.bo[buf] and vim.bo[buf].ft or ""
          if ft:match("^snacks_") then return end
          return orig(buf, ...)
        end
        _markview_patched = true
      end,
    })
  '';
}
