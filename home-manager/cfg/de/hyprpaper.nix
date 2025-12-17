{
  config,
  pkgs,
  lib,
  ...
}: {
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2;

      # Absolute, Nix-safe path
      preload = [
        #"${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/everforest1.jpg"
        #"${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/japanese_pedestrian_street.png"
        "${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/dark_mountain.png"
      ];

      wallpaper = [
        #"DP-1,${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/everforest1.jpg"
        #"DP-1,${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/japanese_pedestrian_street.png"
        "DP-1,${config.home.homeDirectory}/.cfg/home-manager/cfg/de/wp/dark_mountain.png"
      ];
    };
  };
}
