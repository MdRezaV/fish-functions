# ~/.config/fish/functions/useproxy.fish

function useproxy --description 'Run any command with proxy (127.0.0.1:10808)'
    # Configure proxy: socks5://, http://, or socks5h:// (remote DNS)
    set -l PROXY "http://127.0.0.1:10808"
    
    # Set exported *local* variables - they apply to child processes only
    set -lx http_proxy $PROXY
    set -lx https_proxy $PROXY
    set -lx all_proxy $PROXY
    set -lx no_proxy "127.0.0.1,localhost"
    
    # Run the command in current shell context (supports functions/aliases)
    if test (count $argv) -gt 0
        $argv
    else
        echo "Usage: useproxy <command> [args...]" >&2
        return 1
    end
end