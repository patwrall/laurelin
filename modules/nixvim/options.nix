{ lib
, pkgs
, ...
}:
{
  clipboard = {
    register = "unnamedplus";

    providers = {
      wl-copy = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
        package = pkgs.wl-clipboard;
      };
    };
  };

  colorscheme = "catppuccin";
  colorschemes.catppuccin.enable = true;
  luaLoader.enable = true;

  globals = {
    loaded_ruby_provider = 0;
    loaded_perl_provider = 0;
    loaded_python_provider = 0;

    disable_diagnostics = false;
    disable_autoformat = false;
    spell_enabled = true;
    colorizing_enabled = false;
    first_buffer_opened = false;
    whitespace_character_enabled = false;
  };

  opts = {
    # keep-sorted start block=yes newline_separated=no
    autoindent = true;
    breakindent = true;
    cmdheight = 0;
    copyindent = true;
    cursorcolumn = false;
    cursorline = true;
    expandtab = true;
    fileencoding = "utf-8";
    fillchars = {
      horiz = "━";
      horizup = "┻";
      horizdown = "┳";
      vert = "┃";
      vertleft = "┫";
      vertright = "┣";
      verthoriz = "╋";

      eob = " ";
      diff = "╱";

      fold = " ";
      foldopen = "";
      foldclose = "";

      msgsep = "‾";
    };
    foldcolumn = "1";
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = -1;
    hidden = true;
    history = 100;
    ignorecase = true;
    inccommand = "nosplit";
    incsearch = true;
    infercase = true;
    laststatus = 3;
    lazyredraw = false;
    linebreak = true;
    matchtime = 1;
    modeline = true;
    modelines = 100;
    mouse = "a";
    mousemodel = "extend";
    number = true;
    preserveindent = true;
    pumheight = 10;
    relativenumber = true;
    report = 9001;
    scrolloff = 4;
    shiftround = true;
    shiftwidth = 2;
    showmatch = true;
    showmode = false;
    showtabline = 2;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    softtabstop = 0;
    spell = true;
    spelllang = lib.mkDefault [ "en_us" ];
    splitbelow = true;
    splitright = true;
    startofline = true;
    swapfile = false;
    synmaxcol = 240;
    tabstop = 2;
    termguicolors = true;
    textwidth = 0;
    timeoutlen = 500;
    title = true;
    undofile = true;
    updatetime = 100;
    virtualedit = "block";
    wrap = false;
    writebackup = false;
    # keep-sorted end
  };
}
