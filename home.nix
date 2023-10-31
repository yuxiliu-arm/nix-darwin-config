{ pkgs, ... }: {
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = with pkgs;
    [
      # editors
      nixpkgs-fmt
      shellcheck

      # lvim
      nodejs
      lazygit
      tree-sitter

      # tmux
      tmux-mem-cpu-load

      # utilities
      htop
      bc
      sshfs
      parallel
      watch
      wget
      jq
      ripgrep
      unzip
      tree

      # work
      google-cloud-sdk
      cloud-sql-proxy
      terraform
      entr
      util-linux # for setsid

      # ocaml
      opam

      # rust
      rustup

      # lean
      elan

      # lua
      luajit
      luaformatter
    ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "crvdgc";
    userEmail = "ubikium@gmail.com";
    extraConfig = {
      merge.tool = "fugitive";
      mergetool.keepBackup = false;
      mergetool.fugitive.cmd = ''lvim -f -c "Gvdiffsplit!" "$MERGED"'';

      # stop git from changing line endings
      core.autocrlf = false;
      core.whitespace = "cr-at-eol";

      # let git display utf-8 characters
      core.quotepath = false; # git status utf-8
      gui.encoding = "utf-8"; # git GUI utf-8
      i18n.commit.encoding = "utf-8"; # commit utf-8
      i18n.logoutputencoding = "utf-8"; # log utf-8

      init.defaultBranch = "master";
    };
  };

  programs.neovim = {
    enable = true;
    plugins = import ./neovim/plugins.nix { inherit pkgs; };
    coc = {
      enable = true;
      pluginConfig = builtins.readFile ./neovim/coc.vim;
      settings = import ./neovim/coc-settings.json.nix;
    };
    extraConfig = builtins.readFile ./neovim/init.vim;
    # extraLuaConfig = builtins.readFile ./neovim/init.lua;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 20000;
    keyMode = "vi";
    aggressiveResize = true;
    terminal = "screen-256color";
    shell = "${pkgs.bash}/bin/bash";
    # modified from
    # https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf
    extraConfig = builtins.readFile ./tmux.conf;
  };

  home.file =
    let
      ocaml-syntax = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/neovim/neovim/master/runtime/syntax/ocaml.vim";
        sha256 = "U52MI3QMk9sCZ4184Y1rDAyJcqjt/7HJbOOKCY+Md0w=";
      };
    in
    {
      ".bashrc".source = ./dotfiles/.bashrc;
      ".profile".text = "source ~/.bashrc";
      ".git-prompt.sh".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/git/git/e03acd0d4ad75115f454041fac3300ae796f108f/contrib/completion/git-prompt.sh";
        sha256 = "XvptvCjYHcDa2YWlhVMhK3oziE3aUAb6uYV0CuJvfl8=";
      };

      # use OCaml syntax for iml and ipl files
      ".config/nvim/syntax/ipl.vim".source = ocaml-syntax;
      ".config/nvim/syntax/iml.vim".source = ocaml-syntax;

      # lean.nvim
      ".config/nvim/plugin/lean.lua".source = ./neovim/lean.lua;
      ".config/nvim/ftplugin/iml.vim".source = ./neovim/ftplugin/iml.vim;
      ".config/nvim/ftplugin/ocaml.lua".source = ./neovim/ftplugin/ocaml.lua;

      ".inputrc".source = ./dotfiles/.inputrc;
      ".direnvrc".source = ./dotfiles/.direnvrc;
    };
}
