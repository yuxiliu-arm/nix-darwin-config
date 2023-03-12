{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  users.users.yuxi =
    {
      name = "yuxi";
      home = "/Users/yuxi";
    };

  home-manager.users.yuxi = { pkgs, ... }: {
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
        unzip

        # editors
        nixpkgs-fmt
        shellcheck

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

        # work
        google-cloud-sdk
        cloud-sql-proxy
        terraform

        # ocaml
        opam

        # rust
        cargo
      ];

    programs.direnv = {
      enable = true;
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
        mergetool.fugitive.cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';

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
      plugins = with pkgs.vimPlugins; [
        vim-easymotion
      ];
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 20000;
      keyMode = "vi";
      aggressiveResize = true;
      terminal = "screen-256color";
      # modified from
      # https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf
      extraConfig = builtins.readFile ./tmux.conf;
    };

    home.file = {
      ".bashrc".source = ./dotfiles/.bashrc;

      # use OCaml syntax for iml and ipl files
      ".config/nvim/syntax/ipl.vim".source = ./neovim/syntax/ipl.vim;
      ".config/nvim/syntax/iml.vim".source = ./neovim/syntax/iml.vim;

      ".inputrc".source = ./dotfiles/.inputrc;
      ".direnvrc".source = ./dotfiles/.direnvrc;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      vim
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;
  programs.bash =
    {
      enable = true;
      enableCompletion = true;
    };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
