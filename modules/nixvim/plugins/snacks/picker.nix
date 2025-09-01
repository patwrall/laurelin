{ config
, lib
, pkgs
, ...
}:
{
  imports = [
    ./picker/lsp.nix
  ];

  config = lib.mkIf (config.laurelin.picker.engine == "snacks") {
    extraPlugins = with pkgs.vimPlugins; [
      snacks-nvim
      lazy-nvim
    ];

    extraConfigLuaPre = # Lua
      ''
        laurelin = {}

        local M_root = setmetatable({}, {
          __call = function(m, ...) return m.get(...) end,
        })
        M_root.spec = { "lsp", { ".git", "lua" }, "cwd" }
        M_root.detectors = {}
        function M_root.detectors.cwd() return { vim.uv.cwd() } end
        function M_root.detectors.lsp(buf)
          local bufpath = M_root.bufpath(buf)
          if not bufpath then return {} end
          local roots = {}
          local clients = vim.lsp.get_clients({ bufnr = buf })
          clients = vim.tbl_filter(function(client) return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name) end, clients)
          for _, client in pairs(clients) do
            local workspace = client.config.workspace_folders
            for _, ws in pairs(workspace or {}) do roots[#roots + 1] = vim.uri_to_fname(ws.uri) end
            if client.root_dir then roots[#roots + 1] = client.root_dir end
          end
          return vim.tbl_filter(function(path) path = M_root.realpath(path); return path and bufpath:find(path, 1, true) == 1 end, roots)
        end
        function M_root.detectors.pattern(buf, patterns)
          patterns = type(patterns) == "string" and { patterns } or patterns
          local path = M_root.bufpath(buf) or vim.uv.cwd()
          local pattern = vim.fs.find(function(name)
            for _, p in ipairs(patterns) do
              if name == p then return true end
              if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then return true end
            end
            return false
          end, { path = path, upward = true })[1]
          return pattern and { vim.fs.dirname(pattern) } or {}
        end
        function M_root.bufpath(buf) return M_root.realpath(vim.api.nvim_buf_get_name(assert(buf))) end
        function M_root.cwd() return M_root.realpath(vim.uv.cwd()) or "" end
        function M_root.realpath(path)
          if path == "" or path == nil then return nil end
          path = vim.uv.fs_realpath(path) or path
          return (vim.fn.has("win32") == 1 and path:gsub("\\", "/") or path)
        end
        function M_root.resolve(spec)
          if M_root.detectors[spec] then return M_root.detectors[spec]
          elseif type(spec) == "function" then return spec end
          return function(buf) return M_root.detectors.pattern(buf, spec) end
        end
        function M_root.detect(opts)
          opts = opts or {}
          opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M_root.spec
          opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf
          local ret = {}
          for _, spec in ipairs(opts.spec) do
            local paths = M_root.resolve(spec)(opts.buf)
            paths = paths or {}; paths = type(paths) == "table" and paths or { paths }
            local roots = {}
            for _, p in ipairs(paths) do
              local pp = M_root.realpath(p)
              if pp and not vim.tbl_contains(roots, pp) then roots[#roots + 1] = pp end
            end
            table.sort(roots, function(a, b) return #a > #b end)
            if #roots > 0 then
              ret[#ret + 1] = { spec = spec, paths = roots }
              if opts.all == false then break end
            end
          end
          return ret
        end
        M_root.cache = {}
        function M_root.get(opts)
          opts = opts or {}
          local buf = opts.buf or vim.api.nvim_get_current_buf()
          local ret = M_root.cache[buf]
          if not ret then
            local roots = M_root.detect({ all = false, buf = buf })
            ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
            M_root.cache[buf] = ret
          end
          return ret
        end
        laurelin.root = M_root

        local M_pick = setmetatable({}, {
          __call = function(m, ...) return m.wrap(...) end,
        })
        M_pick.picker = nil
        function M_pick.register(picker)
          if M_pick.picker and M_pick.picker.name ~= picker.name then return false end
          M_pick.picker = picker
          return true
        end
        function M_pick.open(command, opts)
          if not M_pick.picker then return print("laurelin.pick: picker not set") end
          command = command ~= "auto" and command or "files"
          opts = opts or {}; opts = vim.deepcopy(opts)
          if not opts.cwd and opts.root ~= false then opts.cwd = laurelin.root({ buf = opts.buf }) end
          command = M_pick.picker.commands[command] or command
          M_pick.picker.open(command, opts)
        end
        function M_pick.wrap(command, opts)
          opts = opts or {}
          return function() M_pick.open(command, vim.deepcopy(opts)) end
        end
        function M_pick.config_files()
          return M_pick.wrap("files", { cwd = vim.fn.stdpath("config") })
        end
        laurelin.pick = M_pick
      '';


    extraConfigLua = # Lua
      ''
        local picker = {
          name = "snacks",
          commands = {
            files = "files",
            live_grep = "grep",
            oldfiles = "recent",
          },
          open = function(source, opts)
            return require("snacks").picker.pick(source, opts)
          end,
        }
        laurelin.pick.register(picker)
      '';

    plugins.snacks = {
      enable = true;
      settings = {
        picker = {
          actions = {
            calculate_file_truncate_width.__raw = ''
              function(self)
                  local width = self.list.win:size().width
                      self.opts.formatters.file.truncate = width - 6
              end
            '';
          };
          win = {
            list = {
              on_buf.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
            };
            preview = {
              on_buf.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
              on_close.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
            };
          };
          layouts = {
            select = {
              layout = {
                relative = "cursor";
                width = 70;
                min_width = 0;
                row = 1;
              };
            };
          };
        };
      };
    };

    keymaps =
      let
        helpers = {
          p = picker: { action.__raw = "function() require('snacks').picker.${picker} end"; };
          pick = source: { action.__raw = "function() laurelin.pick('${source}')() end"; };
          pickOpts = source: opts: { action.__raw = "function() laurelin.pick('${source}', ${opts})() end"; };
          pickFn = fn: { action.__raw = "function() laurelin.pick.${fn}() end"; };
          pWithArgs = picker: args: {
            action.__raw = "function() require('snacks').picker.${picker}(${lib.generators.toLua {} args}) end";
          };
        };
      in
      [
        # Top-level maps
        ({ mode = "n"; key = "<leader>,"; options.desc = "Buffers"; } // helpers.p "buffers()")
        ({ mode = "n"; key = "<leader>/"; options.desc = "Grep (Root Dir)"; } // helpers.pick "grep")
        ({ mode = "n"; key = "<leader>:"; options.desc = "Command History"; } // helpers.p "command_history()")
        ({ mode = "n"; key = "<leader><space>"; options.desc = "Find Files (Root Dir)"; } // helpers.pick "files")
        ({ mode = "n"; key = "<leader>n"; options.desc = "Notification History"; } // helpers.p "notifications()")

        # Find group
        ({ mode = "n"; key = "<leader>fb"; options.desc = "Buffers"; } // helpers.p "buffers()")
        ({ mode = "n"; key = "<leader>fB"; options.desc = "Buffers (all)"; } // helpers.p "buffers({ hidden = true, nofile = true})")
        ({ mode = "n"; key = "<leader>ff"; options.desc = "Find Files (Root Dir)"; } // helpers.pick "files")
        ({ mode = "n"; key = "<leader>fF"; options.desc = "Find Files (cwd)"; } // helpers.pickOpts "files" "{ root = false }")
        ({ mode = "n"; key = "<leader>fg"; options.desc = "Find Files (git-files)"; } // helpers.p "git_files()")
        ({ mode = "n"; key = "<leader>fr"; options.desc = "Recent"; } // helpers.pick "oldfiles")
        ({ mode = "n"; key = "<leader>fR"; options.desc = "Recent (cwd)"; } // helpers.p "recent({ filter = { cwd = true }})")
        ({ mode = "n"; key = "<leader>fp"; options.desc = "Projects"; } // helpers.p "projects()")

        # Git group
        ({ mode = "n"; key = "<leader>gd"; options.desc = "Git Diff (hunks)"; } // helpers.p "git_diff()")
        ({ mode = "n"; key = "<leader>gs"; options.desc = "Git Status"; } // helpers.p "git_status()")
        ({ mode = "n"; key = "<leader>gS"; options.desc = "Git Stash"; } // helpers.p "git_stash()")

        # Grep group
        ({ mode = "n"; key = "<leader>sb"; options.desc = "Buffer Lines"; } // helpers.p "lines()")
        ({ mode = "n"; key = "<leader>sB"; options.desc = "Grep Open Buffers"; } // helpers.p "grep_buffers()")
        ({ mode = "n"; key = "<leader>sg"; options.desc = "Grep (Root Dir)"; } // helpers.pick "live_grep")
        ({ mode = "n"; key = "<leader>sG"; options.desc = "Grep (cwd)"; } // helpers.pickOpts "live_grep" "{ root = false }")
        ({ mode = [ "n" "x" ]; key = "<leader>sw"; options.desc = "Visual selection or word (Root Dir)"; } // helpers.pick "grep_word")
        ({ mode = [ "n" "x" ]; key = "<leader>sW"; options.desc = "Visual selection or word (cwd)"; } // helpers.pickOpts "grep_word" "{ root = false }")
        ({ mode = "n"; key = "<leader>st"; options.desc = "TODOs"; } // helpers.p "todo_comments()")
        ({
          mode = "n";
          key = "<leader>sT";
          options.desc = "TODOs/FIXs/FIXMEs";
        } // helpers.pWithArgs "todo_comments" {
          keywords = [ "TODO" "FIX" "FIXME" ];
        })

        # Search group
        ({ mode = "n"; key = "<leader>s\""; options.desc = "Registers"; } // helpers.p "registers()")
        ({ mode = "n"; key = "<leader>s/"; options.desc = "Search History"; } // helpers.p "search_history()")
        ({ mode = "n"; key = "<leader>sa"; options.desc = "Autocmds"; } // helpers.p "autocmds()")
        ({ mode = "n"; key = "<leader>sc"; options.desc = "Command History"; } // helpers.p "command_history()")
        ({ mode = "n"; key = "<leader>sC"; options.desc = "Commands"; } // helpers.p "commands()")
        ({ mode = "n"; key = "<leader>sd"; options.desc = "Diagnostics"; } // helpers.p "diagnostics()")
        ({ mode = "n"; key = "<leader>sD"; options.desc = "Buffer Diagnostics"; } // helpers.p "diagnostics_buffer()")
        ({ mode = "n"; key = "<leader>sh"; options.desc = "Help Pages"; } // helpers.p "help()")
        ({ mode = "n"; key = "<leader>sH"; options.desc = "Highlights"; } // helpers.p "highlights()")
        ({ mode = "n"; key = "<leader>si"; options.desc = "Icons"; } // helpers.p "icons()")
        ({ mode = "n"; key = "<leader>sj"; options.desc = "Jumps"; } // helpers.p "jumps()")
        ({ mode = "n"; key = "<leader>sk"; options.desc = "Keymaps"; } // helpers.p "keymaps()")
        ({ mode = "n"; key = "<leader>sl"; options.desc = "Location List"; } // helpers.p "loclist()")
        ({ mode = "n"; key = "<leader>sM"; options.desc = "Man Pages"; } // helpers.p "man()")
        ({ mode = "n"; key = "<leader>sm"; options.desc = "Marks"; } // helpers.p "marks()")
        ({ mode = "n"; key = "<leader>sR"; options.desc = "Resume"; } // helpers.p "resume()")
        ({ mode = "n"; key = "<leader>sq"; options.desc = "Quickfix List"; } // helpers.p "qflist()")
        ({ mode = "n"; key = "<leader>su"; options.desc = "Undotree"; } // helpers.p "undo()")

        # UI group
        ({ mode = "n"; key = "<leader>uC"; options.desc = "Colorschemes"; } // helpers.p "colorschemes()")
      ];
  };
}
