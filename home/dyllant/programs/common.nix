{ lib, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    unrar

    # misc
    gnome.zenity
    openssl_1_1
    ventoy-full
    gparted
  ];

  # Flatpak packages to be installed to the user profile
  services.flatpak.packages = [
    { appId = "io.gitlab.librewolf-community"; origin = "flathub";  }
    { appId = "com.discordapp.Discord"; origin = "flathub";  }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub";  }
    { appId = "com.spotify.Client"; origin = "flathub";  }
    { appId = "org.polymc.PolyMC"; origin = "flathub";  }
    { appId = "com.github.xournalpp.xournalpp"; origin = "flathub";  }
    { appId = "com.github.wwmm.easyeffects"; origin = "flathub";  }
    { appId = "com.github.iwalton3.jellyfin-media-player"; origin = "flathub";  }
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
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.3.3";
          sha256 = "pcWKBqtpU7DVpiT7UF6Zi+YUKknyjtXFEf5nL9+xuSo=";
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

  gtk = {
    enable = true;
    iconTheme.package = pkgs.tela-icon-theme;
    iconTheme.name = "Tela-purple-dark";
    theme.package = pkgs.layan-gtk-theme;
    theme.name = "Layan-Dark";
  };

  qt = {
    enable = true;
    style.package = pkgs.layan-kde;
    style.name = "Layan";
  };
}