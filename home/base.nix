{ config, pkgs, lib, ... }:
{
  # Keep this in sync with the release you first activated Home Manager with.
  home.stateVersion = "26.11";

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
      user.name = "John Blasco";
      # TODO: set user.email here once you have one configured.
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

  # Git gives ~/.gitconfig precedence over $XDG_CONFIG_HOME/git/config.
  # Keep the legacy path linked to the Home Manager-managed XDG config.
  home.file.".gitconfig".source = config.xdg.configFile."git/config".source;

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
