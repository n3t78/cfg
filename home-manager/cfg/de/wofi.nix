{pkgs, ...}: {
  programs.wofi = {
    enable = true;
    package = pkgs.wofi;

    # wofi(5) settings (non-visual behavior)
    settings = {
      show = "drun";
      prompt = "Run";
      width = 520;
      height = 340;
      location = "center";
      allow_images = true;
      image_size = 22;
      insensitive = true;
      no_actions = true;
      term = "alacritty";
      gtk_dark = true;
    };

    # CSS styling (visuals)
    style = ''
      /* Meloira palette reference
         bg0: #141211 / #1c1917
         bg1: #1b1816 / #24201e
         bg2: #24201e / #2a2522
         fg0: #d6d0cd
         fg1: #e1dbd9
         accent: #98acc8 (cyan)
         warn: #c4b392
         err:  #d49191
         comment-ish: #E0D9E2
      */

      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: 2px solid #2a2522;
        border-radius: 12px;
        background-color: #141211;
      }

      #outer-box {
        padding: 14px;
        background-color: transparent;
      }

      #input {
        padding: 10px 12px;
        margin-bottom: 12px;
        border-radius: 10px;
        border: 1px solid #2a2522;
        background-color: #1b1816;
        color: #d6d0cd;
      }

      #input:focus {
        border: 1px solid #98acc8;
        box-shadow: 0 0 0 2px rgba(152, 172, 200, 0.18);
      }

      #inner-box {
        margin: 0px;
        padding: 0px;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        padding: 0px;
      }

      #entry {
        padding: 10px 10px;
        margin: 4px 0px;
        border-radius: 10px;
        background-color: transparent;
        color: #d6d0cd;
      }

      #entry image {
        margin-right: 10px;
      }

      #entry #text {
        color: #d6d0cd;
      }

      #entry:selected {
        background-color: #24201e;
        border: 1px solid #2a2522;
      }

      #entry:selected #text {
        color: #e1dbd9;
      }

      /* Optional: subtle “secondary” text tone */
      #entry #text:first-child {
        color: #d6d0cd;
      }

      /* If you use matching mode labels */
      #mode {
        margin: 0px 0px 10px 0px;
        color: #E0D9E2;
      }

      #prompt {
        color: #98acc8;
      }

      #message {
        color: #c4b392;
      }
    '';
  };
}
