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
    wineWow64Packages.stable
    winetricks
    r2modman

    # media
    #jellyfin-media-player
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
    tailscale
    rpiboot
    itch
    python3
    alejandra
    nixd
    fastfetch
    mono
    protontricks
    proton-vpn
    qbittorrent
    freetype
    prismlauncher
    intiface-central
    flashgbx
    ciscoPacketTracer9
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
