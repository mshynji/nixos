{
  config,
  theme,
  flakePath,
  ...
}:
let
  c = theme.colors;
in
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles = {
        default = "fg=#${c.fg}";
        command = "fg=#${c.white},bold";
        builtin = "fg=#${c.white},bold";
        alias = "fg=#${c.white},bold";
        function = "fg=#${c.white},bold";
        precommand = "fg=#${c.white},underline";
        unknown-token = "fg=#${c.red}";
        reserved-word = "fg=#${c.gray}";
        path = "fg=#${c.fg},underline";
        globbing = "fg=#${c.gray}";
        single-quoted-argument = "fg=#${c.gray}";
        double-quoted-argument = "fg=#${c.gray}";
        comment = "fg=#${c.dim}";
      };
    };
    history = {
      size = 50000;
      save = 50000;
      ignoreAllDups = true;
      share = true;
    };
    shellAliases = {
      ls = "eza --group-directories-first";
      ll = "eza -l --git --group-directories-first";
      la = "eza -la --git --group-directories-first";
      cat = "bat --plain";
      g = "git";
      lg = "lazygit";
      v = "nvim";
      dc = "docker compose";
      rebuild = "sudo nixos-rebuild switch --flake ${flakePath}#navi";
      wired = "fastfetch";
    };
    initContent = ''
      bindkey -e
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#${c.dim}'
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$nix_shell$python$cmd_duration$line_break$character";
      character = {
        success_symbol = "[>](bold #${c.white})";
        error_symbol = "[>](bold #${c.red})";
        vimcmd_symbol = "[<](bold #${c.gray})";
      };
      directory = {
        style = "bold #${c.white}";
        truncation_length = 4;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };
      git_branch = {
        symbol = "";
        style = "#${c.gray}";
        format = "[$branch]($style) ";
      };
      git_status = {
        style = "#${c.amber}";
        format = "([$all_status$ahead_behind]($style) )";
      };
      nix_shell = {
        symbol = "";
        style = "#${c.dim}";
        format = "[nix]($style) ";
      };
      python = {
        style = "#${c.dim}";
        format = "([$virtualenv]($style) )";
      };
      cmd_duration = {
        min_time = 3000;
        style = "#${c.dim}";
        format = "[$duration]($style)";
      };
    };
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    colors = {
      bg = "-1";
      "bg+" = "#${c.bg2}";
      fg = "#${c.gray}";
      "fg+" = "#${c.white}";
      hl = "#${c.white}";
      "hl+" = "#${c.white}";
      prompt = "#${c.white}";
      pointer = "#${c.white}";
      marker = "#${c.white}";
      info = "#${c.dim}";
      spinner = "#${c.dim}";
      header = "#${c.dim}";
      border = "#${c.line}";
    };
    defaultOptions = [
      "--no-separator"
      "--layout=reverse"
      "--height=40%"
      "--prompt='> '"
      "--pointer='>'"
    ];
  };

  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    extraOptions = [ "--color=auto" ];
  };

  home.sessionVariables.EZA_COLORS = builtins.concatStringsSep ":" [
    "di=1;37"
    "ex=37"
    "fi=38;5;252"
    "ln=38;5;248;4"
    "ur=38;5;243"
    "uw=38;5;243"
    "ux=38;5;243"
    "ue=38;5;243"
    "gr=38;5;243"
    "gw=38;5;243"
    "gx=38;5;243"
    "tr=38;5;243"
    "tw=38;5;243"
    "tx=38;5;243"
    "sn=38;5;248"
    "sb=38;5;243"
    "da=38;5;243"
    "uu=38;5;243"
    "gu=38;5;243"
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "plain";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      alias = {
        st = "status -sb";
        co = "checkout";
        lg = "log --oneline --graph --decorate";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      syntax-theme = "ansi";
      file-style = "bold #${c.white}";
      hunk-header-style = "#${c.dim}";
      minus-style = "#${c.red}";
      minus-emph-style = "bold #${c.black} #${c.red}";
      plus-style = "#${c.green}";
      plus-emph-style = "bold #${c.black} #${c.green}";
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      showIcons = false;
      theme = {
        activeBorderColor = [
          "#${c.white}"
          "bold"
        ];
        inactiveBorderColor = [ "#${c.line}" ];
        selectedLineBgColor = [ "#${c.bg2}" ];
        optionsTextColor = [ "#${c.gray}" ];
      };
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      rounded_corners = false;
    };
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
