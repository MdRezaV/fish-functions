function iploc --description 'Locate IP or Domain with a Deep Space theme'
    set -l target $argv[1]
    
    # --- Configuration ---
    set -l asn_db "$HOME/v2/GeoLite2-ASN.mmdb"
    set -l city_db "$HOME/v2/GeoLite2-City.mmdb"

    # --- Validate DB files ---
    if not test -f "$asn_db"; or not test -f "$city_db"
        echo (set_color brred)"✖ Error: GeoLite2 databases not found."(set_color normal)
        return 1
    end

    if test -z "$target"
        echo (set_color brred)"✖ Error: Mission control requires an IP or Domain."(set_color normal)
        return 1
    end

    # --- Domain Resolution ---
    set -l ip $target
    if not string match -qr '^\d{1,3}(\.\d{1,3}){3}$' $target
        set ip (dig +short $target | tail -n1)
        if test -z "$ip"
            echo (set_color brred)"📡 Error: Host '$target' not found in this sector."(set_color normal)
            return 1
        end
    end

    # Helper to extract clean values (remove type annotations and trim)
    function _get_val
        set -l result (mmdblookup --file $argv[1] --ip $argv[2] $argv[3..-1] 2>/dev/null)
        echo $result | sed -E 's/.*"([^"]+)".*/\1/; s/ <[^>]+>//g; s/^[[:space:]]+//; s/[[:space:]]+$//' | head -n 1
    end

    # --- Data Gathering ---
    set -l org     (_get_val $asn_db $ip autonomous_system_organization)
    set -l asn     (_get_val $asn_db $ip autonomous_system_number)
    set -l city    (_get_val $city_db $ip city names en)
    set -l country (_get_val $city_db $ip country names en)
    set -l code    (_get_val $city_db $ip country iso_code)
    set -l lat     (_get_val $city_db $ip location latitude)
    set -l lon     (_get_val $city_db $ip location longitude)
    set -l tz      (_get_val $city_db $ip location time_zone)

    # --- Location Logic ---
    set -l loc_parts
    test -n "$city"; and set -a loc_parts "$city"
    test -n "$country"; and set -a loc_parts "$country"
    set -l loc_str (string join ", " $loc_parts)
    if test -n "$code"
        set loc_str "$loc_str "(set_color brblack)"($code)"(set_color normal)
    end

    # --- Deep Space Aligned Output ---
    printf "%s %b%-12s%b %b%s%b\n" "☄️" (set_color brblue) "Target IP:"  (set_color normal) (set_color brcyan) "$ip" (set_color normal)
    printf "%s %b%-12s%b %b%s%b %b(AS%s)%b\n" "🪐" (set_color brblue) "ASN/Org:" (set_color normal) (set_color white) "$org" (set_color normal) (set_color brblue) "$asn" (set_color normal)
    printf "%s %b%-12s%b %b%s%b\n" "🌍" (set_color brblue) "Sector:"    (set_color normal) (set_color white) "$loc_str" (set_color normal)
    
    if test -n "$lat"
        printf "%s %b%-12s%b %b%s, %s%b\n" "🔭" (set_color brblue) "Position:" (set_color normal) (set_color white) "$lat" "$lon" (set_color normal)
        printf "%s %b%-12s%b %b%s%b\n" "🌑" (set_color brblue) "Timezone:" (set_color normal) (set_color white) "$tz" (set_color normal)
    end
end