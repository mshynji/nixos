{
  runCommand,
  python3,
  nerd-fonts,
}:
runCommand "wired-wallpaper.png"
  {
    nativeBuildInputs = [ (python3.withPackages (p: [ p.pillow ])) ];
  }
  ''
    font=$(find ${nerd-fonts.departure-mono}/share/fonts -name 'DepartureMonoNerdFontMono-Regular.*' | head -n1)
    python3 ${./wallpaper.py} "$out" "$font"
  ''
