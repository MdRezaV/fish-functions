function myip
    set -l json (curl -s --max-time 5 https://ipconfig.io/json)
    
    if test -z "$json"
        echo "⚠️  Failed to retrieve IP info" >&2
        return 1
    end
    
    set -l ip (echo $json | jq -r '.ip')
    set -l country (echo $json | jq -r '.country')
    set -l country_iso (echo $json | jq -r '.country_iso')
    set -l city (echo $json | jq -r '.city')
    set -l lat (echo $json | jq -r '.latitude')
    set -l lon (echo $json | jq -r '.longitude')
    set -l tz (echo $json | jq -r '.time_zone')
    set -l asn (echo $json | jq -r '.asn')
    set -l asn_org (echo $json | jq -r '.asn_org')
    
    echo "  🏷️ IP       : $ip"
    echo "  📍 Location : $country ($country_iso), $city, (lat $lat lon $lon)"
    echo "  📡 ASN      : $asn ($asn_org)"
    echo ""
end