{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./cfg
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "aurelius";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  security.pam.services.hyprlock = {};

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "Hyprland";
          user = "n3to";
        };
      };
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = "*";
      };
    };
  };

  system.name = "aurelius";
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.n3to = {
    isNormalUser = true;
    description = "JohnCarterGonzalez";
    extraGroups = ["networkmanager" "wheel" "tty" "sound" "audio" "docker"];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # SYSTEM-WIDE DEV TOOLING
  environment = {
    systemPackages = with pkgs; [
      wget
      neovim

      # FORMATTER + LINT
      alejandra
      statix
      deadnix

      # LSP SERVERS
      nixd
      rust-analyzer

      # RUST TOOLING
      rustfmt

      tree
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    hyprland.enable = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
