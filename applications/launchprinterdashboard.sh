SSID="CRAFT"
PASSWORD="CRAFT.wifi"


notify-send "HUSK WIFI" "virker kun på CRAFT WiFi"

# Check if we are already connected to the desired SSID
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)

if [ "$current_ssid" == "$SSID" ]; then
    echo "Already connected to $SSID"
else
    # Check if the desired SSID is available
    echo "Already connected to $current_ssid"
    available_ssid=$(nmcli -t -f ssid dev wifi | grep -x "$SSID")

    if [ "$available_ssid" == "$SSID" ]; then
        echo "Connecting to $SSID"
        nmcli dev wifi connect "$SSID" password "$PASSWORD"
        firefox http://192.168.8.23:1337
    else
        echo "SSID $SSID is not available"
    fi
fi