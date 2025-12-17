{pkgs, ...}: {
  programs.git = {
    enable = true;

    # Use gitFull if you want full feature set (send-email, etc.)
    package = pkgs.gitFull;

    # Global git config (~/.config/git/config)
    settings = {
      init.defaultBranch = "main";

      # Global identity (fixes “Author identity unknown”)
      user = {
        name = "n3to";
        email = "johncartergonzalez0@gmail.com";
      };

      core = {
        editor = "nvim";
        autocrlf = "input";
      };

      pull = {
        rebase = true;
      };

      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      fetch = {
        prune = true;
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      rerere = {
        enabled = true;
      };

      advice = {
        defaultBranchName = false;
      };

      aliases = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        lg = "log --oneline --decorate --graph --all";
      };
    };

    # Global ignore patterns
    ignores = [
      ".direnv/"
      "result"
      "*.swp"
      "*.tmp"
      ".DS_Store"
    ];

    # Helpful aliases
  };

  # Optional: nice TUI git client
  programs.lazygit.enable = true;

  # Optional: GitHub CLI + credential helper (recommended for HTTPS auth)
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper = {
      enable = true;
      hosts = ["github.com" "gist.github.com"];
    };
  };
}
