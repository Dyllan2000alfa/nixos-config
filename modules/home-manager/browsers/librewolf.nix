{ config, pkgs, ... }:

{
  # Install flatpak librewolf
  services.flatpak.packages = [
    { appId = "io.gitlab.librewolf-community"; origin = "flathub";  }
  ];

  # Install native librewolf
  programs.librewolf = {
    enable = false;
    settings = {
      "extensions.update.enabled" = true;
      "extensions.update.autoUpdateDefault" = true;
      "identity.fxaccounts.enabled" = true;
      "clipboard.autocopy" = false;
      "middlemouse.paste" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "network.dns.disableIPv6" = true;
      "network.http.referer.XOriginPolicy"= false;
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.letterboxing" = false;
      "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = false;
      "webgl.disabled" = false;
      "security.OCSP.require" = true;
      "browser.safebrowsing.downloads.enabled" = false;
      "identity.sync.tokenserver.uri" = "	https://ffsync.tinoco.casa/token/1.0/sync/1.5";
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
    };
  };
}