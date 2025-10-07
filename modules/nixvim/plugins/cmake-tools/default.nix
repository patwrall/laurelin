{ config
, lib
, ...
}:
{
  plugins = {
    cmake-tools = {
      enable = true;

      lazyLoad.settings = {
        event = [
          "DeferredUIEnter"
        ];
      };

      settings = { };
    };

    which-key.settings.spec = lib.optionals config.plugins.cmake-tools.enable [
      {
        __unkeyed-1 = "<leader>C";
        group = "CMake Tools";
        icon = "";
      }
    ];
  };

  keymaps = lib.optionals config.plugins.cmake-tools.enable [
    {
      mode = "n";
      key = "<leader>Cc";
      action = "<cmd>CMakeConfigure<CR>";
      options.desc = "Configure Project";
    }
    {
      mode = "n";
      key = "<leader>Cb";
      action = "<cmd>CMakeBuild<CR>";
      options.desc = "Build Project";
    }
    {
      mode = "n";
      key = "<leader>Cr";
      action = "<cmd>CMakeRun<CR>";
      options.desc = "Run Executable";
    }
    {
      mode = "n";
      key = "<leader>CR";
      action = "<cmd>CMakeQuickRun<CR>";
      options.desc = "Quick Run (Configure, Build, Run)";
    }
    {
      mode = "n";
      key = "<leader>Cd";
      action = "<cmd>CMakeDebug<CR>";
      options.desc = "Debug Executable";
    }
    {
      mode = "n";
      key = "<leader>Ct";
      action = "<cmd>CMakeTest<CR>";
      options.desc = "Run Tests";
    }
    {
      mode = "n";
      key = "<leader>Cs";
      action = "<cmd>CMakeStop<CR>";
      options.desc = "Stop Current Process";
    }
    {
      mode = "n";
      key = "<leader>Ck";
      action = "<cmd>CMakeSelectKit<CR>";
      options.desc = "Select a Kit (Compiler)";
    }
    {
      mode = "n";
      key = "<leader>Cv";
      action = "<cmd>CMakeSelectBuildVariant<CR>";
      options.desc = "Select Build Variant (Debug/Release)";
    }
    {
      mode = "n";
      key = "<leader>CT";
      action = "<cmd>CMakeSelectBuildTarget<CR>";
      options.desc = "Select Build Target";
    }
    {
      mode = "n";
      key = "<leader>CL";
      action = "<cmd>CMakeSelectLaunchTarget<CR>";
      options.desc = "Select Launch Target";
    }
  ];
}
