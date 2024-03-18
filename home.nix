{ config, pkgs, inputs,  ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nikola";
  home.homeDirectory = "/home/nikola";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  programs.bash.enable = true;
  programs.bash.bashrcExtra = "eval \"\$(direnv hook bash)\"";

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
  
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    colors = {
      primary = {
        background = "0x1d1f21";
        foreground = "0xc5c8c6";
      };
      normal = {
        black = "0x1d1f21";
        red = "0xcc6666";
        green = "0xb5bd68";
        yellow = "0xe6c547";
        blue = "0x81a2be";
        magenta = "0xb294bb";
        cyan = "0x70c0ba";
        white = "0x373b41";
      };
      bright = {
        black = "0x666666";
        red = "0xff3334";
        green = "0x9ec400";
        yellow = "0xf0c674";
        blue = "0x81a2be";
        magenta = "0xb77ee0";
        cyan = "0x54ced6";
        white = "0x282a2e";
      };
    };
    font.size = 8.0;
    window = {
      opacity = 0.85;
    };
  };

  services.polybar.enable = true;
  services.polybar.package = pkgs.polybar.override { pulseSupport = true; };
  services.polybar.script = "polybar top &";
  services.polybar.settings = {
    "colors" = {
      background = "#D924292e";
      background-alt = "#373B41";
      foreground = "#C5C8C6";
      primary = "#81a2be";
      Secondary = "#8ABEB7";
      alert = "#A54242";
      disabled = "#707880";
    };

    "bar/top" = {
      width = "100%";
      height = "20pt";

      background = "\${colors.background}";
      foreground = "\${colors.foreground}";

      line.size = "3pt";

      padding.left = 0;
      padding.right = 1;

      module.margin = 1;

      radius = 5;
      border.size = 5;

      separator = "|";
      separator-foreground = "\${colors.disabled}";

      font = [
        "Noto Sans Mono:style=Regular"
        "Noto Sans Mono CJK JP:style=Regular"
      ];

      modules.left = "xworkspaces xwindow";
      modules.right = "battery pulseaudio xkeyboard network cpu tray date";

      cursor.click = "pointer";
      cursor.scroll = "ns-resize";

      enable-ipc = true;
    };

    "module/systray" = {
      type = "internal/tray";
    };

    "module/network" = {
      type = "internal/network";

      interface = "wlp4s0";
      interface-type = "wireless";
      label.connected.text = "%essid% %local_ip%";
    };

    "module/xworkspaces" = {
      type = "internal/xworkspaces";

      label.active.text = "%name%";
      label.active.background = "\${colors.background-alt}";
      label.active.underline = "\${colors.primary}";
      label.active.padding = 1;

      label.occupied.text = "%name%";
      label.occupied.padding = 1;

      label.urgent.text = "%name%";
      label.urgent.background = "\${colors.alert}";
      label.urgent.padding = 1;

      label.empty.text = "%name%";
      label.empty.foreground = "\${colors.disabled}";
      label.empty.padding = 1;
    };

    "module/xwindow" = {
      type = "internal/xwindow";
      label = "%title:0:60:...%";
    };

    "module/pulseaudio" = {
      type = "internal/pulseaudio";

      format.volume.prefix.text = "VOL ";
      format.volume.prefix.foreground = "\${colors.primary}";
      format.volume.text = "<label-volume>";

      label.volume = "%percentage%%";

      label.muted.text = "muted";
      label.muted.foreground = "\${colors.disabled}";
    };

    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format.prefix.text = "RAM ";
      format.prefix.foreground = "\${colors.primary}";
      label = "%percentage_used:2%%";
    };

    "module/cpu" = {
      type = "internal/cpu";
      interval = 2;
      format.prefix.text = "CPU ";
      format.prefix.foreground = "\${colors.primary}";
      label = "%percentage:2%%";
    };

    "module/date" = {
      type = "internal/date";
      interval = 1;

      date.text = "%H:%M";
      date.alt = "%Y-%m-%d %H:%M:%S";

      label.text = "%date%";
      label.foreground = "\${colors.primary}";
    };

    "module/tray" = {
      type = "internal/tray";

      format-margin = "8px";
      tray-spacing = "8px";
    };

    "module/xkeyboard" = {
      type = "internal/xkeyboard";
      blacklist = [ "num lock" ];

      label.layout.text = "%layout%";
      label.layout.foreground = "\${colors.primary}";

      label.indicator.padding = 2;
      label.indicator.margin = 1;
      label.indicator.foreground = "\${colors.background}";
      label.indicator.background = "\${colors.secondary}";
    };

    "module/battery" = {
      type = "internal/battery";

      full.at = 99;

      low.at = 20;

      battery = "BAT1";
      adapter = "ACAD";

      label.charging = "Charging %percentage%%";
      label.discharging = "Discharging %percentage%% %time% %consumption%";
      label.full = "Fully charged";
      label.low = "BATTERY LOW";
    };
  };

  services.picom = {
    enable = true;
  };

  services.syncthing = { enable = true; };
  services.lorri = {
    enable = true;
  };

  # Tweak for 23.05, hopefully will be fixed in unstable
  systemd.user.services.lorri.serviceConfig = {
    ProtectSystem = pkgs.lib.mkForce "full";
    ProtectHome = pkgs.lib.mkForce false;
  };

  programs.rofi.enable = true;
  programs.rofi.theme = "Arc-Dark";
  programs.rofi.font = "Noto Sans Mono 12";
  programs.rofi.terminal = "alacritty";

  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";
  xsession.windowManager.bspwm = {
    enable = true;
    monitors = { eDP-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" ]; };
    settings = {
      window_gap = 5;
    };
  };

  programs.git = {
    enable = true;
    # Enable send-email
    package = pkgs.gitAndTools.gitFull;

    userEmail = "nikolabrk@protonmail.com";
    userName = "nikolabr";
  };


  accounts.email.accounts = {
    "nb91605" = {
      primary = true;
      userName = "nb91605@student.uni-lj.si";
      address = "nb91605@student.uni-lj.si";
      realName = "Nikola Brković";
      flavor = "outlook.office365.com";
      mu.enable = true;
      thunderbird = {
        enable = true;
      };
      offlineimap = {
        enable = true;
        extraConfig.remote = {
          auth_mechanisms = "XOAUTH2";
          # Thunderbird ID
          oauth2_client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
          
          oauth2_access_token = "";
        };
      };
      imap = {
        host = "outlook.office365.com";
      };
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles = {
      "default" = {
        isDefault = true;
      };
    };
  };

  programs.mu = {
    enable = true;
  };

  programs.offlineimap = {
    enable = true;
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      # General
      "super + Return" = "alacritty";
      "super + @space" = "rofi -show run";
      "super + v" = "firefox";
      "super + d" = "rofi -show drun";
      "super + Escape" = "pkill -USR1 -x sxhkd";

      # Lock
      "super + ctrl + s" = "systemctl suspend";
      "super + alt + s" = "loginctl lock-session";

      # Volume 
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";

      # Screenshots
      "Print" = "maim ~/Pictures/$(date +%s).png";
      "shift + Print" = "maim -s ~/Pictures/$(date +%s).png";
      "control + Print" = "maim | xclip -selection clipboard -t image/png";
      "shift + control + Print" =
        " maim -s | xclip -selection clipboard -t image/png";

      # Brightness
      "XF86MonBrightnessDown" = "brightnessctl s 10%-";
      "XF86MonBrightnessUp" = "brightnessctl s +10%";

      # BSPWM keybinds

      # quit/restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";

      # close and kill
      "super + {_,shift + }w" = "bspc node -{c,k}";

      # alternate between the tiled and monocle layout
      "super + m" = "bspc desktop -l next";

      # send the newest marked node to the newest preselected node
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";

      # swap the current node and the biggest window
      "super + g" = "bspc node -s biggest.window";

      # set the window state
      "super + {t,shift + t,s,f}" =
        "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

      # set the node flags
      "super + ctrl + {m,x,y,z}" =
        "bspc node -g {marked,locked,sticky,private}";

      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" =
        "bspc node -{f,s} {west,south,north,east}";

      # focus the node for the given path jump
      "super + {p,b,comma,period}" =
        "bspc node -f @{parent,brother,first,second}";

      # focus the next/previous window in the current desktop
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local.!hidden.window";

      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";

      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";

      # focus the older or newer node in the focus history
      "super + {o,i}" =
        "bspc wm -h off; bspc node {older,newer} -f; bspc wm -h on";

      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";

      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";

      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" =
        "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" =
        "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" =
        "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

    };
  };

  fonts.fontconfig.enable = true;

  xdg.mimeApps = let
    firefoxAssociations = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];

      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
    };
  in {
    enable = true;
    associations.added = firefoxAssociations;

    # Merge the firefox associations and custom ones
    defaultApplications = pkgs.lib.attrsets.mergeAttrsList [
      {
        "application/pdf" = [ "emacsclient.desktop" ];
        "text/html" = [ "firefox.desktop" ];
      }
      firefoxAssociations
    ];
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    client.enable = true;

    package = inputs.self.packages.x86_64-linux.custom-emacs;
  };

  home.file.".emacs".source = ./init.el;
  
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    direnv

    # Graphical browsers / Clients
    firefox-esr

    # Graphical utils
    pavucontrol
    neofetch
    anki
    gucharmap
    sxiv
    ghidra-bin
    gimp
    komikku
    audacity

    # Terminal utils
    maim
    p7zip
    zip
    aria2
    time
    unzip
    flashrom
    tree

    clang-tools

    # PDF/Office
    libreoffice
    ghostscript
    poppler_utils

    # Dicts
    # Slovenian
    (aspellWithDicts (d: [ d.en d.sl ]))

    # Xorg
    xclip
    xorg.xinput
    xorg.xev

    # Fonts
    source-code-pro
    font-awesome
    noto-fonts
    noto-fonts-cjk
    hanazono

    # Dev
    nixfmt
    stm32cubemx
    stlink-gui
    bear

    # Tex
    texlive.combined.scheme-full

    powershell

    # Octave
    octaveFull

    jetbrains.clion

    # Rust
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
      targets = [
        "thumbv6m-none-eabi"
        "thumbv7m-none-eabi"
        "thumbv7em-none-eabi"
        "thumbv7em-none-eabihf"
      ];
    })
    cargo-generate

    # Python
    (python3.withPackages(ps:
      with python311Packages; [
        pylatexenc
        python-lsp-server
        flake8
        jedi
        jinja2
        numpy
        scipy
      ]
    ))
    nodePackages_latest.pyright

    # Lisp
    sbcl
    lispPackages.cl-ppcre

    # Racket
    racket

    # Clojure
    clojure
    clojure-lsp
    leiningen

    # Elm
    elmPackages.elm
    elmPackages.elm-language-server

    # Embedded
    gcc-arm-embedded
    qemu_full
    
    jflap

    usbutils

    simplescreenrecorder

    (rstudioWrapper.override{
      packages = with rPackages; [
        readxl
        dplyr
        ggplot2
        treemapify
      ];
    })
    
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nikola/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    GTK_THEME = "Adwaita:dark";
    BROWSER = "firefox";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
