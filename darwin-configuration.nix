{ config, pkgs, ... }:

{

  # nixpkgs.hostPlatform = "aarch64-darwin";
  nix.extraOptions = ''
    experimental-features = nix-command flakes

    # lean config {
    max-jobs = auto  # Allow building multiple derivations in parallel
    keep-outputs = true  # Do not garbage-collect build time-only dependencies (e.g. clang)
    
    # Allow fetching build results from the Lean Cachix cache
    trusted-users = yuxi
    trusted-substituters = https://lean4.cachix.org/
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk=
    # }
  '';

  users.users.yuxi =
    {
      name = "yuxi";
      home = "/Users/yuxi";
    };

  # home-manager.users.yuxi = import ./home.nix { inherit pkgs; };

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
