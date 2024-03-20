# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable sleep
  boot.kernelParams = [
    "amd_iommu=off"
  ];

  services.fwupd.enable = true;

  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        CPU_BOOST_ON_BAT = 0;

        SOUND_POWER_SAVE_ON_AT = 1;

        STOP_CHARGE_THRESH_BAT0 = 0;

        RADEON_DRM_PERF_LEVEL_ON_BAT = "low";
        RADEON_DPM_STATE_ON_BAT = "battery";

        PLATFORM_PROFILE_ON_BAT = "low-power";

        NMI_WATCHDOG = 0;
      };
  };
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.luks.devices = {
    VolGroup-root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
      allowDiscards = true;
    };
  };

  fileSystems."/home/nikola".device = "/dev/VolGroup-root/crypthome";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.slock.enable = true;
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };


  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"

    # STLink V3SET in Dual CDC mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"

    # STLink V3SET MINIE
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"

    # STLink V3SET 
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"

    # STLink V3SET 
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"
        
    # STLink V3SET in normal mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", \
        MODE:="0666", \
        SYMLINK+="stlinkv3_%n"
  '';

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "sl_SI.UTF-8";
  i18n.supportedLocales = [
    "sl_SI.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.session = [{
     name = "home-manager";
     start = ''
       ${pkgs.runtimeShell} $HOME/.hm-xsession &
       waitPID=$!
     '';
   }];

  # Configure keymap in X11
  services.xserver.layout = "si,us";
  services.xserver.xkbOptions = "grp:ctrls_toggle";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "*";

  # virtualisation.docker.enable = true;

  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [ wordnet eng2jpn jpn2eng ];
  };

  # services.mysql.package = pkgs.mariadb;
  # services.mysql.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nikola = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    powertop
    htop
    nano
    wget
    xsecurelock
    brightnessctl
    docker-compose
    ncdu
    dict
    direnv
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

