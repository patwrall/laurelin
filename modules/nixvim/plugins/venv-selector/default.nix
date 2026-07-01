{ config, pkgs, lib, ... }:
{
  extraPackages = lib.mkIf config.plugins.venv-selector.enable [ pkgs.fd ];

  plugins.venv-selector = {
    enable = true;
    lazyLoad.settings.ft = [ "python" ];

    settings.options = {
      picker = if config.plugins.snacks.enable then "snacks" else "auto";
      override_notify = false;
      require_lsp_activation = true;
    };
  };

  keymaps = lib.mkIf config.plugins.venv-selector.enable [
    {
      mode = "n";
      key = "<leader>zv";
      action = "<cmd>VenvSelect<CR>";
      options.desc = "Select Virtual Environment";
    }
    {
      mode = "n";
      key = "<leader>zc";
      action = "<cmd>VenvSelectCached<CR>";
      options.desc = "Activate Cached Venv";
    }
  ];
}
