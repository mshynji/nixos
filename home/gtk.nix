{ pkgs, theme, ... }:
let
  c = theme.colors;
  css = ''
    @define-color window_bg_color #${c.black};
    @define-color window_fg_color #${c.fg};
    @define-color view_bg_color #${c.black};
    @define-color view_fg_color #${c.fg};
    @define-color headerbar_bg_color #${c.black};
    @define-color headerbar_fg_color #${c.fg};
    @define-color sidebar_bg_color #${c.bg1};
    @define-color card_bg_color #${c.bg1};
    @define-color popover_bg_color #${c.bg1};
    @define-color dialog_bg_color #${c.bg1};
    @define-color accent_bg_color #${c.white};
    @define-color accent_fg_color #${c.black};
    @define-color accent_color #${c.white};
  '';
in
{
  home.pointerCursor = {
    name = theme.cursor.name;
    size = theme.cursor.size;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = theme.fonts.sans;
      size = 11;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraCss = css;
    gtk4.extraCss = css;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
