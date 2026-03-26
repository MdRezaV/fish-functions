function yayR
    if test (count $argv) -eq 0
        echo "Usage: yayR <package_name>"
        return 1
    end
    yay -Rns $argv
end
