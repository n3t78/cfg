{
  pkgs,
  lib,
  ...
}: {
  programs.discord = {
    # disable for DiscoCSS
    #enable = true;
    package = pkgs.discord;

    # Optional: usually recommended on NixOS
    settings = {
      SKIP_HOST_UPDATE = true;
      # Only enable if you specifically want devtools inside Discord:
      # DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
    };
  };

  programs.discocss = {
    enable = true;

    # If the HM module supports these, set them explicitly:
    discordAlias = true;
    discordPackage = pkgs.discord;

    # If your HM module exposes a settings JSON submodule, you can keep it empty:
    # settings = { };
  };

  # Your theme CSS goes here:
  xdg.configFile."discocss/custom.css".text = ''
    /* Meloira/Base16 theme for Discord (DiscoCSS)
       bg0: #141211
       bg1: #1b1816
       bg2: #24201e
       border: #2a2522
       fg0: #d6d0cd
       fg1: #e1dbd9
       muted: #9e9793
       accent: #98acc8
       warn: #c4b392
       err:  #d49191
       comment-ish: #E0D9E2
    */

    .theme-dark {
      --background-primary: #141211;
      --background-secondary: #1b1816;
      --background-tertiary: #24201e;
      --background-secondary-alt: #1b1816;
      --background-floating: #1b1816;

      --channeltextarea-background: #1b1816;

      --text-normal: #d6d0cd;
      --text-muted: #9e9793;
      --header-primary: #e1dbd9;
      --header-secondary: #d6d0cd;

      --interactive-normal: #d6d0cd;
      --interactive-muted: #9e9793;
      --interactive-hover: #e1dbd9;
      --interactive-active: #e1dbd9;

      --accent-color: #98acc8;
      --brand-experiment: #98acc8;
      --brand-experiment-560: #98acc8;

      --status-danger: #d49191;
      --status-warning: #c4b392;

      --scrollbar-auto-thumb: #2a2522;
      --scrollbar-auto-track: #141211;
      --scrollbar-thin-thumb: #2a2522;
      --scrollbar-thin-track: transparent;

      --focus-primary: #98acc8;
    }

    /* Optional: unify borders/outline feel */
    :root {
      --background-modifier-hover: rgba(42, 37, 34, 0.55);
      --background-modifier-active: rgba(42, 37, 34, 0.75);
      --background-modifier-selected: rgba(36, 32, 30, 0.95);
      --background-modifier-accent: rgba(42, 37, 34, 0.65);
    }

    /* Make code blocks and inline code fit */
    code, pre {
      background: #24201e !important;
      border: 1px solid #2a2522 !important;
      color: #e1dbd9 !important;
    }

    /* If you want “comment”/secondary text brighter in certain areas */
    .markup_a7e664, .timestamp_c79dd2, .topic__6ec1a {
      color: #E0D9E2 !important;
    }
  '';

  # OPTIONAL: automatically run discocss after login.
  # This is often the missing piece—discocss must be executed to inject.
  systemd.user.services.discocss = {
    Unit = {
      Description = "DiscoCSS injector for Discord";
      After = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.discocss}/bin/discocss";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
