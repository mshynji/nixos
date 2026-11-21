{ pkgs, theme, ... }:
let
  c = theme.colors;

  # 25/5 timer behind the bar module. Notifications are held during work.
  pomodoro = pkgs.writeShellApplication {
    name = "wired-pomo";
    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      mako
      procps
    ];
    text = ''
      state="''${XDG_RUNTIME_DIR:?}/wired-pomo"
      work=$((25 * 60))
      rest=$((5 * 60))

      quiet() { makoctl mode -a do-not-disturb >/dev/null 2>&1 || true; }
      loud() { makoctl mode -r do-not-disturb >/dev/null 2>&1 || true; }
      begin() { printf '%s %s\n' "$1" "$(($(date +%s) + $2))" >"$state"; }
      stop() { rm -f "$state"; loud; }

      next() {
        case "$1" in
          work)
            loud
            begin rest "$rest"
            notify-send -a pomodoro "rest" "step away for five minutes"
            ;;
          rest)
            stop
            notify-send -a pomodoro "session complete" "start another when ready"
            ;;
        esac
      }

      read_state() {
        phase=""
        end=0
        if [ -f "$state" ]; then
          read -r phase end <"$state"
        fi
      }

      case "''${1:-status}" in
        toggle)
          read_state
          if [ -n "$phase" ]; then
            stop
          else
            quiet
            begin work "$work"
          fi
          pkill -RTMIN+8 waybar || true
          ;;
        skip)
          read_state
          if [ -n "$phase" ]; then next "$phase"; fi
          ;;
        status)
          read_state
          now=$(date +%s)
          if [ -n "$phase" ] && [ "$now" -ge "$end" ]; then
            next "$phase"
            read_state
          fi
          if [ -z "$phase" ]; then
            printf '{"text":"pomo","class":"idle","tooltip":"click to start 25/5"}\n'
          else
            left=$((end - now))
            if [ "$left" -lt 0 ]; then left=$rest; fi
            printf '{"text":"%s %02d:%02d","class":"%s","tooltip":"click to stop, right-click to skip"}\n' \
              "$phase" $((left / 60)) $((left % 60)) "$phase"
          fi
          ;;
      esac
    '';
  };
in
{
  home.packages = with pkgs; [
    pomodoro
    typst
    texliveMedium
    pandoc
    anki
  ];

  programs.zathura = {
    enable = true;
    options = {
      font = "${theme.fonts.mono} ${toString theme.fonts.monoSize}";
      recolor = true;
      recolor-keephue = false;
      recolor-lightcolor = "#${c.black}";
      recolor-darkcolor = "#${c.fg}";
      default-bg = "#${c.black}";
      default-fg = "#${c.fg}";
      statusbar-bg = "#${c.black}";
      statusbar-fg = "#${c.dim}";
      inputbar-bg = "#${c.black}";
      inputbar-fg = "#${c.white}";
      completion-bg = "#${c.black}";
      completion-fg = "#${c.gray}";
      completion-highlight-bg = "#${c.white}";
      completion-highlight-fg = "#${c.black}";
      highlight-color = "rgba(255,255,255,0.3)";
      highlight-active-color = "rgba(200,161,90,0.5)";
      notification-bg = "#${c.black}";
      notification-fg = "#${c.white}";
      notification-error-bg = "#${c.black}";
      notification-error-fg = "#${c.red}";
      index-bg = "#${c.black}";
      index-fg = "#${c.gray}";
      index-active-bg = "#${c.white}";
      index-active-fg = "#${c.black}";
      selection-clipboard = "clipboard";
      guioptions = "s";
      window-title-basename = true;
      adjust-open = "width";
    };
    # `i` flips between the night reading mode and the page's real colours.
    mappings.i = "recolor";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
    };
  };
}
