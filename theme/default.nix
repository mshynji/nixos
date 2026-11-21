# The single source of truth for the look. Every app reads from here.
# Colours are bare hex; add "#" where an app wants it.
{
  colors = {
    black = "000000";
    bg1 = "0c0c0c"; # raised surfaces
    bg2 = "181818"; # selection, hover
    line = "2e2e2e"; # borders, rules
    dim = "767676"; # comments, secondary text
    gray = "a8a8a8"; # strings, quiet content
    fg = "d6d6d6"; # body text
    white = "ffffff"; # emphasis, focus

    # Colour is reserved for meaning: state, diagnostics, diffs.
    red = "d0544a";
    amber = "c8a15a";
    green = "8fa98a";
    violet = "8f8ac9";
  };

  fonts = {
    mono = "Terminess Nerd Font";
    monoSize = 12;
    pixel = "DepartureMono Nerd Font";
    sans = "IBM Plex Sans";
  };

  cursor = {
    name = "Bibata-Original-Classic";
    size = 20;
  };

  greeting = "present day, present time";
}
