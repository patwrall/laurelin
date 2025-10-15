{ config
, lib
, pkgs
, ...
}:
{
  extraPackages = lib.mkIf config.plugins.blink-cmp.enable (
    with pkgs;
    [
      # blink-cmp-git
      gh
      # blink use for gitlab ?
      glab
    ]
  );

  extraPlugins = with pkgs.vimPlugins; [
    blink-cmp-avante
    blink-cmp-conventional-commits
    blink-cmp-npm-nvim
  ];

  plugins =
    let
      mkBlinkPlugin =
        { enable ? true
        , ...
        }@args:
        {
          inherit enable;
          lazyLoad.settings.event = [
            "InsertEnter"
            "CmdlineEnter"
          ];
        }
        // (removeAttrs args [ "enable" ]);
    in
    lib.mkMerge [
      {
        blink-cmp = {
          enable = config.laurelin.completion.engine == "blink";

          lazyLoad.settings.event = [
            "InsertEnter"
            "CmdlineEnter"
          ];

          settings = {
            cmdline = {
              completion = {
                list.selection = {
                  preselect = false;
                };
                menu.auto_show = true;
              };
              keymap = {
                preset = "enter";
                "<CR>" = [
                  "accept_and_enter"
                  "fallback"
                ];
              };
            };
            completion = {
              ghost_text.enabled = true;
              documentation = {
                auto_show = true;
                window.border = "rounded";
              };
              list.selection = {
                auto_insert = false;
                preselect = false;
              };
              menu = {
                border = "rounded";
                draw = {
                  columns = [
                    {
                      __unkeyed-1 = "label";
                    }
                    {
                      __unkeyed-1 = "kind_icon";
                      __unkeyed-2 = "kind";
                      gap = 1;
                    }
                    { __unkeyed-1 = "source_name"; }
                  ];
                  components = {
                    kind_icon = {
                      ellipsis = false;
                      text.__raw = ''
                        function(ctx)
                          local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                          -- Check for both nil and the default fallback icon
                          if not kind_icon or kind_icon == '󰞋' then
                            -- Use our configured kind_icons
                            return require('blink.cmp.config').appearance.kind_icons[ctx.kind] or ""
                          end
                          return kind_icon
                        end,
                        -- Optionally, you may also use the highlights from mini.icons
                        highlight = function(ctx)
                          local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                          return hl
                        end
                      '';
                    };
                  };
                };
              };
            };
            fuzzy = {
              implementation = "rust";
              prebuilt_binaries = {
                download = false;
              };
            };
            appearance = {
              use_nvim_cmp_as_default = true;
              kind_icons = {
                Copilot = "";

                Text = "";
                Field = "";
                Variable = "";

                Class = "";
                Interface = "";

                TypeParameter = "";
              };
            };
            keymap = {
              preset = "enter";
            };
            signature = {
              enabled = true;
              window.border = "rounded";
            };
            snippets.preset = "mini_snippets";
            sources = {
              default.__raw = # Lua
                ''
                  function(ctx)
                    local base_sources = { 'lsp', 'buffer', 'path', 'snippets' }

                    local common_sources = vim.deepcopy(base_sources)

                    ${lib.optionalString config.plugins.blink-copilot.enable "table.insert(common_sources, 'copilot')"}
                    ${lib.optionalString config.plugins.blink-emoji.enable "table.insert(common_sources, 'emoji')"}
                    ${lib.optionalString config.plugins.blink-cmp-spell.enable "table.insert(common_sources, 'spell')"}
                    ${lib.optionalString config.plugins.blink-ripgrep.enable "table.insert(common_sources, 'ripgrep')"}
                    ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-npm-nvim config.extraPlugins) "if vim.fn.expand('%:t') == 'package.json' then table.insert(common_sources, 'npm') end"}

                    local success, node = pcall(vim.treesitter.get_node)
                    if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                      return { 'buffer', 'spell' }
                    elseif vim.bo.filetype == 'gitcommit' then
                      local git_sources = { 'buffer', 'spell' }
                      ${lib.optionalString config.plugins.blink-cmp-git.enable "table.insert(git_sources, 'git')"}
                      ${lib.optionalString (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins) "table.insert(git_sources, 'conventional_commits')"}
                      return git_sources
                    else
                      return common_sources
                    end
                  end
                '';
              providers = {
                # BUILT-IN SOURCES
                lsp.score_offset = 4;
                # Community sources
                copilot = lib.mkIf config.plugins.blink-copilot.enable {
                  name = "copilot";
                  module = "blink-copilot";
                  async = true;
                  score_offset = 100;
                };
                conventional_commits =
                  lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins)
                    {
                      name = "Conventional Commits";
                      module = "blink-cmp-conventional-commits";
                      enabled.__raw = ''
                        function()
                          return vim.bo.filetype == 'gitcommit'
                        end
                      '';
                    };
                emoji = lib.mkIf config.plugins.blink-emoji.enable {
                  name = "Emoji";
                  module = "blink-emoji";
                  score_offset = 1;
                };
                git = lib.mkIf config.plugins.blink-cmp-git.enable {
                  name = "Git";
                  module = "blink-cmp-git";
                  enabled = true;
                  score_offset = 100;
                  should_show_items.__raw = ''
                    function()
                      return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                    end
                  '';
                  opts = {
                    git_centers = {
                      github = {
                        issue = {
                          on_error.__raw = "function(_,_) return true end";
                        };
                      };
                    };
                  };
                };
                ripgrep = lib.mkIf config.plugins.blink-ripgrep.enable {
                  name = "Ripgrep";
                  module = "blink-ripgrep";
                  async = true;
                  score_offset = 1;
                };
                spell = lib.mkIf config.plugins.blink-cmp-spell.enable {
                  name = "Spell";
                  module = "blink-cmp-spell";
                  score_offset = 1;
                };
                npm = lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-npm-nvim config.extraPlugins) {
                  name = "npm";
                  module = "blink-cmp-npm";
                  async = true;
                  enabled.__raw = ''
                    function()
                      return vim.fn.expand('%:t') == 'package.json'
                    end
                  '';
                  opts = {
                    ignore = { };
                    only_semantic_versions = true;
                    only_latest_version = false;
                  };
                };
              };
            };
          };
        };

        blink-cmp-git = mkBlinkPlugin { };
        blink-cmp-spell = mkBlinkPlugin { };
        blink-copilot = mkBlinkPlugin {
          enable = config.laurelin.ai.provider == "copilot" && config.laurelin.completion.engine == "blink";
        };
        blink-emoji = mkBlinkPlugin { };
        blink-ripgrep = mkBlinkPlugin { };
      }
    ];
}
