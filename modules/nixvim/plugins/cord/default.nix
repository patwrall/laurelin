{ pkgs
, ...
}:
{
  plugins.cord.enable = false;

  extraPlugins = with pkgs.vimPlugins; [
    (cord-nvim.overrideAttrs (_: {
      nvimRequireCheck = false;
      doCheck = false;
      doInstallCheck = false;
    }))
  ];

  extraConfigLua = ''
    require('cord').setup({
      idle = {
        enabled = false,
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ude";
      action = "<cmd>Cord enable<CR>";
      options = {
        desc = "Enable Discord Presence";
      };
    }
    {
      mode = "n";
      key = "<leader>udd";
      action = "<cmd>Cord disable<CR>";
      options = {
        desc = "Disable Discord Presence";
      };
    }
  ];
}
