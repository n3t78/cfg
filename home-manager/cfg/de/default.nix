{...}: {
  imports = [
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./waybar.nix
    ./mako.nix
    ./wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    settings = {
      #############################
      ### AUTOSTART (SAFE)
      #############################
      exec-once = [
        "systemctl --user enable --now hyprpaper.service"
        "systemctl --user start hyprpolkitagent"
        "hypridle"
        "udiskie"
        "mako"
      ];

      env = [
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
      ];

      #############################
      ### MONITOR
      #############################
      monitor = "eDP-1,1920x1200@60,0x0,1";

      #############################
      ### VARIABLES
      #############################
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      "$mainMod" = "SUPER";

      #############################
      ### GENERAL
      #############################
      general = {
        layout = "dwindle";
        gaps_in = 10;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = true;
        allow_tearing = false;
      };

      #############################
      ### DECORATION
      #############################
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.95;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(26,26,26,0.9)";
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 1;
          vibrancy = 0.18;
        };
      };

      #############################
      ### ANIMATIONS
      #############################
      animations = {
        enabled = true;

        animation = [
          "windows,1,5,default"
          "border,1,5,default"
          "workspaces,1,4,default"
        ];
      };

      #############################
      ### INPUT
      #############################
      input = {
        kb_layout = "us";
        follow_mouse = true;
        sensitivity = 0.0;
      };

      #############################
      ### GROUPS
      #############################
      group = {
        auto_group = true;
        drag_into_group = true;
        merge_groups_on_drag = true;
      };

      #############################
      ### KEYBINDS
      #############################
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating"
        "$mainMod, R, exec, $menu"
        "$mainMod, X, exec, hyprlock"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Notifications
        "$mainMod, N, exec, makoctl dismiss"
        "$mainMod SHIFT, N, exec, makoctl dismiss --all"
        "$mainMod CTRL, N, exec, makoctl set-mode do-not-disturb"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      #############################
      ### WINDOW RULES
      #############################
      windowrule = [
        "float, class:(clipse)"
        "opacity 1.0 override 1.0 override,title:(.*YouTube.*)"
        "suppressevent maximize, class:.*"
      ];

      #############################
      ### MISC
      #############################
      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = -1;
        vrr = 2;
      };

      #############################
      ### XWAYLAND
      #############################
      xwayland = {
        enabled = true;
      };
    };
  };
}
