# Personal Ubuntu setup

Desktop setup for Ubuntu 24.04 and 26.04 LTS. Chrome requires amd64;
use `--no-chrome` on other architectures. Run from your regular desktop account.

Download and inspect the script, then preview it before installing:

```bash
git clone https://github.com/pr0ton/scripts.git
cd scripts
less install.sh
bash install.sh --dry-run
bash install.sh
```

The script uses `sudo` for system packages and installs KeePassXC for your user.
Do not pipe the script into `sudo bash`: Flatpak would target root's account.

## What gets installed

- Git, GitHub CLI, SSH client, curl, compiler tools, CMake, the distribution's
  default JDK, Python 3, pip, venv, and pipx.
- exFAT utilities, FFmpeg, GIMP, Qalculate, and VLC.
- LaTeX tools, Google Chrome, VS Code, and Spotify.
- `ubuntu-restricted-extras` for additional codecs and fonts; font license
  acceptance remains interactive.
- KeePassXC from stable Flathub, plus GNOME Software's Flatpak integration.

Geany, Dropbox, and the obsolete Grive client are not installed. Java 8,
Python 2 pip, legacy exFAT FUSE tools, and old Chrome library names are replaced
with current packages. FFmpeg supplies media functionality without the old
standalone FAAC development libraries. Existing applications are not uninstalled.

## Options

Run `bash install.sh --help` for all options. For example:

```bash
bash install.sh --no-latex --no-spotify
```

LaTeX is large, so use `--no-latex` if you do not need it. Network file sharing
is opt-in via `--with-sharing`. Restricted codecs/fonts are included by default;
use `--no-restricted-extras` to skip them. Their font license prompt remains
interactive. The older `--with-restricted-extras` flag still works.

The script stops on errors, checks apt dependency resolution, and can be rerun.
It installs or updates selected packages; it does not do a full system upgrade,
change GitHub credentials, or overwrite password databases. VS Code's Snap uses
classic confinement, as required by its publisher.

## KeePassXC and updates

[KeePassXC recommends Flatpak](https://keepassxc.org/download/#linux).
Use the exact app ID `org.keepassxc.KeePassXC` from the official Flathub remote.
The script selects the stable branch, not development builds, and updates it
when rerun. Flatpak releases can occasionally trail upstream; check the installed
version in the app or with `flatpak info --user org.keepassxc.KeePassXC`.

GNOME Software provides update management. Flatpak CLI installation alone does
not schedule unattended updates. Review Software's automatic-update settings,
or update manually:

```bash
flatpak update --user org.keepassxc.KeePassXC
flatpak info --user --show-permissions org.keepassxc.KeePassXC
```

Flatpak is not a guarantee that an app is harmless. KeePassXC's stable package
requests broad filesystem, network, and device access for its integrations.
Use the official package and keep both the app and its runtime updated.
Browser integration may require additional setup; follow the
[official KeePassXC documentation](https://keepassxc.org/docs/).
If switching from Snap, verify your database opens and keep a backup before
removing the old installation yourself.

## Validation

The script has been checked with Bash syntax validation, ShellCheck, and apt's
simulated dependency resolution on Ubuntu 26.04. It has not been end-to-end
installed on a clean machine or validated on Ubuntu 24.04. A dry run prints
planned changes and does not validate remote downloads or package availability.
