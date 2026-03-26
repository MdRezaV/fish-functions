function cleanarch --description "Aggressive Arch Linux system cleanup"
    set -l keep_journal_days 3

    echo "🔍 Starting system cleanup..."

    # 1. Cache Sudo Credentials (ask once)
    sudo -v 2>/dev/null

    # 2. Pacman Cleanup - Orphaned packages
    set -l orphans (pacman -Qtdq 2>/dev/null)
    if test -n "$orphans"
        sudo pacman -Rns $orphans --noconfirm
    end

    # 3. Pacman Cache - Remove ALL (keep nothing)
    echo "y" | sudo pacman -Scc 2>/dev/null

    # 4. Yay/AUR Cleanup
    yay -Yc --noconfirm 2>/dev/null
    # Clean AUR build directories (source code leftovers)
    if test -d ~/.cache/yay
        rm -rf ~/.cache/yay
    end
    mkdir -p ~/.cache/yay

    # 5. Flatpak Cleanup (With error handling)
    if command -v flatpak >/dev/null 2>&1
        if test -d ~/.local/share/flatpak/repo
            flatpak uninstall --unused -y 2>/dev/null
            flatpak repair --user 2>/dev/null
        end
    end

    # 6. System Journal Logs
    if command -v journalctl >/dev/null 2>&1
        sudo journalctl --vacuum-time="$keep_journal_days"d 2>/dev/null
    end

    # 7. Core Dumps (Crash reports)
    if test -d /var/lib/systemd/coredump
        sudo rm -rf /var/lib/systemd/coredump 2>/dev/null
        mkdir -p /var/lib/systemd/coredump 2>/dev/null
    end

    # 8. Temporary Files (System)
    if command -v systemd-tmpfiles >/dev/null 2>&1
        systemd-tmpfiles --clean --user 2>/dev/null
        sudo systemd-tmpfiles --clean 2>/dev/null
    end

    # 9. User Cache Cleanup (General)
    # Thumbnails
    if test -d ~/.cache/thumbnails
        rm -rf ~/.cache/thumbnails
        mkdir -p ~/.cache/thumbnails
    end
    # Fontconfig
    if test -d ~/.cache/fontconfig
        rm -rf ~/.cache/fontconfig
    end

    # 10. 🆕 Developer Environment Caches (Conda, Pip, Npm, Cargo)
    echo "🛠️  Cleaning developer tool caches..."
    
    # Conda / Mamba
    if command -v conda >/dev/null 2>&1
        conda clean --all --yes 2>/dev/null
    else if command -v mamba >/dev/null 2>&1
        mamba clean --all --yes 2>/dev/null
    end

    # Python (pip)
    if test -d ~/.cache/pip
        rm -rf ~/.cache/pip
        mkdir -p ~/.cache/pip
    end

    # Node.js (npm & yarn)
    if command -v npm >/dev/null 2>&1
        npm cache clean --force 2>/dev/null
    end
    if test -d ~/.cache/yarn
        rm -rf ~/.cache/yarn
        mkdir -p ~/.cache/yarn
    end
    if test -d ~/.node-gyp
        rm -rf ~/.node-gyp
        mkdir -p ~/.node-gyp
    end

    # Rust (Cargo)
    if test -d ~/.cargo/registry/cache
        rm -rf ~/.cargo/registry/cache
        mkdir -p ~/.cargo/registry/cache
    end

    # 11. Trash Emptying
    if test -d ~/.local/share/Trash
        rm -rf ~/.local/share/Trash
        mkdir -p ~/.local/share/Trash
    end

    # 12. Snap Cache (If installed)
    if test -d /var/lib/snapd/cache
        sudo rm -rf /var/lib/snapd/cache
        sudo mkdir -p /var/lib/snapd/cache
    end
    # 13. 🆕 Remove Empty Directories (Targeted & Safe)
    echo "🧹 Removing empty directories (App Data & Dev Tools)..."

    # A. Comprehensive List of Safe App/Dev Data Paths
    # These locations are designed for cache, config, and build artifacts.
    # Empty folders here are usually leftovers from uninstalled apps or cleaned caches.
    set -l app_data_paths \
        ~/.cache \
        ~/.config \
        ~/.local/share \
        ~/.local/state \
        ~/.npm \
        ~/.node-gyp \
        ~/.cargo \
        ~/.conda \
        ~/.miniconda3 \
        ~/.m2 \
        ~/.gradle \
        ~/.java \
        ~/.texlive \
        ~/.android \
        ~/.kube \
        ~/.elixir \
        ~/.hex \
        ~/.pub-cache \
        ~/.gem \
        ~/.bundle \
        ~/.composer \
        ~/.nuget \
        ~/.steam/steamapps/shadercache \
        ~/.thumbnails \
        ~/.local/bin \
        ~/.local/lib

    for path in $app_data_paths
        if test -d "$path"
            # -mindepth 1 ensures we don't delete the root folder itself (e.g., .config)
            # -type d -empty finds only empty directories
            find "$path" -mindepth 1 -type d -empty -delete 2>/dev/null
        end
    end

    # B. Home Root (~/) - Highly Restricted
    # We clean empty folders in ~, BUT we protect specific user data folders.
    set -l protected_home_folders \
        "$HOME/Documents" \
        "$HOME/Projects" \
        "$HOME/Notes" \
        "$HOME/Desktop" \
        "$HOME/Downloads" \
        "$HOME/Pictures" \
        "$HOME/Videos" \
        "$HOME/Music" \
        "$HOME/Work" \
        "$HOME/Code" \
        "$HOME/Git" \
        "$HOME/Repositories" \
        "$HOME/Sync" \
        "$HOME/Public"

    # Build find exclusion arguments dynamically
    set -l exclude_args
    for folder in $protected_home_folders
        if test -d "$folder"
            # Exclude the folder itself AND anything inside it
            set -a exclude_args ! -path "$folder" ! -path "$folder/*"
        end
    end

    # Run find on home, excluding protected folders
    # -maxdepth 3 prevents traversing too deep into potential project structures
    find ~ -mindepth 1 -maxdepth 3 -type d -empty $exclude_args -delete 2>/dev/null

    # 14. 🆕 Remove Broken Symlinks (Safe)
    echo "🔗 Removing broken symlinks..."
    find ~/.cache -xtype l -delete 2>/dev/null
    find ~/.local -xtype l -delete 2>/dev/null

    # 15. 🆕 Optional: Clean Config Backups (Commented out by default)
    # echo "🗑️  Removing config backups..."
    # find ~ -maxdepth 3 -type f \( -name "*.bak" -o -name "*.old" -o -name "*~" \) -delete 2>/dev/null

    # 16. 🆕 Optional: Timeshift Snapshots (Commented out by default)
    # ⚠️ WARNING: This deletes ALL restore points!
    # if command -v timeshift >/dev/null 2>&1
    #     sudo timeshift --delete-all --yes
    # end

    # 17. 🆕 Optional: Docker Prune (Commented out by default)
    # ⚠️ WARNING: Removes unused containers, networks, and dangling images
    # if command -v docker >/dev/null 2>&1
    #     docker system prune -f 2>/dev/null
    # end

    echo "✅ Cleanup complete!"
end