{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprlock
  ];

  # Hyprlock reads ~/.config/hypr/hyprlock.conf by default
  xdg.configFile."hypr/hyprlock.conf".text = ''
    # Meloira / Base16-inspired palette
    # bg0: #141211
    # bg1: #1b1816
    # bg2: #24201e
    # border: #2a2522
    # fg0: #d6d0cd
    # fg1: #e1dbd9
    # accent: #98acc8
    # warn: #c4b392
    # err: #d49191
    # comment-ish: #E0D9E2

    general {
      disable_loading_bar = true
      grace = 2
      hide_cursor = true
    }

    background {
      monitor =
      # If you want wallpaper blur behind the lock, keep this
      blur_passes = 2
      blur_size = 6
      noise = 0.010
      contrast = 0.95
      brightness = 0.85
      vibrancy = 0.12
      vibrancy_darkness = 0.30

      color = rgba(20,18,17,0.96)
    }

    # Time
    label {
      monitor =
      text = $TIME
      font_size = 72
      font_family = JetBrainsMono Nerd Font
      color = rgb(d6d0cd)

      position = 0, 180
      halign = center
      valign = center
    }

    # Date
    label {
      monitor =
      text = cmd[update:1000] echo "$(date '+%A, %b %d')"
      font_size = 18
      font_family = JetBrainsMono Nerd Font
      color = rgb(E0D9E2)

      position = 0, 110
      halign = center
      valign = center
    }

    # Password input field
    input-field {
      monitor =
      size = 360, 56
      outline_thickness = 2
      dots_size = 0.22
      dots_spacing = 0.35
      dots_center = true
      fade_on_empty = true
      placeholder_text = <span foreground="##9e9793">Password</span>

      font_family = JetBrainsMono Nerd Font
      font_size = 16
      text_color = rgb(d6d0cd)

      inner_color = rgba(27,24,22,0.92)      # bg1
      outer_color = rgb(2a2522)              # border
      check_color = rgb(98acc8)              # accent (typo-proof: 98acc8)
      fail_color = rgb(d49191)               # error

      position = 0, 10
      halign = center
      valign = center
    }

    # Subtle hint line under the input
    label {
      monitor =
      text = cmd[update:1000] echo "Enter to unlock • Esc to cancel"
      font_size = 12
      font_family = JetBrainsMono Nerd Font
      color = rgb(9e9793)

      position = 0, -55
      halign = center
      valign = center
    }
  '';
}
