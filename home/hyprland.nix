{
  pkgs,
  lib,
  theme,
  ...
}:
let
  c = theme.colors;
  f = theme.fonts;
  wallpaper = pkgs.callPackage ../pkgs/wallpaper { };

  power = pkgs.writeShellApplication {
    name = "wired-power";
    runtimeInputs = with pkgs; [
      fuzzel
      hyprlock
      systemd
    ];
    text = ''
      choice=$(printf 'lock\nsuspend\nlog out\nreboot\npower off\n' | fuzzel --dmenu --prompt 'system > ' --lines 5 --width 24)
      case "$choice" in
        lock) hyprlock ;;
        suspend) systemctl suspend ;;
        "log out") hyprctl dispatch 'hl.dsp.exit()' ;;
        reboot) systemctl reboot ;;
        "power off") systemctl poweroff ;;
      esac
    '';
  };

  clipboard = pkgs.writeShellApplication {
    name = "wired-clipboard";
    runtimeInputs = with pkgs; [
      cliphist
      fuzzel
      wl-clipboard
    ];
    text = ''
      cliphist list | fuzzel --dmenu --prompt 'clip > ' | cliphist decode | wl-copy
    '';
  };

  screenshot = pkgs.writeShellApplication {
    name = "wired-shot";
    runtimeInputs = with pkgs; [
      grim
      slurp
      wl-clipboard
      libnotify
      coreutils
    ];
    text = ''
      dir="$HOME/Pictures/shots"
      mkdir -p "$dir"
      file="$dir/$(date +%y%m%d-%H%M%S).png"
      if [ "''${1:-region}" = full ]; then
        grim "$file"
      else
        region=$(slurp -b 00000088 -c ffffff -s 00000000 -w 1) || exit 0
        grim -g "$region" "$file"
      fi
      wl-copy --type image/png < "$file"
      notify-send -a shot "captured" "$(basename "$file")"
    '';
  };
