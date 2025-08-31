{ pkgs
, ...
}:
{
  extraConfigLuaPre = ''
    _G.laurelin_which_key_extras = {}
  '';
  extraConfigLua = ''
    _G.laurelin_which_key_extras.expand_buf = function()
      return require("which-key.extras").expand.buf()
    end
    _G.laurelin_which_key_extras.expand_win = function()
      return require("which-key.extras").expand.win()
    end
  '';

  plugins.which-key = {
    enable = true;
    lazyLoad.settings.event = [ "DeferredUIEnter" ];

    settings = {
      preset = "helix";
      spec = [
        { mode = [ "n" "v" ]; __unkeyed-1 = "<leader><tab>"; group = "tabs"; }
        { __unkeyed-1 = "<leader>c"; group = "code"; }
        { __unkeyed-1 = "<leader>d"; group = "debug"; }
        { __unkeyed-1 = "<leader>dp"; group = "profiler"; }
        { __unkeyed-1 = "<leader>f"; group = "file/find"; }
        { __unkeyed-1 = "<leader>g"; group = "git"; }
        { __unkeyed-1 = "<leader>gh"; group = "hunks"; }
        { __unkeyed-1 = "<leader>q"; group = "quit/session"; }
        { __unkeyed-1 = "<leader>s"; group = "search"; }
        { __unkeyed-1 = "<leader>u"; group = "ui"; icon = "󰙵"; }
        { __unkeyed-1 = "<leader>x"; group = "diagnostics/quickfix"; icon = "󰒡"; }
        { __unkeyed-1 = "["; group = "prev"; }
        { __unkeyed-1 = "]"; group = "next"; }
        { __unkeyed-1 = "g"; group = "goto"; }
        { __unkeyed-1 = "gs"; group = "surround"; }
        { __unkeyed-1 = "z"; group = "fold"; }
        {
          __unkeyed-1 = "<leader>b";
          group = "buffer";
          expand.__raw = "_G.laurelin_which_key_extras.expand_buf";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "windows";
          proxy = "<c-w>";
          expand.__raw = "_G.laurelin_which_key_extras.expand_win";
        }
        {
          __unkeyed-1 = "gx";
          desc = "Open with system app";
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = "function() require('which-key').show({ global = false }) end";
      options.desc = "Buffer Keymaps (which-key)";
    }
    {
      mode = "n";
      key = "<C-w><Space>";
      action.__raw = "function() require('which-key').show({ keys = '<c-w>', loop = true }) end";
      options.desc = "Window Hydra Mode (which-key)";
    }
  ];

  extraPlugins = with pkgs.vimPlugins; [
    which-key-nvim
    mini-icons
  ];
}
