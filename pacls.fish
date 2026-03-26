function pacls
    # -Q: Query
    # -e: Explicitly installed (not dependencies)
    # -q: Quiet (show package names only, no versions)
    pacman -Qeq
end
