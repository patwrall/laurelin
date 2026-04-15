{ config
, lib
, pkgs
, ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.esp32 = {
    enable = lib.mkEnableOption "esp32" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "esp32" {
      default = "esp32-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Configuration for esp32. See https://github.com/Aietes/esp32.nvim";
    };
  };

  config =
    let
      luaConfig = # Lua
        ''
          require('esp32').setup(${lib.generators.toLua { } config.plugins.esp32.settings})
        '';
    in
    lib.mkIf config.plugins.esp32.enable {
      # Conditional Lua config - only load if lz-n is disabled
      extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

      extraPlugins = [
        {
          plugin = config.plugins.esp32.package;
          optional = config.plugins.lz-n.enable;
        }
      ];

      # lz-n lazy loading configuration
      plugins = {
        lz-n = {
          plugins = [
            {
              __unkeyed-1 = "esp32.nvim";
              cmd = [
                "ESPReconfigure"
                "ESPInfo"
              ];
              after = ''
                function()
                  ${luaConfig}
                end
              '';
            }
          ];
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>Rb";
          action.__raw = "function() require('esp32').build() end";
          options.desc = "ESP32 Build";
        }
        {
          mode = "n";
          key = "<leader>Rf";
          action.__raw = "function() require('esp32').command('flash') end";
          options.desc = "ESP32 Flash";
        }
        {
          mode = "n";
          key = "<leader>RF";
          action.__raw = "function() require('esp32').pick('flash') end";
          options.desc = "ESP32 Pick & Flash";
        }
        {
          mode = "n";
          key = "<leader>Rm";
          action.__raw = "function() require('esp32').command('monitor') end";
          options.desc = "ESP32 Monitor";
        }
        {
          mode = "n";
          key = "<leader>RM";
          action.__raw = "function() require('esp32').pick('monitor') end";
          options.desc = "ESP32 Pick & Monitor";
        }
        {
          mode = "n";
          key = "<leader>Rc";
          action.__raw = "function() require('esp32').command('menuconfig') end";
          options.desc = "ESP32 Menuconfig";
        }
        {
          mode = "n";
          key = "<leader>RC";
          action.__raw = "function() require('esp32').command('clean') end";
          options.desc = "ESP32 Clean";
        }
        {
          mode = "n";
          key = "<leader>Re";
          action = "<cmd>ESPReconfigure<cr>";
          options.desc = "ESP32 Reconfigure";
        }
        {
          mode = "n";
          key = "<leader>Ri";
          action = "<cmd>ESPInfo<cr>";
          options.desc = "ESP32 Project Info";
        }
      ];
    };
}
