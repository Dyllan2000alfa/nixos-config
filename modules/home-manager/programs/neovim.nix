{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix = {
            enable = true;
          };
        };
      };
    };
  };
}