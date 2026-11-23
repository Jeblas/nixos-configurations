{ config, pkgs, lib, ... }:
let
  # The registry entry for the user this profile belongs to; git identity
  # (and any future per-user bits) come from users/default.nix.
  registry = (import ../../users/default.nix).users;
  me = builtins.head (builtins.filter (u: u.userName == config.home.username) registry);
in
{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    sessionVariables = {
      NNN_PLUG = "v:imgview;p:preview-tui";
      NNN_FIFO = "/tmp/nnn.fifo";
    };
    shellAliases = {
      vim = "nvim";
      ll = "ls -lah";
      la = "ls -A";
      ".." = "cd ..";
      n = "nnn";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        # Falls back to userName ("jeblas") unless fullName is set in
        # users/default.nix.
        name = me.fullName or me.userName;
      } // lib.optionalAttrs (me.email != "") {
        email = me.email;
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
    };
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number
      " Show whitespace
      " set list
      set ruler
      set ignorecase
      set hlsearch
      set showmatch
      set foldcolumn=1
      syntax enable
      set expandtab
      set smarttab
      " 1 tab == 4 spaces
      set shiftwidth=4
      set tabstop=4
      " Linebreak on 500 chars
      set lbr
      set tw=500
      set mouse=a
      set history=500
      " Set to auto read when a file is modified externally
      set autoread
      au FocusGained,BufEnter * checktime
      " :W sudo saves the file
      command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
    '';
    plugins = with pkgs.vimPlugins; [
      vim-fugitive
      vim-nix
      vim-go
      vim-javascript
      haskell-vim
      typescript-vim
      zig-vim
      vim-json
      vim-toml
      vim-markdown
      vim-protobuf
      rust-vim
      vim-cpp-enhanced-highlight
    ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    escapeTime = 500;
  };
}
