function packey
    echo "🔑 Updating Arch Linux Keyrings..."
    
    # 1. Update the keyring package first (most reliable method)
    echo "➜ Updating archlinux-keyring package..."
    sudo pacman -Sy archlinux-keyring
    if test $status -ne 0
        echo "❌ Failed to update keyring package."
        return 1
    end

    # 2. Refresh keys from keyservers (may take time)
    echo "➜ Refreshing keys from servers..."
    sudo pacman-key --refresh-keys
    if test $status -ne 0
        echo "⚠️  Key refresh failed (servers might be down), continuing..."
    end

    # 3. Populate the keys into the trust database
    echo "➜ Populating archlinux keys..."
    sudo pacman-key --populate archlinux
    if test $status -ne 0
        echo "❌ Failed to populate keys."
        return 1
    end

    echo "✅ Keyring update complete!"
end
