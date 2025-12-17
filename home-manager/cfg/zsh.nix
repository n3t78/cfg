{
  pkgs,
  lib,
  ...
}: {
  ############################
  # ZSH CONFIG
  ############################
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";

    history = {
      path = "$HOME/.zsh_history";
      size = 10000;
      save = 10000;
      share = true;
      extended = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
    };

    syntaxHighlighting.enable = true;

    shellAliases = {
      nr = "sudo nixos-rebuild switch --flake ~/.cfg#aurelius";
      nt = "sudo nixos-rebuild test   --flake ~/.cfg#aurelius";
      nb = "sudo nixos-rebuild build  --flake ~/.cfg#aurelius";
      nd = "nix develop -c zsh";

      hmb = "home-manager build  --flake ~/.cfg#n3to@aurelius";
      hms = "home-manager switch --flake ~/.cfg#n3to@aurelius";

      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --git";
      la = "eza -a --icons";
      cat = "bat";
      grep = "rg";
      v = "nvim";
    };

    setOptions = [
      "AUTO_CD"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "SHARE_HISTORY"
      "INC_APPEND_HISTORY"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "alacritty";
    };

    initContent = lib.mkOrder 500 ''
      zmodload zsh/zle
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
    '';
  };

  ############################
  # STARSHIP PROMPT ✅ (FIXED)
  ############################
  programs = {
    ############################
    # TOOL INTEGRATIONS ✅
    ############################
    direnv.enableZshIntegration = true;
    fzf.enableZshIntegration = true;
    zoxide.enableZshIntegration = true;
    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        add_newline = false;

        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$character"
        ];

        ############################
        # DIRECTORY
        ############################
        directory = {
          style = "blue";
        };

        ############################
        # CHARACTER
        ############################
        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        ############################
        # GIT
        ############################
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "([($ahead_behind$stashed)]($style))";
          style = "cyan";

          conflicted = "!";
          untracked = "?";
          modified = "M";
          staged = "S";
          renamed = "R";
          deleted = "D";
          stashed = "≡";
        };

        git_state = {
          format = "(\\[$state( $progress_current/$progress_total)\\]) ";
          style = "bright-black";
        };

        ############################
        # CMD DURATION
        ############################
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        ############################
        # PYTHON (PURE STYLE)
        ############################
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
          detect_extensions = [];
          detect_files = [];
        };

        ############################
        # HOSTNAME (ALWAYS SHOWN)
        ############################
        hostname = {
          ssh_only = false;
          style = "bright-green bold";
        };
      };
    };
  };

  ############################
  # REQUIRED TOOLS ✅
  ############################
  home.packages = with pkgs; [
    starship
    eza
    bat
    ripgrep
    zoxide
    fzf
  ];
}
