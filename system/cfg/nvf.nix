{
  pkgs,
  lib,
  ...
}: let
  gruvySrc = pkgs.fetchFromGitHub {
    owner = "RishabhRD";
    repo = "gruvy";
    rev = "master"; # Prefer pinning a commit later
    hash = "sha256-4QHxSSzLB7wJOIYhpmr+Lykv2C1bDh95uSC866O55gk=";
  };

  gruvy = pkgs.vimUtils.buildVimPlugin {
    pname = "gruvy";
    version = "git";
    src = gruvySrc;

    dependencies = [pkgs.vimPlugins.lush-nvim];
    postPatch = ''
      # Fix invalid blend types: Lush/Neovim expects a number, not a string
      substituteInPlace lua/lush_theme/gruvy.lua \
        --replace 'blend="80"'  'blend=80' \
        --replace 'blend="100"' 'blend=100'
    '';
  };
in {
  programs.nvf = {
    enable = true;

    settings.vim = {
      ####################################################
      ### GLOBALS / LEADER
      ####################################################
      globals = {
        mapleader = " ";
        maplocalleader = ",";
        editorconfig = true;
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
      };

      startPlugins = with pkgs; [
        vimPlugins.lush-nvim
        gruvy
        "friendly-snippets"
      ];

      ####################################################
      ### THEME
      ####################################################
      theme = {
        enable = false;
      };

      luaConfigRC.gruvyTheme = ''
        vim.o.termguicolors = true
        vim.cmd.colorscheme("gruvy")

        -- Force black background
        vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "#000000" })
      '';

      ####################################################
      ### TREESITTER (GLOBAL)
      ####################################################
      treesitter.enable = true;

      ####################################################
      ### GLOBAL DIAGNOSTICS
      ####################################################
      diagnostics = {
        enable = true;
        config = {
          underline = true;
          update_in_insert = false;
          virtual_text = true;
          signs = true;
        };
      };

      ####################################################
      ### WHICH-KEY
      ####################################################
      binds.whichKey = {
        enable = true;
        setupOpts = {
          notify = true;
          preset = "modern";
          win.border = "rounded";
        };
      };

      ui.borders.plugins.which-key = {
        enable = true;
        style = "rounded";
      };

      ####################################################
      ### KEYMAPS
      ####################################################
      keymaps = [
        # Yank to system clipboard
        {
          mode = "v";
          key = "<leader>y";
          action = ''"+y'';
          desc = "Yank to clipboard";
        }
        {
          mode = "n";
          key = "<leader>Y";
          action = ''"+yy'';
          desc = "Yank line to clipboard";
        }

        # Paste from system clipboard
        {
          mode = "n";
          key = "<leader>p";
          action = ''"+p'';
          desc = "Paste from clipboard";
        }
        {
          mode = "v";
          key = "<leader>p";
          action = ''"+p'';
          desc = "Paste from clipboard";
        }
      ];

      ####################################################
      ### LANGUAGE SUPPORT
      ####################################################
      languages = {
        enableTreesitter = true;

        nix = {
          enable = true;
          treesitter.enable = true;

          format = {
            enable = true;
            type = ["alejandra"];
          };

          lsp = {
            enable = true;
            servers = ["nixd"];
          };

          extraDiagnostics.enable = true;
          # extraDiagnostics.types = [ "statix" "deadnix" ];
        };

        rust = {
          enable = true;
          treesitter.enable = true;

          lsp = {
            enable = true;
            opts = ''
              ['rust-analyzer'] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                check = { command = "clippy" },
                procMacro = { enable = true },
              }
            '';
          };

          format = {
            enable = true;
            type = ["rustfmt"];
          };

          extensions.crates-nvim = {
            enable = true;
            setupOpts = {
              lsp = {
                enabled = true;
                completion = true;
                hover = true;
                actions = true;
              };

              completion.crates = {
                enabled = true;
                min_chars = 3;
                max_results = 8;
              };
            };
          };

          dap.enable = false;
        };

        python = {
          enable = true;
          treesitter.enable = true;

          format = {
            enable = true;
            type = ["black"];
          };

          lsp = {
            enable = true;
            servers = ["pyright"];
          };

          dap.enable = false;
        };
      };

      ####################################################
      ### LSP UX / FORMATTING
      ####################################################
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;

        mappings = {
          format = "<leader>lf";
          codeAction = "<leader>la";
          renameSymbol = "<leader>ln";
          hover = "<leader>lh";
        };
      };

      ####################################################
      ### CONFORM.NVIM (formatter)
      ####################################################
      formatter.conform-nvim = {
        enable = true;

        setupOpts = {
          # IMPORTANT: formatters_by_ft is NOT nested under formatters
          formatters_by_ft = {
            nix = ["alejandra"];
            python = ["black"];
            rust = ["rustfmt"];
          };

          # Custom formatter definitions / overrides
          formatters = {
            alejandra = {
              command = lib.getExe pkgs.alejandra;
            };

            black = {
              command = lib.getExe pkgs.black;
            };

            # If pkgs.rustfmt is not available on your channel, set command = "rustfmt";
            rustfmt = {
              command = lib.getExe pkgs.rustfmt;
            };
          };
        };
      };

      ####################################################
      ### SNIPPETS
      ####################################################
      snippets.luasnip.enable = true;

      ####################################################
      ### COMPLETION — blink.cmp
      ####################################################
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;

        mappings = {
          complete = "<C-Space>";
          confirm = "<CR>";
          close = "<C-e>";
          next = "<C-n>";
          previous = "<C-p>";
          scrollDocsUp = "<C-b>";
          scrollDocsDown = "<C-f>";
        };

        setupOpts = {
          sources.default = ["lsp" "path" "snippets" "buffer"];

          completion = {
            menu.auto_show = true;
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };

          fuzzy = {
            implementation = "prefer_rust";
            prebuilt_binaries.download = false;
          };

          keymap = {
            preset = "none";

            "<C-Space>" = ["show" "fallback"];
            "<CR>" = ["accept" "fallback"];
            "<C-e>" = ["hide" "fallback"];

            "<C-n>" = ["select_next" "fallback"];
            "<C-p>" = ["select_prev" "fallback"];

            "<C-b>" = ["scroll_documentation_up" "fallback"];
            "<C-f>" = ["scroll_documentation_down" "fallback"];
          };

          cmdline = {
            keymap.preset = "none";
            sources = null;
          };
        };

        sourcePlugins = {
          emoji.enable = false;
          ripgrep.enable = false;
          spell.enable = false;
        };
      };

      ####################################################
      ### STATUSLINE
      ####################################################
      mini.statusline = {
        enable = true;
        setupOpts.use_icons = true;
      };

      ####################################################
      ### TELESCOPE / SEARCH
      ####################################################
      telescope.enable = true;

      ####################################################
      ### AUTOPAIRS
      ####################################################
      autopairs.nvim-autopairs.enable = true;

      ####################################################
      ### FILE EXPLORER — OIL
      ####################################################
      utility.oil-nvim.enable = true;

      ####################################################
      ### GIT SUITE
      ####################################################
      git = {
        enable = true;
        gitsigns.enable = true;
        neogit.enable = true;
        git-conflict.enable = true;
        vim-fugitive.enable = true;
        gitlinker-nvim.enable = true;
      };

      terminal.toggleterm.lazygit.enable = true;

      ####################################################
      ### RUNNER
      ####################################################
      runner.run-nvim.mappings = {
        run = "<leader>rr";
        runCommand = "<leader>rc";
        runOverride = "<leader>ro";
      };

      ####################################################
      ### UI
      ####################################################
      ui = {};
    };
  };
}
