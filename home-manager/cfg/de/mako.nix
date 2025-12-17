{pkgs, ...}: {
  services.mako = {
    enable = true;

    # New schema: put mako config under `settings`
    settings = {
      # Appearance (meloira-ish)
      background-color = "#1c1917";
      text-color = "#d6d0cd";
      border-color = "#2a2522";
      progress-color = "over #98acc8";

      border-size = 2;
      border-radius = 10;
      padding = "10,15";
      margin = "10";
      font = "JetBrainsMono Nerd Font 11";

      # Timing / behavior
      default-timeout = 5000;
      ignore-timeout = true;

      # Placement
      anchor = "top-right";
      layer = "overlay";

      # Ordering / limits
      max-visible = 5;
      sort = "-time";
    };
  };

  home.packages = with pkgs; [
    mako
    libnotify
  ];
}
