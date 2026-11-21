{ theme, ... }:
let
  c = theme.colors;
  f = theme.fonts;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      height = 24;
      spacing = 0;
      modules-left = [
        "custom/host"
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-right = [
        "custom/pomodoro"
        "cpu"
        "memory"
        "network"
        "pulseaudio"
        "tray"
        "clock"
      ];

      "custom/host" = {
        format = "navi";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        format = "{name}";
        persistent-workspaces."*" = 5;
        # Waybar 0.15 clicks send legacy dispatch syntax that Hyprland's Lua
        # config rejects, so the indicators are display-only.
        disable-click = true;
      };
      "hyprland/window" = {
        format = "{title}";
        max-length = 70;
        separate-outputs = true;
      };
      "custom/pomodoro" = {
        exec = "wired-pomo status";
        return-type = "json";
        interval = 1;
        signal = 8;
        on-click = "wired-pomo toggle";
        on-click-right = "wired-pomo skip";
      };
      cpu = {
        format = "cpu {usage:02}";
        interval = 3;
      };
      memory = {
        format = "mem {percentage:02}";
        interval = 5;
        tooltip-format = "{used:0.1f} / {total:0.1f} GiB";
      };
      network = {
        format-ethernet = "net eth";
        format-wifi = "net {essid}";
        format-disconnected = "net down";
        tooltip-format = "{ifname} {ipaddr}";
      };
      pulseaudio = {
        format = "vol {volume:02}";
        format-muted = "vol mute";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pavucontrol";
        scroll-step = 5;
      };
      tray = {
        icon-size = 14;
        spacing = 8;
      };
      clock = {
        format = "{:%y.%m.%d  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "${f.pixel}";
        font-size: 11px;
      }

      window#waybar {
        background: #${c.black};
        color: #${c.gray};
        border-bottom: 1px solid #${c.line};
      }

      tooltip {
        background: #${c.black};
        border: 1px solid #${c.white};
      }

      tooltip label {
        color: #${c.fg};
      }

      #custom-host {
        background: #${c.white};
        color: #${c.black};
        padding: 0 10px;
      }

      #workspaces {
        margin-left: 6px;
      }

      #workspaces button {
        background: transparent;
        color: #${c.dim};
        padding: 0 7px;
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.active {
        background: #${c.white};
        color: #${c.black};
      }

      #workspaces button.urgent {
        color: #${c.red};
      }

      #window {
        color: #${c.dim};
        padding-left: 12px;
      }

      #custom-pomodoro,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #clock {
        padding: 0 10px;
        border-left: 1px solid #${c.line};
      }

      #clock {
        color: #${c.white};
      }

      #custom-pomodoro.idle {
        color: #${c.dim};
      }

      #custom-pomodoro.work {
        background: #${c.white};
        color: #${c.black};
      }

      #custom-pomodoro.rest {
        color: #${c.green};
      }

      #network.disconnected,
      #pulseaudio.muted {
        color: #${c.red};
      }
    '';
  };
}
