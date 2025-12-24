{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    protonup-qt
    (pkgs.writeShellScriptBin "steam-dgpu" ''
      export DRI_PRIME=1

      # Prefer host libs over steam-runtime copies (fixes common fontconfig/libcef issues)
      export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1

      # Workaround for steamwebhelper/CEF crash loops on some setups
      exec ${pkgs.steam}/bin/steam -cef-disable-gpu "$@"
    '')
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
      dedicatedServer.openFirewall = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  #boot.kernelParams = ["quiet" "splash" "console=/dev/null"];
  #boot.plymouth.enable = true;

  services.upower.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
