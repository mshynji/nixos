{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./terminal.nix
    ./shell.nix
    ./neovim.nix
    ./study.nix
    ./gtk.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";

    packages = with pkgs; [
      # toolchains
      gcc
      gnumake
      cmake
      gdb
      rustc
      cargo
      go
      nodejs_22
      pnpm
      python3
      uv
      docker-compose
      terraform

      # cli
      ripgrep
      fd
      jq
      tree
      fastfetch
      claude-code

      # desktop
      grim
      slurp
      wl-clipboard
      libnotify
      playerctl
      pavucontrol
      imv
      mpv
      file-roller
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "foot";
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs.home-manager.enable = true;
}
