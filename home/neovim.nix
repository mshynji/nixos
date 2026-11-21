{
  pkgs,
  lib,
  theme,
  ...
}:
let
  debugpyPython = pkgs.python3.withPackages (p: [ p.debugpy ]);
  generated = ''
    return {
      colors = {
        ${lib.concatStringsSep "\n    " (
          lib.mapAttrsToList (name: value: ''${name} = "#${value}",'') theme.colors
        )}
      },
      debugpy_python = "${debugpyPython}/bin/python",
    }
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    initLua = ''require("wired")'';

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (
        p: with p; [
          bash
          c
          cpp
          css
          dockerfile
          go
          gomod
          hcl
          html
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          python
          rust
          terraform
          toml
          tsx
          typescript
          typst
          vim
          vimdoc
          yaml
        ]
      ))
      nvim-lspconfig
      blink-cmp
      conform-nvim
      fzf-lua
      oil-nvim
      gitsigns-nvim
      which-key-nvim
      mini-nvim
      render-markdown-nvim
      nvim-dap
      nvim-dap-ui
      nvim-nio
    ];

    extraPackages = with pkgs; [
      # search
      ripgrep
      fd
      fzf

      # language servers
      nixd
      lua-language-server
      basedpyright
      ruff
      typescript-language-server
      vscode-langservers-extracted
      clang-tools
      rust-analyzer
      gopls
      dockerfile-language-server
      docker-compose-language-service
      yaml-language-server
      terraform-ls
      bash-language-server
      marksman
      tinymist

      # formatters
      nixfmt
      stylua
      prettierd
      shfmt
      gofumpt
      rustfmt

      # debuggers
      lldb
      delve
      vscode-js-debug
    ];
  };

  xdg.configFile = {
    "nvim/lua/wired".source = ./nvim/wired;
    "nvim/lua/wired_generated.lua".text = generated;
  };
}
