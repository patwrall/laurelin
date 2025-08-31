{ lib
, config
, ...
}:
{
  extraConfigLuaPre = ''
    _G.laurelin_grug_far_open = function()
      local grug = require("grug-far")
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end
  '';

  plugins = {
    grug-far = {
      enable = config.laurelin.editor.searchPlugin == "grug-far";
      lazyLoad = {
        settings = {
          cmd = "GrugFar";
          headerMaxWidth = 80;
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.grug-far.enable [
    {
      mode = "n";
      key = "<leader>sr";
      action.__raw = "_G.laurelin_grug_far_open";
      options.desc = "Search and Replace";
    }
    {
      mode = "v";
      key = "<leader>sr";
      action.__raw = "_G.laurelin_grug_far_open";
      options.desc = "Search and Replace";
    }
  ];
}
