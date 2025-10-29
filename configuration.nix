# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

   let
  stylix = builtins.fetchTarball "https://github.com/nix-community/stylix/archive/refs/heads/master.tar.gz";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.enableIPv6 = false;
  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
 
  #experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carlos = {
    isNormalUser = true;
    description = "carlos";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirt" "kvm" "qemu"];
    packages = with pkgs; [
    #browser
     google-chrome
     telegram-desktop

    #multimedia
     jamesdsp

    #develoment
     git

    #performace
    tuned
 
    #shell
    fish
    oh-my-posh
    zellij
    blackbox-terminal
    xclip
    kitty
    busybox
    neofetch
    grc

    #tools
    unzip
    nmap
    curl
    android-tools
    realvnc-vnc-viewer
    lm_sensors
    usbutils
    hwdata
    htop
    gnome-tweaks
    wineWowPackages.stable
    bottles
    appimage-run
    freerdp3
    tigervnc
    #fonts
    nerd-fonts.jetbrains-mono

    #gns3
    gns3-gui
     gns3-server
     docker
     qemu
     virt-manager
     bridge-utils
     dnsmasq 
     wireshark
     ubridge
     virt-manager
     dynamips

   #gnome-extension
   gnomeExtensions.vitals
   gnomeExtensions.systemd-manager
   gnomeExtensions.systemd-status
   
   #icons
    whitesur-icon-theme

   #grafana
    grafana
    prometheus
   
   #exporter
    prometheus-node-exporter
    prometheus-snmp-exporter
    prometheus-mikrotik-exporter
   
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "carlos";
  
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   cloudflared
  #kernel
   linuxKernel.kernels.linux_xanmod_stable
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
   
  #tuned-adm
  services.tuned.enable = true;
  #services.tuned.settings.profile = "desktop";

  #glances
  services.glances.enable = true;
  
  #nh
  programs.nh.enable = true;

  #vmware
  virtualisation.vmware.host.enable = true;

  #docker
  virtualisation.docker = {
    enable = false;
    enableOnBoot = false;
    rootless.enable = true; # gunakan true jika ingin tanpa sudo
  };
  

  # Enable KVM + QEMU + libvirt
   virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true; # TPM emulator (opsional)
      ovmf.enable = true;  # UEFI support untuk VM
      runAsRoot = true;
    };
  };
  #qemu
   services.qemuGuest.enable = true;

  #grafana
   # Grafana + Prometheus + Exporter
  services.prometheus = {
    enable = true;
    port = 9090;

    exporters = {
      node = {
        enable = true;
        port = 9100;
        listenAddress = "0.0.0.0";
      };

      mikrotik = {
        enable = true;
        listenAddress = "0.0.0.0";
        port = 9200;
        configuration = {
          devices = [
            {
              name = "router1";
              address = "192.168.122.219"; # IP Mikrotik kamu
              user = "admin";
              password = "carlos";
            }
          ];
          features = {
            bgp = true;
            dhcp = true;
            routes = true;
            optics = true;
          };
        };
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{ targets = [ "localhost:9100" ]; }];
      }
      {
        job_name = "mikrotik";
        static_configs = [{ targets = [ "localhost:9200" ]; }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 3000;
      domain = "localhost";
    };

    provision = {
      enable = true;
      datasources = {
        settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://localhost:9090";
              isDefault = true;
            }
          ];
        };
      };
    };
  };



 
  #virt-manager
   programs.virt-manager.enable = true;

  #Enable GNS3 Server
  services.gns3-server.enable = false;

  #wireshark
  programs.wireshark.enable = true;

  #ubridge / dynamips
  services.gns3-server.ubridge.enable = true;
  services.gns3-server.dynamips.enable = true;
  
  #winbox
  programs.winbox.enable = true;

  #Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #gpu-screen-recorder
  programs.gpu-screen-recorder.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  

 #boot
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [
  "quiet"
  "loglevel=3"
  "mitigations=off"
];

}