in
{
  home.packages = [
    power
    clipboard
    screenshot
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # The NixOS module provides the compositor and portal.
    package = null;
    portalPackage = null;
    configType = "lua";
    extraConfig = ''
      local mod = "SUPER"
      local run = function(cmd) return hl.dsp.exec_cmd(cmd) end

      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      hl.env("XCURSOR_THEME", "${theme.cursor.name}")
      hl.env("XCURSOR_SIZE", "${toString theme.cursor.size}")

      hl.config({
        general = {
          gaps_in = 3,
          gaps_out = 6,
          border_size = 1,
          col = {
            active_border = "rgb(${c.white})",
            inactive_border = "rgb(${c.line})",
          },
          layout = "dwindle",
          resize_on_border = true,
        },
        decoration = {
          rounding = 0,
          shadow = { enabled = false },
          blur = { enabled = false },
        },
        animations = { enabled = true },
        dwindle = { preserve_split = true },
        input = {
          kb_layout = "us",
          follow_mouse = 1,
          accel_profile = "flat",
          repeat_delay = 280,
          repeat_rate = 40,
        },
        misc = {
          force_default_wallpaper = 0,
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          background_color = 0xff${c.black},
          key_press_enables_dpms = true,
          mouse_move_enables_dpms = true,
        },
        cursor = {
          -- Hardware cursors flicker or vanish on NVIDIA.
          no_hardware_cursors = true,
          inactive_timeout = 8,
        },
        ecosystem = {
          no_update_news = true,
          no_donation_nag = true,
        },
      })

      -- Short and linear: state changes, nothing performs.
      hl.curve("snap", { type = "bezier", points = { {0.2, 1}, {0.3, 1} } })
      hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "snap" })
      hl.animation({ leaf = "border", enabled = false })
      hl.animation({ leaf = "windows", enabled = true, speed = 1.5, bezier = "snap", style = "slide" })
      hl.animation({ leaf = "fade", enabled = true, speed = 1.5, bezier = "snap" })
      hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "snap", style = "fade" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "snap", style = "fade" })

      -- apps
      hl.bind(mod .. " + RETURN", run("foot"))
      hl.bind(mod .. " + D", run("fuzzel"))
      hl.bind(mod .. " + B", run("firefox"))
      hl.bind(mod .. " + E", run("foot -e yazi"))
      hl.bind(mod .. " + N", run("foot --app-id=notes -e nvim +WiredNotes"))
      hl.bind(mod .. " + P", run("wired-pomo toggle"))
      hl.bind(mod .. " + C", run("wired-clipboard"))
      hl.bind(mod .. " + ESCAPE", run("hyprlock"))
      hl.bind(mod .. " + SHIFT + E", run("wired-power"))
      hl.bind(mod .. " + SHIFT + S", run("wired-shot"))
      hl.bind("Print", run("wired-shot full"))

      -- windows
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"))

      for key, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
      end

      for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mod .. " + GRAVE", hl.dsp.workspace.toggle_special("scratch"))
      hl.bind(mod .. " + SHIFT + GRAVE", hl.dsp.window.move({ workspace = "special:scratch" }))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- media
      hl.bind("XF86AudioRaiseVolume", run("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
      hl.bind("XF86AudioPlay", run("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioNext", run("playerctl next"), { locked = true })
      hl.bind("XF86AudioPrev", run("playerctl previous"), { locked = true })

      -- rules
      hl.window_rule({ name = "notes", match = { class = "^notes$" }, float = true, center = true, size = "1100 720" })
      hl.window_rule({ name = "volume", match = { class = "^org.pulseaudio.pavucontrol$" }, float = true, center = true, size = "760 520" })
      hl.window_rule({ name = "pip", match = { title = "^Picture-in-Picture$" }, float = true, pin = true })
    '';
  };

  systemd.user.services.wired-wallpaper = {
    Unit = {
      Description = "wired wallpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill -c 000000";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${f.mono}:size=${toString f.monoSize}";
        prompt = "'> '";
        icons-enabled = false;
        width = 44;
        lines = 10;
        horizontal-pad = 14;
        vertical-pad = 10;
        inner-pad = 8;
      };
      colors = {
        background = "${c.black}ff";
        text = "${c.gray}ff";
        prompt = "${c.white}ff";
        input = "${c.white}ff";
        match = "${c.white}ff";
        selection = "${c.white}ff";
        selection-text = "${c.black}ff";
        selection-match = "${c.black}ff";
        border = "${c.white}ff";
      };
      border = {
        width = 1;
        radius = 0;
      };
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "${f.mono} ${toString f.monoSize}";
      background-color = "#${c.black}";
      text-color = "#${c.fg}";
      border-color = "#${c.white}";
      border-size = 1;
      border-radius = 0;
      padding = "10,14";
      margin = "10";
      width = 340;
      default-timeout = 6000;
      anchor = "top-right";
      "urgency=critical" = {
        border-color = "#${c.red}";
        default-timeout = 0;
      };
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };

  services.cliphist.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      background = [
        {
          monitor = "";
          path = "${wallpaper}";
          color = "rgb(${c.black})";
          brightness = 0.45;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "260, 34";
          position = "0, -80";
          halign = "center";
          valign = "center";
          rounding = 0;
          outline_thickness = 1;
          outer_color = "rgb(${c.white})";
          inner_color = "rgb(${c.black})";
          font_color = "rgb(${c.white})";
          check_color = "rgb(${c.gray})";
          fail_color = "rgb(${c.red})";
          fade_on_empty = false;
          dots_rounding = 0;
          placeholder_text = "";
          fail_text = "access denied";
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(${c.white})";
          font_size = 56;
          font_family = f.pixel;
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = theme.greeting;
          color = "rgb(${c.gray})";
          font_size = 12;
          font_family = f.pixel;
          position = "0, -24";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
