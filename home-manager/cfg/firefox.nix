{pkgs, ...}: {
  programs.firefox = {
    enable = false;

    profiles.n3to = {
      id = 0;
      name = "n3to";
      isDefault = true;

      # ✅ REQUIRED for userChrome.css to work
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Wayland / Hyprland stability
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.wayland.hardware-video-decoding.enabled" = true;

        # UI polish
        "browser.tabs.drawInTitlebar" = false;
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;

        # Dark mode everywhere
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0;
      };

      # ✅ EVERFOREST-BASE UI via UserChrome
      userChrome = ''
        @-moz-document url(chrome://browser/content/browser.xhtml) {

          /* ✅ Tabs on bottom */
          #main-window body { flex-direction: column-reverse !important; }
          #navigator-toolbox { flex-direction: column-reverse !important; }

          #urlbar-searchmode-switcher { position: static !important; }

          #urlbar {
            top: unset !important;
            bottom: calc(var(--urlbar-container-height) + 2 * var(--urlbar-padding-block)) !important;
            box-shadow: none !important;
            display: flex !important;
            flex-direction: column !important;
          }

          #urlbar > * { flex: none; }

          #urlbar .urlbar-input-container { order: 2; }

          #urlbar > .urlbarView {
            order: 1;
            border-bottom: 1px solid #666;
          }

          #urlbar-results {
            display: flex;
            flex-direction: column-reverse;
          }

          .search-one-offs { display: none !important; }
          .tab-background { border-top: none !important; }
          #navigator-toolbox::after { border: none; }

          #TabsToolbar .tabbrowser-arrowscrollbox,
          #tabbrowser-tabs, .tab-stack {
            min-height: 28px !important;
          }

          .tabbrowser-tab { font-size: 80%; }
          .tab-content { padding: 0 5px; }

          .tab-close-button .toolbarbutton-icon {
            width: 12px !important;
            height: 12px !important;
          }

          toolbox[inFullscreen=true] { display: none; }

          /* ✅ Popup alignment fixes */
          #mainPopupSet panel.panel-no-padding {
            margin-top: calc(-50vh + 40px) !important;
          }

          #mainPopupSet .panel-viewstack,
          #mainPopupSet popupnotification {
            max-height: 50vh !important;
            height: 50vh;
          }

          #mainPopupSet panel.panel-no-padding.popup-notification-panel {
            margin-top: calc(-50vh - 35px) !important;
          }

          #navigator-toolbox .panel-viewstack {
            max-height: 75vh !important;
          }

          panelview.cui-widget-panelview { flex: 1; }
          panelview.cui-widget-panelview > vbox {
            flex: 1;
            min-height: 50vh;
          }
        }
      '';

      # ✅ FIREFOX CONTAINERS
      containersForce = true;

      containers = {
        personal = {
          id = 1;
          name = "Personal";
          color = "blue";
          icon = "fingerprint";
        };

        work = {
          id = 2;
          name = "Work";
          color = "turquoise";
          icon = "briefcase";
        };

        banking = {
          id = 3;
          name = "Banking";
          color = "red";
          icon = "dollar";
        };

        shopping = {
          id = 4;
          name = "Shopping";
          color = "orange";
          icon = "cart";
        };
      };
    };
  };
}
