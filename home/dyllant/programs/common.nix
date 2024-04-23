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
    { appId = "org.libreoffice.LibreOffice"; origin = "flathub";  }
  ];

  programs = {
    # Install vscode, my IDE of choice with extensions
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        bbenoist.nix
      ];
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

  services.syncthing = {
    enable = true;
  };
}