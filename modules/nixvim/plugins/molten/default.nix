{ config
, lib
, ...
}:
{
  plugins = {
    molten = {
      enable = true;
      settings = {
        output.virtual_text = true;
      };

      python3Dependencies = ps: with ps; [
        pynvim
        jupyter
        ipykernel
      ];
    };

    which-key.settings.spec = lib.optionals config.plugins.molten.enable [
      {
        __unkeyed-1 = "<leader>M";
        group = "Molten";
        icon = "󰈸";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.molten.enable [
    {
      key = "<leader>Mi";
      action = "<cmd>MoltenInit<cr>";
      options.desc = "Initialize Molten";
    }
    {
      key = "<leader>Mr";
      action = "<cmd>MoltenRestart<cr>";
      options.desc = "Restart Kernel";
    }
    {
      key = "<leader>Ms";
      action = "<cmd>MoltenEnter<cr>";
      options.desc = "Send to REPL";
    }
    {
      mode = "v";
      key = "<leader>Me";
      action = "<cmd>MoltenEvaluateVisual<cr>";
      options.desc = "Evaluate Selection";
    }
    {
      key = "<leader>Ml";
      action = "<cmd>MoltenEvaluateLine<cr>";
      options.desc = "Evaluate Line";
    }
    {
      key = "<leader>MR";
      action = "<cmd>MoltenReEvaluate<cr>";
      options.desc = "Re-Evaluate Last";
    }
    {
      key = "<leader>Mo";
      action = "<cmd>MoltenToggleOutput<cr>";
      options.desc = "Toggle Output";
    }
    {
      key = "<leader>Mc";
      action = "<cmd>MoltenClose<cr>";
      options.desc = "Close Kernel";
    }
  ];
}
