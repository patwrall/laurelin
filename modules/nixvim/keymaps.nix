{ helpers
, lib
, ...
}:
{
  extraConfigLuaPre = ''
    local diagnostic_goto = function(next, severity)
      local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
      severity = severity and vim.diagnostic.severity[severity] or nil
      return function()
        go({ severity = severity })
      end
    end
  '';

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps =
    let
      mkModeMaps = mode: maps:
        lib.mapAttrsToList
          (key: attrs: {
            inherit mode key;
            action = attrs.action or attrs;
            options = attrs.options or { };
          })
          maps;

      mkMultiModeMaps = multiMaps:
        lib.flatten (lib.mapAttrsToList
          (key: attrs:
            map
              (mode: {
                inherit mode key;
                inherit (attrs) action;
                options = attrs.options or { };
              })
              attrs.modes
          )
          multiMaps);

      maps = {
        normal = {
          # Move to window using the <ctrl> hjkl keys
          "<C-h>" = {
            action = "<C-w>h";
            options = {
              desc = "Go to Left Window";
              remap = true;
            };
          };
          "<C-j>" = {
            action = "<C-w>j";
            options = {
              desc = "Go to Lower Window";
              remap = true;
            };
          };
          "<C-k>" = {
            action = "<C-w>k";
            options = {
              desc = "Go to Upper Window";
              remap = true;
            };
          };
          "<C-l>" = {
            action = "<C-w>l";
            options = {
              desc = "Go to Right Window";
              remap = true;
            };
          };
          # Resize window using <ctrl> arrow keys
          "<C-Left>" = {
            action = "<cmd>vertical resize -2<cr>";
            options.desc = "Decrease Window Width";
          };
          "<C-Down>" = {
            action = "<cmd>resize -2<cr>";
            options.desc = "Decrease Window Height";
          };
          "<C-Up>" = {
            action = "<cmd>resize +2<cr>";
            options.desc = "Increase Window Height";
          };
          "<C-Right>" = {
            action = "<cmd>vertical resize +2<cr>";
            options.desc = "Increase Window Width";
          };
          # Move lines up/down
          "<A-j>" = {
            action = "<cmd>execute 'move .+' . v:count1<cr>==";
            options.desc = "Move Down";
          };
          "<A-k>" = {
            action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
            options.desc = "Move Up";
          };
          # Buffers
          "<S-h>" = {
            action = "<cmd>bprevious<cr>";
            options.desc = "Prev Buffer";
          };
          "<S-l>" = {
            action = "<cmd>bnext<cr>";
            options.desc = "Next Buffer";
          };
          "<[b>" = {
            action = "<cmd>bprevious<cr>";
            options.desc = "Prev Buffer";
          };
          "<]b>" = {
            action = "<cmd>bnext<cr>";
            options.desc = "Next Buffer";
          };
          "<leader>bb" = {
            action = "<cmd>e #<cr>";
            options.desc = "Switch to Other Buffer";
          };
          "<leader>`" = {
            action = "<cmd>e #<cr>";
            options.desc = "Switch to Other Buffer";
          };
          "<leader>bD" = {
            action = "<cmd>:bd<cr>";
            options.desc = "Delete Buffer and Window";
          };
          # Clear search, diff update and redraw
          "<leader>ur" = {
            action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
            options.desc = "Redraw / Clear hlsearch / Diff Update";
          };
          # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
          "n" = {
            action = "'Nn'[v:searchforward].'zv'";
            options = { desc = "Next Search Result"; expr = true; };
          };
          "N" = {
            action = "'nN'[v:searchforward].'zv'";
            options = { desc = "Prev Search Result"; expr = true; };
          };
          # keywordprg
          "<leader>K" = {
            action = "<cmd>norm! K<cr>";
            options.desc = "Keywordprg";
          };
          # commenting
          "gco" = {
            action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
            options.desc = "Add Comment Below";
          };
          "gcO" = {
            action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
            options.desc = "Add Comment Above";
          };
          # New file
          "<leader>fn" = {
            action = "<cmd>enew<cr>";
            options.desc = "New File";
          };
          # location list
          "<leader>xl" = {
            action.__raw = ''
              function()
                local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
                if not success and err then
                  vim.notify(err, vim.log.levels.ERROR)
                end
              end
            '';
            options.desc = "Location List";
          };
          # quickfix list
          "<leader>xq" = {
            action.__raw = ''
              function()
                local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
                if not success and err then
                  vim.notify(err, vim.log.levels.ERROR)
                end
              end
            '';
            options.desc = "Quickfix List";
          };
          "[q" = {
            action.__raw = "vim.cmd.cprev";
            options.desc = "Prev Quickfix";
          };
          "]q" = {
            action.__raw = "vim.cmd.cnext";
            options.desc = "Next Quickfix";
          };
          # diagnostic
          "<leader>cd" = {
            action.__raw = "vim.diagnostic.open_float";
            options.desc = "Line Diagnostics";
          };
          "]d" = {
            action.__raw = "diagnostic_goto(true)";
            options.desc = "Next Diagnostic";
          };
          "[d" = {
            action.__raw = "diagnostic_goto(false)";
            options.desc = "Prev Diagnostic";
          };
          "]e" = {
            action.__raw = "diagnostic_goto(true, 'ERROR')";
            options.desc = "Next Error";
          };
          "[e" = {
            action.__raw = "diagnostic_goto(false, 'ERROR')";
            options.desc = "Prev Error";
          };
          "]w" = {
            action.__raw = "diagnostic_goto(true, 'WARN')";
            options.desc = "Next Warning";
          };
          "[w" = {
            action.__raw = "diagnostic_goto(false, 'WARN')";
            options.desc = "Prev Warning";
          };
          # quit
          "<leader>qq" = {
            action = "<cmd>qa<cr>";
            options.desc = "Quit All";
          };
          # highlights under cursor
          "<leader>ui" = {
            action.__raw = "vim.show_pos";
            options.desc = "Inspect Pos";
          };
          "<leader>uI" = {
            action.__raw = "function() vim.treesitter.inspect_tree() vim.api.nvim_input('I') end";
            options.desc = "Inspect Tree";
          };
          # windows
          "<leader>-" = {
            action = "<C-W>s";
            options = {
              desc = "Split Window Below";
              remap = true;
            };
          };
          "<leader>|" = {
            action = "<C-W>v";
            options = {
              desc = "Split Window Right";
              remap = true;
            };
          };
          "<leader>wd" = {
            action = "<C-W>c";
            options = {
              desc = "Delete Window";
              remap = true;
            };
          };
          "<leader><tab>l" = {
            action = "<cmd>tablast<cr>";
            options.desc = "Last Tab";
          };
          "<leader><tab>o" = {
            action = "<cmd>tabonly<cr>";
            options.desc = "Close Other Tabs";
          };
          "<leader><tab>f" = {
            action = "<cmd>tabfirst<cr>";
            options.desc = "First Tab";
          };
          "<leader><tab><tab>" = {
            action = "<cmd>tabnew<cr>";
            options.desc = "New Tab";
          };
          "<leader><tab>]" = {
            action = "<cmd>tabnext<cr>";
            options.desc = "Next Tab";
          };
          "<leader><tab>d" = {
            action = "<cmd>tabclose<cr>";
            options.desc = "Close Tab";
          };
          "<leader><tab>[" = {
            action = "<cmd>tabprevious<cr>";
            options.desc = "Previous Tab";
          };
        };
        visual = {
          # Move lines up/down
          "<A-j>" = {
            action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
            options.desc = "Move Down";
          };
          "<A-k>" = {
            action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
            options.desc = "Move Up";
          };
          # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
          "n" = {
            action = "'Nn'[v:searchforward]";
            options = { desc = "Next Search Result"; expr = true; };
          };
          "N" = {
            action = "'nN'[v:searchforward]";
            options = { desc = "Prev Search Result"; expr = true; };
          };
          # Better indenting
          "<" = {
            action = "<gv";
          };
          ">" = {
            action = ">gv";
          };
        };
        insert = {
          # Move lines up/down
          "<A-j>" = {
            action = "<esc><cmd>m .+1<cr>==gi";
            options.desc = "Move Down";
          };
          "<A-k>" = {
            action = "<esc><cmd>m .-2<cr>==gi";
            options.desc = "Move Up";
          };
          # Add undo break-points
          "," = {
            action = ",<c-g>u";
          };
          "." = {
            action = ".<c-g>u";
          };
          ";" = {
            action = ";<c-g>u";
          };
        };
        operator-pending = {
          # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
          "n" = {
            action = "'Nn'[v:searchforward]";
            options = { desc = "Next Search Result"; expr = true; };
          };
          "N" = {
            action = "'nN'[v:searchforward]";
            options = { desc = "Prev Search Result"; expr = true; };
          };
        };
        multi = {
          "j" = {
            modes = [ "n" "x" ];
            action = "v:count == 0 ? 'gj' : 'j'";
            options = { desc = "Down"; expr = true; };
          };
          "<Down>" = {
            modes = [ "n" "x" ];
            action = "v:count == 0 ? 'gj' : 'j'";
            options = { desc = "Down"; expr = true; };
          };
          "k" = {
            modes = [ "n" "x" ];
            action = "v:count == 0 ? 'gk' : 'k'";
            options = { desc = "Up"; expr = true; };
          };
          "<Up>" = {
            modes = [ "n" "x" ];
            action = "v:count == 0 ? 'gk' : 'k'";
            options = { desc = "Up"; expr = true; };
          };
          # Save file
          "<C-s>" = {
            modes = [ "i" "x" "n" "s" ];
            action = "<cmd>w<cr><esc>";
            options.desc = "Save File";
          };
        };
      };
    in
    helpers.keymaps.mkKeymaps
      {
        options.silent = true;
      }
      (
        (mkModeMaps "n" maps.normal) ++
        (mkModeMaps "v" maps.visual) ++
        (mkModeMaps "i" maps.insert) ++
        (mkModeMaps "o" maps.operator-pending) ++
        (mkMultiModeMaps maps.multi)
      );
}
