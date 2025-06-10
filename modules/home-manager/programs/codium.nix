{
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions;
      [
        dracula-theme.theme-dracula
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        ms-vscode.cpptools
        jnoortheen.nix-ide
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.3.4";
          sha256 = "cVYnFhdeClHhuVaTWRU2IDIA1mFq1iLveZUIhEhMSck=";
        }
        {
          name = "indent-one-space";
          publisher = "usernamehw";
          version = "1.0.0";
          sha256 = "WbkhRm1vekpLWgq/AGKzWzsloJC79iSu/RKi//7Ve7Y=";
        }
      ];
    profiles.default.userSettings = {
      "workbench.colorTheme" = "Default Dark Modern";
      "editor.tabSize" = 2;
      "editor.detectIndentation" = false;
      "git.enableSmartCommit" = true;
      "notebook.multiCursor.enabled" = true;

      # Podman settings for dev container extension
      "dev.containers.dockerComposePath" = "podman-compose";
      "dev.containers.dockerPath" = "podman";

      # Podman settings for Docker extension (modified host path)
      "docker.dockerPath" = "podman";
      "docker.environment" = {"DOCKER_HOST" = "unix:///var/run/user/1000/podman/podman.sock";};

      #Nix Settings
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = ["alejandra"];
          };

          "options" = {
            "nixpkgs" = {
              "expr" = [
                "import <nixpkgs> {}"
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.nixpkgs {}"
              ];
            };
            "nixpkgs-unstable" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.nixpkgs-unstable {}"
              ];
            };
            "nixos-facter-modules" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.nixos-facter-modules {}"
              ];
            };
            "nix-gaming" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.nix-gaming {}"
              ];
            };
            "flatpaks" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.flatpaks {}"
              ];
            };
            "vgpu4nixos" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.vgpu4nixos {}"
              ];
            };
            "disko" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.disko {}"
              ];
            };
            "nvidia-patch" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.nvidia-patch {}"
              ];
            };
            "home-manager" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.home-manager {}"
              ];
            };
            "hyprland" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.hyprland {}"
              ];
            };
            "hyprland-plugins" = {
              "expr" = [
                "(builtins.getFlake \"github:Dyllan2000alfa/nixos-config\").nixosCOnfigurations.inputs.hyprland-plugins {}"
              ];
            };
          };
        };
      };
    };
  };
}
