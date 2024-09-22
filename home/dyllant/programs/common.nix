{ lib, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    unrar

    # utilites
    alsa-utils
    ventoy-full
    betterdiscordctl
    talosctl
    nix-index
    alsa-scarlett-gui
    wineWowPackages.stable
    winetricks
    gparted
    r2modman
    kubectl
    kubernetes-helm

    # media
    jellyfin-media-player
    discord
    vlc

    # misc
    gnome.zenity
    openssl_1_1
    tela-icon-theme
    gamemode
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    prismlauncher
    tailscale
  ];

  # Flatpak packages to be installed to the user profile
  services.flatpak.packages = [
    { appId = "io.gitlab.librewolf-community"; origin = "flathub";  }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub";  }
    { appId = "com.spotify.Client"; origin = "flathub";  }
    { appId = "com.github.xournalpp.xournalpp"; origin = "flathub";  }
    { appId = "com.github.wwmm.easyeffects"; origin = "flathub";  }
    { appId = "org.pipewire.Helvum"; origin = "flathub";  }
    { appId = "com.moonlight_stream.Moonlight"; origin = "flathub";  }
  ];

  programs = {
    # Install vscode, my IDE of choice with extensions
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        bbenoist.nix
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        ms-vscode.cpptools
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.3.3";
          sha256 = "d8kwQVoG/MOujmvMaX6Y0wl85L2PNdv2EnqTZKo8pGk=";
        }
      ];
      userSettings = {
        "workbench.colorTheme" = "Default Dark Modern";
        "editor.tabSize" = 2;
        "editor.detectIndentation" = false;
        "git.enableSmartCommit" = true;

        # Podman settings for dev container extension
        "dev.containers.dockerComposePath" = "podman-compose";
        "dev.containers.dockerPath" = "podman";

        # Podman settings for Docker extension (modified host path)
        "docker.dockerPath" = "podman";
        "docker.environment" = { "DOCKER_HOST" = "unix:///var/run/user/1000/podman/podman.sock"; } ;
      };
    };

    # Install obs-studio with plugins
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-tuna
        obs-nvfbc
        input-overlay
        droidcam-obs
      ];
    };
  };
}