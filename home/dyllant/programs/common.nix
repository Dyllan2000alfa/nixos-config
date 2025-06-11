{
  lib,
  pkgs,
  imports,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    unrar

    # utilites
    alsa-utils
    talosctl
    nix-index
    wineWowPackages.stable
    winetricks
    r2modman

    # media
    jellyfin-media-player
    discord
    vlc
    tidal-hifi

    # misc
    zenity
    openssl_1_1
    tela-icon-theme
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    prismlauncher
    tailscale
    rpiboot
    rpi-imager
    itch
    orca-slicer
    python3
    alejandra
    nixd
    neofetch
  ];

  # Flatpak packages to be installed to the user profile
  services.flatpak.packages = [
    {
      appId = "io.gitlab.librewolf-community";
      origin = "flathub";
    }
    {
      appId = "com.github.tchx84.Flatseal";
      origin = "flathub";
    }
    {
      appId = "com.spotify.Client";
      origin = "flathub";
    }
    {
      appId = "com.github.xournalpp.xournalpp";
      origin = "flathub";
    }
    {
      appId = "com.github.wwmm.easyeffects";
      origin = "flathub";
    }
    {
      appId = "org.pipewire.Helvum";
      origin = "flathub";
    }
    {
      appId = "com.moonlight_stream.Moonlight";
      origin = "flathub";
    }
  ];
}
