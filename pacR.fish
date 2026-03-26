function pacR
    if test (count $argv) -eq 0
        echo "Usage: pacR <package_name>"
        return 1
    end
    sudo pacman -Rns $argv
end
