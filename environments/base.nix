{ config, pkgs, lib, ... }:
{
  imports = [
    ../options/networking.nix
    # TODO ../options/gpg.nix
    ../options/localization.nix
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../services/ssh.nix
    ../services/avahi.nix
    ../services/podman.nix
  ];

  #TODO  services.tailscale.enable = true;

  programs.bash.promptInit = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  # TODO
  fonts = {
    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      # nerdfonts.fira-code
      # nerdfonts.droid-sans-mono
      roboto
      roboto-mono
      noto-fonts-emoji
    ];
    enableDefaultPackages = true;
    # fontconfig = {
    #   enable = true;
    #   antialias = true;
    #   defaultFonts = {
    #     serif = [ "Roboto" ];
    #     sansSerif = [ "Roboto" ];
    #     monospace = [ "Roboto Mono" ];
    #     emoji = [ "Noto Color Emoji" "Noto Emoji" ];
    #   };
    #   hinting = {
    #     enable = true;
    #     style = "medium";
    #   };
    #   subpixel = {
    #     rgba = "vrgb";
    #     lcdfilter = "none";
    #   };
    # };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    btop
    wget
    curl
    nnn
    neofetch
    tree
    simple-http-server
    p7zip
    unzip
    zip
    podman-compose
    git
    picocom
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
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
      packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            vim-fugitive
            vim-nix
            vim-go
            vim-javascript
            typescript-vim
            vim-json
            vim-markdown
            vim-protobuf
            rust-vim
            vim-cpp-enhanced-highlight
          ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set-option -g mouse on
    '';
  };
}
