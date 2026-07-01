_:
{
  plugins.mini = {
    enable = true;

    modules.hipatterns = {
      highlighters = {
        hex_color.__raw = ''require("mini.hipatterns").gen_highlighter.hex_color()'';
      };
    };
  };
}
