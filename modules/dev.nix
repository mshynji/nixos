{ ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Lets prebuilt Linux binaries (npm postinstalls, editor servers, downloaded
  # SDKs) find a dynamic linker, so they run without patching.
  programs.nix-ld.enable = true;
}
