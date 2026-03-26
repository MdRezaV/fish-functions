function download
    set -l usage "Usage: download [OPTIONS] <URL>"
    set -l example "Example: download https://example.com/file.zip"
    
    if test -z $argv[1]
        echo $usage
        echo $example
        echo ""
        echo "Options:"
        echo "  -t, --torrent    Download torrent/magnet link"
        echo "  -d, --dir <path> Specify download directory"
        echo "  -o, --out <name> Specify output filename"
        echo "  -h, --help       Show this help"
        return 1
    end

    # Default aria2c options for speed
    set -l opts -x 16 -s 16 -k 1M --async-dns=true --max-connection-per-server=16

    # Parse arguments
    while set -q argv[1]
        switch $argv[1]
            case -t --torrent
                set opts $opts --follow-torrent=true
            case -d --dir
                set opts $opts -d $argv[2]
                set -e argv[1]
                set -e argv[1]
                continue
            case -o --out
                set opts $opts -o $argv[2]
                set -e argv[1]
                set -e argv[1]
                continue
            case -h --help
                echo $usage
                echo $example
                return 0
            case '*'
                break
        end
        set -e argv[1]
    end

    aria2c $opts $argv
end