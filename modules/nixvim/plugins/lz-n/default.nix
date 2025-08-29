{ config
, ...
}:
{
  plugins = {
    lzn-auto-require.enable = config.laurelin.loading.strategy == "lazy";
    lz-n.enable = config.laurelin.loading.strategy == "lazy";
  };
}
