{pkgs, ...}: {
  programs.alacritty = {
    enable = true;

    # Keep your Everforest theme
    theme = "meliora";

    settings = {
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["--login"];
      };
      window = {
        opacity = 0.9;
      };

      # ✅ FIX: Proper Nerd Font setup for icons
      font = {
        size = 12.0;

        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };

        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };

        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };

        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };
}
