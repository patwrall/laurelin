{ config
, lib
, pkgs
, ...
}:
{
  performance = lib.mkIf config.laurelin.performance.optimizeEnable {
    byteCompileLua = {
      enable = true;
      configs = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;

      standalonePlugins = with pkgs.vimPlugins; [
        "firenvim"
        "neotest"
        "nvim-treesitter"
        mini-nvim
        overseer-nvim
        vs-tasks-nvim
      ];
    };
  };
}
