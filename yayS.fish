function yayS
    if test (count $argv) -eq 0
        echo "Usage: yayS <package_name>"
        return 1
    end
    yay -S $argv
end
