function pacS
    if test (count $argv) -eq 0
        echo "Usage: pacS <package_name>"
        return 1
    end
    sudo pacman -S $argv
end
