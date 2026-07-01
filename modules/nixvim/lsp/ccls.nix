{ config, ... }:
{
  plugins.lsp.servers.ccls = {
    enable = config.laurelin.editor.cCompiler == "ccls";
    initOptions.compilationDatabaseDirectory = "build";
  };
}

