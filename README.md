# wired

A black-and-white NixOS rice for dev work and study. Hyprland, Waybar, foot,
tmux, zsh and Neovim, all drawn from one palette in `theme/default.nix`.

Colour is reserved for meaning: errors, warnings, diffs and timer state.

## Layout

| Path | Purpose |
| --- | --- |
| `flake.nix` | Entry point; sets username and hostname |
| `theme/default.nix` | Colours, fonts, cursor, greeting |
| `hosts/navi/` | Machine settings and hardware config |
| `modules/` | System: NVIDIA, desktop, Docker |
| `home/` | User: compositor, bar, terminal, shell, editor, study |
| `home/nvim/wired/` | Neovim config, plain Lua |
| `pkgs/wallpaper/` | Generates the wallpaper at build time |

## Install (replaces Ubuntu)

This PC has **two NVMe drives: one holds Windows (NTFS partitions) and one holds
Ubuntu (ext4)**. Only the Ubuntu drive gets erased. `nvme0`/`nvme1` numbering can
change between boots, so identify the drive by its contents, not its name.

1. **Back up everything from Ubuntu to external storage**: home directory,
   `~/Documents/projects`, `~/.ssh`, browser data, and any Docker volumes. Copy
   this `wired-nixos` folder to the same USB drive.
2. Boot the NixOS 26.05 minimal ISO and get online (`nmtui` or Ethernet), then
   `sudo -i`.
3. Find the Ubuntu drive. It's the one with `ext4` and a `vfat` partition, and
   **no `ntfs`**:

   ```sh
   lsblk -f
   ls -l /dev/disk/by-id/ | grep nvme
   DISK=/dev/disk/by-id/nvme-PASTE-THE-UBUNTU-DRIVE-ID
   ```

4. Erase and format. Re-read the value of `$DISK` first; this cannot be undone.

   ```sh
   parted "$DISK" -- mklabel gpt
   parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
   parted "$DISK" -- set 1 esp on
   parted "$DISK" -- mkpart root ext4 1GiB 100%
   udevadm settle
   mkfs.fat -F32 -n BOOT "$DISK-part1"
   mkfs.ext4 -L NIXOS "$DISK-part2"
   udevadm settle
   ```

5. Mount, and bring in the config:

   ```sh
   mount /dev/disk/by-label/NIXOS /mnt
   mkdir -p /mnt/boot /mnt/home/akemi
   mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot
   cp -r /path/to/usb/wired-nixos /mnt/home/akemi/wired-nixos
   nixos-generate-config --root /mnt --show-hardware-config \
     > /mnt/home/akemi/wired-nixos/hosts/navi/hardware-configuration.nix
   ```

6. Install. It asks for a root password at the end.

   ```sh
   nixos-install --flake /mnt/home/akemi/wired-nixos#navi
   nixos-enter --root /mnt -c 'passwd akemi'
   chown -R 1000:100 /mnt/home/akemi
   reboot
   ```

To reach Windows afterwards, use your motherboard's boot menu, since Windows
stays on its own drive with its own boot partition.

After first login, set your Git identity in `programs.git.settings` in
`home/shell.nix` (`user.name` and `user.email`), then run `rebuild`.

## Daily use

Apply changes with `rebuild`. Update pinned packages with `nix flake update`
inside `~/wired-nixos`, then `rebuild`. If you put this folder under Git, `git add`
new files, because flakes ignore untracked ones.

### Keys

`mod` is the Super key.

| Key | Action | Key | Action |
| --- | --- | --- | --- |
| `mod+Return` | terminal | `mod+h/j/k/l` | focus |
| `mod+d` | launcher | `mod+shift+h/j/k/l` | move window |
| `mod+b` | browser | `mod+1..9` | workspace |
| `mod+e` | files (yazi) | `mod+shift+1..9` | send to workspace |
| `mod+n` | floating notes | `mod+q` | close |
| `mod+p` | pomodoro start/stop | `mod+f` | fullscreen |
| `mod+c` | clipboard history | `mod+v` | float |
| `mod+shift+s` | screenshot region | `mod+t` | flip split |
| `Print` | screenshot full | `` mod+` `` | scratch workspace |
| `mod+Esc` | lock | `mod+shift+e` | power menu |

### Neovim

Leader is Space; press it and wait for the key guide.

| Key | Action |
| --- | --- |
| `<leader>f` / `/` / `b` | files / grep / buffers |
| `-` | browse directory as a buffer |
| `gd` / `gr` / `K` | definition / references / hover |
| `<leader>ca` / `cr` / `cf` | code action / rename / format |
| `<leader>db` / `dc` / `du` | breakpoint / continue / debug UI |
| `<leader>nn` / `nd` / `nf` / `ng` | notes index / today / find / grep |
| `<leader>np` | in a Typst file: live PDF preview |

### Study

- **Pomodoro:** `mod+p` or click the bar: 25/5, and notifications are held
  during work. Right-click skips the current phase.
- **Notes:** plain Markdown in `~/notes`, rendered in place in Neovim.
- **PDFs:** zathura renders pages white-on-black; `i` shows the original colours.
- **Writing and memory:** `typst`, LaTeX (`texliveMedium`), `pandoc`, and Anki.

## Project toolchains

Rust, Go, Node, Python and C compilers are installed globally for quick work.
For project-pinned versions, add a `flake.nix` dev shell and `use flake` in
`.envrc`; `direnv` loads it automatically.

## Known limitation

Waybar's workspace indicators are display-only. Waybar 0.15 sends the old
dispatch syntax, which Hyprland 0.55's Lua config rejects.
