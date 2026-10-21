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

    # media
    discord
    tidal-hifi

    # misc
    tela-icon-theme
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    tailscale
    rpiboot
    python3
    alejandra
    nixd
    fastfetch
    mono
    protontricks
    proton-vpn
    freetype
    prismlauncher
    intiface-central
    flashgbx
    #ciscoPacketTracer9
    piper
    orca-slicer
    rpi-imager
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
      appId = "com.github.xournalpp.xournalpp";
      origin = "flathub";
    }
    {
      appId = "com.moonlight_stream.Moonlight";
      origin = "flathub";
    }
  ];
}
