{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    # Core ergonomics
    keyMode = "vi";
    mouse = true;
    clock24 = true;

    baseIndex = 1;
    historyLimit = 200000;
    escapeTime = 0;
    aggressiveResize = true;
    focusEvents = true;

    # Force tmux to start zsh (not bash)
    shell = "${pkgs.zsh}/bin/zsh";

    # prefix = "C-a";
    # shortcut = "a";

    terminal = "xterm-256color";
    sensibleOnTop = true;

    extraConfig = ''
      # Force zsh as the command tmux launches in panes/windows
      set -g default-command "${pkgs.zsh}/bin/zsh -l"

      ##### Terminal / Truecolor #####
      set -g default-terminal "tmux-256color"
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-features ",tmux-256color:RGB"

      ##### Performance / UX #####
      set -g renumber-windows on
      set -g repeat-time 300
      set -g status-interval 2
      setw -g monitor-activity off
      set -g visual-activity off

      ##### Pane / window styling (meloira palette) #####
      # Meloira reference:
      # bg0: #1c1917  bg1: #24201e  bg2: #2a2522
      # fg0: #d6d0cd  fg1: #ddd9d6
      # red: #d49191  green: #b6b696  yellow: #c4b392
      # blue: #9e96b6 magenta: #b696b1 cyan: #98acc8

      # Pane borders
      set -g pane-border-style "fg=#2a2522"
      set -g pane-active-border-style "fg=#98acc8"

      # Messages (command prompt, confirmations)
      set -g message-style "bg=#24201e,fg=#ddd9d6"
      set -g message-command-style "bg=#24201e,fg=#c4b392"

      # Copy mode selection (vi mode)
      setw -g mode-style "bg=#2a2522,fg=#ddd9d6"

      ##### Status bar #####
      set -g status on
      set -g status-position bottom
      set -g status-justify centre
      set -g status-style "bg=#1c1917,fg=#d6d0cd"

      # Left: session name
      set -g status-left-length 40
      set -g status-left "#[bg=#24201e,fg=#98acc8,bold] #S #[bg=#1c1917] "

      # Right: battery-like info via builtins (host + time)
      set -g status-right-length 120
      set -g status-right "#[fg=#9e96b6]#H #[fg=#b696b1]| #[fg=#c4b392]%Y-%m-%d #[fg=#98acc8]%H:%M "

      # Windows list
      setw -g window-status-separator ""
      setw -g window-status-style "bg=#1c1917,fg=#9e96b6"
      setw -g window-status-format "#[bg=#1c1917,fg=#9e96b6] #I:#W "

      # Active window
      setw -g window-status-current-style "bg=#24201e,fg=#ddd9d6,bold"
      setw -g window-status-current-format "#[bg=#24201e,fg=#ddd9d6,bold] #I:#W "

      # Bell/alerts
      setw -g window-status-bell-style "bg=#1c1917,fg=#d49191,bold"

      ##### Keybinds (vi-friendly) #####
      # Split shortcuts
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux reloaded"

      # Vim-like pane navigation (works well with Neovim)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes with HJKL (repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Better copy-mode (y to copy like Vim)
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
    '';
  };
}
