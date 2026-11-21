{ pkgs, theme, ... }:
let
  c = theme.colors;
in
{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = builtins.concatStringsSep " " [
        "${pkgs.tuigreet}/bin/tuigreet"
        "--time"
        "--remember"
        "--asterisks"
        "--greeting '${theme.greeting}'"
        "--theme 'border=darkgray;text=gray;prompt=white;time=gray;action=darkgray;button=white;container=black;input=white'"
        "--cmd start-hyprland"
      ];
    };
  };

  security.pam.services.hyprlock = { };
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.printing.enable = true;
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.firefox.enable = true;

  # The kernel console, in monochrome, from the first line of boot.
  console.colors = [
    c.black
    c.red
    c.green
    c.amber
    c.gray
    c.violet
    c.gray
    c.fg
    c.dim
    c.red
    c.green
    c.amber
    c.gray
    c.violet
    c.gray
    c.white
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      nerd-fonts.departure-mono
      ibm-plex
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ theme.fonts.mono ];
      sansSerif = [ theme.fonts.sans ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    unzip
    pciutils
    usbutils
  ];
}
