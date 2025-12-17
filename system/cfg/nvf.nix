{
  pkgs,
  lib,
  ...
}: {
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

      ####################################################
      ### THEME
      ####################################################
      theme = {
        enable = true;
        name = "base16";
        transparent = false;

        base16-colors = {
          # Core background ramp (darker + more muted)
          base00 = "#141211";
          base01 = "#1b1816";
          base02 = "#24201e";
          base03 = "#3a3532";

          # Foreground ramp
          base04 = "#9e9793";
          base05 = "#d6d0cd";
          base06 = "#e1dbd9";
          base07 = "#f0ebe8";

          # Semantic colors
          base08 = "#d49191";
          base09 = "#c4b392";
          base0A = "#c8b692";
          base0B = "#b6b696";
          base0C = "#98acc8";
          base0D = "#9e96b6";
          base0E = "#b696b1";
          base0F = "#e3d5ce";
        };

        extraConfig = ''
          -- Defer highlight overrides until colorscheme + treesitter are applied
          vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "Comment", { fg = "#E0D9E2", italic = true })
            vim.api.nvim_set_hl(0, "@comment", { fg = "#E0D9E2", italic = true })
          end, 0)
        '';
      };

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

      startPlugins = [
        "friendly-snippets"
      ];

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
