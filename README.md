# Fish Shell Functions for Arch Linux

A collection of Fish shell functions designed to streamline common tasks on Arch Linux and its derivatives (such as EndeavourOS or Manjaro). These functions simplify package management, system cleanup, network diagnostics, and other routine operations.

## Installation

1. **Install Fish Shell** (if not already installed):
   ```
   sudo pacman -S fish
   ```

2. **Clone this repository** and copy the `.fish` files into the Fish functions directory:
   ```
   git clone https://github.com/MdRezaV/fish-functions.git
   cp fish-functions/*.fish ~/.config/fish/functions/
   ```

3. **Reload Fish** by restarting your terminal or running:
   ```
   exec fish
   ```

> **Note**: Some functions require external tools (e.g., `aria2c`, `jq`, `mmdblookup`, `yay`). Install them as needed using pacman or the AUR.

---

## Function Descriptions

### `cleanarch`
Performs an aggressive system cleanup. It removes orphaned packages, deletes all pacman cache (`pacman -Scc`), purges AUR build directories, flushes flatpak leftovers, cleans user caches (pip, npm, cargo, conda), empties system journal logs, removes core dumps, deletes empty directories (targeting app data and development folders), and removes broken symlinks. Optional commented sections allow for Docker system prune and Timeshift snapshot deletion. Use with caution as it clears many caches permanently.

**Example**: `cleanarch`

### `download`
A wrapper around `aria2c` with optimized settings for high‑speed downloads. It uses 16 parallel connections, 1 MiB chunks, and enables asynchronous DNS. The function accepts a URL and optional flags:
- `-t, --torrent` : download a torrent or magnet link.
- `-d, --dir <path>` : specify the download directory.
- `-o, --out <name>` : specify the output filename.

**Example**: `download -d ~/Downloads -o archive.zip https://example.com/file.zip`

### `iploc`
Geolocates an IP address or domain using MaxMind GeoLite2 databases. It resolves a domain to an IP if needed, then queries the ASN and City databases to display the organization, AS number, city, country, country code, coordinates, and time zone.

**Database installation**: The function expects the databases at `~/v2/GeoLite2-ASN.mmdb` and `~/v2/GeoLite2-City.mmdb`. A convenient source is the [P3TERX/GeoLite.mmdb](https://github.com/P3TERX/GeoLite.mmdb) repository, which provides automated updates.

**Example**: `iploc 8.8.8.8` or `iploc github.com`

### `myip`
Queries `https://ipconfig.io/json` to retrieve the public IP address, country, city, coordinates, time zone, ASN, and ASN organization. Uses `curl` and `jq`.

**Example**: `myip`

### `packey`
Updates the Arch Linux keyring by updating the `archlinux-keyring` package, refreshing keys from servers, and populating the Arch Linux keys. Useful when encountering PGP signature errors.

**Example**: `packey`

### `pacls`
Lists all explicitly installed packages (i.e., packages installed directly by the user, not as dependencies). Uses `pacman -Qeq`.

**Example**: `pacls`

### `pacR`
Removes a specified package along with its dependencies that are no longer required (`pacman -Rns`).

**Example**: `pacR firefox`

### `pacS`
Installs a specified package (`pacman -S`).

**Example**: `pacS firefox`

### `pacu`
Performs a full system upgrade (`pacman -Syu`).

**Example**: `pacu`

### `py`
A simple alias for the `python` command.

**Example**: `py -m http.server 8000`

### `useproxy`
Runs any command with HTTP and HTTPS proxy environment variables set to `http://127.0.0.1:10808`. Proxy settings only affect the command being executed.

**Example**: `useproxy curl ifconfig.me`

### `yayls`
Lists all foreign (AUR) packages installed via `yay` (`yay -Qmq`).

**Example**: `yayls`

### `yayR`
Removes a specified AUR package along with its dependencies that are no longer required (`yay -Rns`).

**Example**: `yayR google-chrome`

### `yayS`
Installs a specified AUR package (`yay -S`).

**Example**: `yayS google-chrome`

### `yayu`
Performs a full system upgrade that includes both official repository packages and AUR packages (`yay -Syu`).

**Example**: `yayu`

---

## Important Notes

- **`cleanarch`** is intentionally aggressive. It removes all pacman cache, all orphaned packages, and many user cache directories. Review its actions before execution.
- **`iploc`** requires the MaxMind GeoLite2 databases (see **Database installation** under the `iploc` description).
- Some functions depend on external tools (`aria2c`, `jq`, `mmdblookup`, `yay`). Install them via pacman or the AUR as needed.
- The `download` function uses aggressive parallel settings; adjust them if your network or hardware experiences issues.

---

## Customization

You can modify these functions to suit your workflow. For example:
- Change the proxy address in `useproxy` to match your local proxy configuration.
- Adjust the number of parallel connections in `download`.
- Comment or uncomment optional sections in `cleanarch` (such as Docker pruning or Timeshift snapshots).

---

## License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file in the repository for details.

---

## Contributing

If you have improvements or additional functions you find useful, you are welcome to submit a pull request or share your suggestions.
