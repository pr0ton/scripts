#!/usr/bin/env bash
# Personal Ubuntu desktop setup. Run as your regular desktop user.
set -Eeuo pipefail
trap 'printf "Setup failed at line %s. Fix the error above and rerun.\n" "$LINENO" >&2' ERR

usage() {
  cat <<'HELP'
Usage: ./install.sh [options]
  --dry-run                 Print commands without changing the computer
  --no-latex                Skip the large LaTeX package collection
  --no-chrome               Skip Google Chrome
  --no-code                 Skip Visual Studio Code
  --no-spotify              Skip Spotify
  --with-sharing            Install Nautilus network file sharing
  --no-restricted-extras    Skip extra codecs/fonts (included by default)
  -h, --help                Show this help

Defaults: development tools, media/graphics apps, LaTeX, Chrome,
VS Code, Spotify, KeePassXC from stable Flathub, and ubuntu-restricted-extras.
The extras package may prompt for a font license.
HELP
}

dry_run=false
latex=true
chrome=true
code=true
spotify=true
sharing=false
restricted=true
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --no-latex) latex=false ;;
    --no-chrome) chrome=false ;;
    --no-code) code=false ;;
    --no-spotify) spotify=false ;;
    --with-sharing) sharing=true ;;
    --no-restricted-extras) restricted=false ;;
    --with-restricted-extras) restricted=true ;; # Backward-compatible alias
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

if (( EUID == 0 )) && ! "$dry_run"; then
  echo 'Run as your regular user, without sudo. The script uses sudo where needed.' >&2
  exit 1
fi
# shellcheck disable=SC1091
source /etc/os-release
if [[ ${ID:-} != ubuntu ]]; then
  echo 'This script targets Ubuntu desktop.' >&2
  exit 1
fi
case "${VERSION_ID:-}" in
  24.04|26.04) ;;
  *) echo "Ubuntu ${VERSION_ID:-unknown} is not a supported target; use 24.04 or 26.04 LTS." >&2; exit 1 ;;
esac
arch=$(dpkg --print-architecture)
if "$chrome" && [[ $arch != amd64 ]]; then
  echo 'Google Chrome for Linux requires amd64. Rerun with --no-chrome.' >&2
  exit 1
fi

run() {
  printf '+'
  printf ' %q' "$@"
  printf '\n'
  if ! "$dry_run"; then "$@"; fi
}

packages=(
  ca-certificates curl git gh openssh-client
  build-essential cmake pkg-config default-jdk
  python3 python3-pip python3-venv pipx
  exfatprogs ffmpeg gimp qalculate-gtk vlc
  flatpak gnome-software-plugin-flatpak
)
if "$latex"; then
  packages+=(texlive-latex-extra texlive-extra-utils texlive-pictures texlive-publishers texlive-science)
fi
if "$sharing"; then packages+=(nautilus-share); fi
if "$code" || "$spotify"; then packages+=(snapd); fi

run sudo -v
run sudo apt-get update
# Check dependency resolution before installing any packages.
run apt-get --simulate install "${packages[@]}"
run sudo apt-get install -y "${packages[@]}"
if "$restricted"; then
  # Keep license prompts interactive; do not silently accept the font EULA.
  run sudo apt-get install ubuntu-restricted-extras
fi

# apt resolves dependencies; the Google package supplies its update repository.
# Existing installations update through their configured apt source.
if "$chrome"; then
  if dpkg-query -W -f='${Status}' google-chrome-stable 2>/dev/null | grep -qx 'install ok installed'; then
    run sudo apt-get install -y google-chrome-stable
  elif "$dry_run"; then
    echo '+ Download Google Chrome stable from dl.google.com to a temporary directory'
    echo '+ sudo apt-get install -y /tmp/<temporary-directory>/google-chrome-stable_current_amd64.deb'
  else
    download_dir=$(mktemp -d)
    trap 'rm -rf -- "$download_dir"' EXIT
    # Allow apt's download sandbox to read the local package.
    chmod 755 "$download_dir"
    run curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
      --output "$download_dir/google-chrome-stable_current_amd64.deb" \
      https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    chmod 644 "$download_dir/google-chrome-stable_current_amd64.deb"
    run sudo apt-get install -y "$download_dir/google-chrome-stable_current_amd64.deb"
  fi
fi

# Use the upstream-recommended stable Flatpak, under the desktop user's account.
# Do not silently reuse a remote with the same name but a different source.
if ! "$dry_run"; then
  remote_url=$(flatpak remotes --user --columns=name,url | awk '$1 == "flathub" {print $2}')
  if [[ -n $remote_url && $remote_url != https://dl.flathub.org/repo/ && $remote_url != https://dl.flathub.org/repo ]]; then
    printf 'Existing flathub remote has an unexpected URL: %s\n' "$remote_url" >&2
    exit 1
  fi
fi
run flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
run flatpak install --user --noninteractive flathub org.keepassxc.KeePassXC//stable
run flatpak update --user --noninteractive org.keepassxc.KeePassXC

install_snap() {
  local package=$1
  shift
  if command -v snap >/dev/null && snap list "$package" >/dev/null 2>&1; then
    run sudo snap refresh "$package" --channel=latest/stable
  else
    run sudo snap install "$package" --channel=latest/stable "$@"
  fi
}
if "$code"; then install_snap code --classic; fi
if "$spotify"; then install_snap spotify; fi

if "$dry_run"; then
  echo 'Preview complete. No changes made.'
else
  cat <<'DONE'
Setup complete. Log out and back in if Flatpak apps do not appear in the launcher.
Update KeePassXC in Software, or run:
  flatpak update --user org.keepassxc.KeePassXC
Inspect its installed permissions with:
  flatpak info --user --show-permissions org.keepassxc.KeePassXC
Existing password databases and other KeePassXC installations were not removed.
DONE
fi
