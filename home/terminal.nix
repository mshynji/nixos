{ theme, ... }:
let
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${f.mono}:size=${toString f.monoSize}";
        pad = "14x12";
        term = "foot";
      };
      cursor = {
        style = "block";
        blink = "no";
      };
      mouse.hide-when-typing = "yes";
      scrollback.lines = 20000;
      colors-dark = {
        background = c.black;
        foreground = c.fg;
        selection-background = c.white;
        selection-foreground = c.black;
        regular0 = "1c1c1c";
        regular1 = c.red;
        regular2 = c.green;
        regular3 = c.amber;
        regular4 = c.gray;
        regular5 = c.violet;
        regular6 = c.gray;
        regular7 = c.fg;
        bright0 = c.dim;
        bright1 = c.red;
        bright2 = c.green;
        bright3 = c.amber;
        bright4 = c.fg;
        bright5 = c.violet;
        bright6 = c.fg;
        bright7 = c.white;
      };
    };
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    terminal = "tmux-256color";
    extraConfig = ''
      set -as terminal-features ",foot:RGB"
      set -g renumber-windows on
      set -g status-position top
      set -g status-justify left
      set -g status-style "bg=#${c.black},fg=#${c.dim}"
      set -g status-left "#[fg=#${c.white}]#S #[fg=#${c.line}]/ "
      set -g status-left-length 24
      set -g status-right "#[fg=#${c.dim}]#h"
      set -g window-status-format " #I #W "
      set -g window-status-current-format "#[bg=#${c.white},fg=#${c.black}] #I #W "
      set -g window-status-separator ""
      set -g pane-border-style "fg=#${c.line}"
      set -g pane-active-border-style "fg=#${c.white}"
      set -g message-style "bg=#${c.white},fg=#${c.black}"
      set -g mode-style "bg=#${c.white},fg=#${c.black}"
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };
}
