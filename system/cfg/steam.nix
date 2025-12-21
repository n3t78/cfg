{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonup-qt
    (pkgs.writeShellScriptBin "steam-dgpu" ''
      export DRI_PRIME=1
      exec ${pkgs.steam}/bin/steam "$@"
    '')
    mangohud
  ];
  hardware = {
    steam-hardware.enable = true;
    graphics = {
      ## radv: an open-source Vulkan driver from freedesktop
      enable32Bit = true;
    };

    system76.enableAll = true;
  };

  services.xserver.videoDrivers = ["amdgpu"];

  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      #package = pkgs.steam.override {
      #  extraPkgs = pkgs':
      #    with pkgs'; [
      #      xorg.libXcursor
      #      xorg.libXi
      #      xorg.libXinerama
      #      xorg.libXScrnSaver
      #      libpng
      #      libpulseaudio
      #      libvorbis
      #      stdenv.cc.cc.lib # Provides libstdc++.so.6
      #      libkrb5
      #      keyutils
      #      # Add other libraries as needed
      #    ];
      #};
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  #boot.kernelParams = ["quiet" "splash" "console=/dev/null"];
  #boot.plymouth.enable = true;

  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
