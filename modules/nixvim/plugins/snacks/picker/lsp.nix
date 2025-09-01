_:
{
  keymaps = [
    {
      mode = "n";
      key = "<leader>ss";
      action = ''<cmd>lua Snacks.picker.lsp_symbols()<cr>'';
      options = {
        desc = "Find lsp document symbols";
      };
    }
    {
      mode = "n";
      key = "gd";
      action = ''<cmd>lua Snacks.picker.lsp_definitions()<cr>'';
      options = {
        desc = "Goto Definition";
      };
    }
    {
      mode = "n";
      key = "gD";
      action = ''<cmd>lua Snacks.picker.lsp_declarations()<cr>'';
      options = {
        desc = "Goto Declaration";
      };
    }
    {
      mode = "n";
      key = "grr";
      action = ''<cmd>lua Snacks.picker.lsp_references()<cr>'';
      options = {
        desc = "Goto References";
        nowait = true;
      };
    }
    {
      mode = "n";
      key = "gI";
      action = ''<cmd>lua Snacks.picker.lsp_implementations()<cr>'';
      options = {
        desc = "soto Implementation";
      };
    }
    {
      mode = "n";
      key = "gy";
      action = ''<cmd>lua Snacks.picker.lsp_type_definitions()<cr>'';
      options = {
        desc = "Goto T[y]pe Definition";
      };
    }
  ];
}
