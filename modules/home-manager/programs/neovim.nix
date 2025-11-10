{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;

    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        lsp.enable = true;

        languages = {
          enableTreesitter = true;

          nix.enable = true;
          python.enable = true;
          clang.enable = true;
        };
      };
    };
  };
}