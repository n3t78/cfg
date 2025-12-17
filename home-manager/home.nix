# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./cfg
  ];

  nixpkgs = {
    # You can add overlays here
    #overlays = [
    #  # Add overlays your own flake exports (from overlays and pkgs dir):
    #  inputs.self.overlays.additions
    #  inputs.self.overlays.modifications
    #  inputs.self.overlays.unstable-packages

    #  # You can also add overlays exported from other flakes:
    # # neovim-nightly-overlay.overlays.default

    #  # Or define it inline, for example:
    #  # (final: prev: {
    #  #   hi = final.hello.overrideAttrs (oldAttrs: {
    #  #     patches = [ ./change-hello-to-hi.patch ];
    #  #   });
    #  # })
    #];

    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "n3to";
    homeDirectory = "/home/n3to";
    pointerCursor = {
      name = "Bibata-Modern-Ice";
      size = 24;

      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  home.packages = with pkgs; [
    ghostty
    blueman
  ];
  home.sessionVariables = {
    DOOMDIR = "${config.home.homeDirectory}/.cfg/home-manager/features/doom";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    qutebrowser.enable = true;
    wofi.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
