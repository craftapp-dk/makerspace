#!/bin/bash

# List of Flatpak apps to install
flatpak_apps=("org.blender.Blender" "org.godotengine.Godot" "com.prusa3d.PrusaSlicer" "org.kde.krita" "org.inkscape.Inkscape" "org.freecadweb.FreeCAD" "com.vscodium.codium" "io.github.f3d_app.f3d" "com.github.muriloventuroso.easyssh" "org.filezillaproject.Filezilla" "org.raspberrypi.rpi-imager" "org.audacityteam.Audacity" "org.videolan.VLC" "org.leocad.LeoCAD" "com.github.k4zmu2a.spacecadetpinball" "com.shatteredpixel.shatteredpixeldungeon" "net.minetest.Minetest" "org.gnome.Chess" "io.mgba.mGBA"  "io.thp.numptyphysics" "pl.youkai.nscan" "com.boxy_svg.BoxySVG")

# List of APT packages to install
apt_packages=("qimgv" "gnome-tweaks" "dwarf-fortress" "python-is-python3" "openssh-server" "libnotify-bin")

lightburn="https://github.com/LightBurnSoftware/deployment/releases/download/1.6.01/LightBurn-Linux64-v1.6.01.run"
physical_printers="https://github.com/craftapp-dk/makerspace/raw/main/configs/printerconfig.zip"
icons="https://github.com/craftapp-dk/makerspace/raw/main/icons/icons.zip"
shortcuts="https://github.com/craftapp-dk/makerspace/raw/main/applications/shortcuts.zip"
deskenv="https://raw.githubusercontent.com/craftapp-dk/makerspace/main/configs/deskenv.conf"

# Check if Flatpak is installed
check_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        echo "Flatpak is not installed. Installing Flatpak..."
        sudo apt install -y flatpak
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        echo "Flatpak is already installed."
    fi
}

# Install Flatpak apps
install_flatpak_apps() {
    for app in "${flatpak_apps[@]}"; do
        echo "Installing $app..."
        flatpak install -y $app
        echo "-------------------------------------"
    done
}

# Install APT packages
install_apt_packages() {
    sudo apt update
    for package in "${apt_packages[@]}"; do
        echo "Installing $package..."
        sudo apt install -y $package
        echo "-------------------------------------"
    done
}

# Download and execute LightBurn AppImage
install_lightburn() {
    echo "Downloading Lightburn..."
    curl -fsSL  | bash
    wget --no-check-certificate $lightburn -O /tmp/lightburn.run
    chmod u+x /tmp/lightburn.run
    bash /tmp/lightburn.run
    rm /tmp/lightburn.run
    echo "Lightburn installed"
}

# Download and install bun (nodejs/npm alternative)
install_bun() {
    echo "Downloading bun..."
    curl -fsSL https://bun.sh/install | bash
    echo "bun installed"
}

# Setup 3D printer configs
install_3D_printers(){
    echo "Installing 3D Printers"
    config_dir="$HOME/.var/app/com.prusa3d.PrusaSlicer/config/PrusaSlicer/"
    wget --no-check-certificate "$physical_printers" -O /tmp/printerconfig.zip
    unzip /tmp/printerconfig.zip -d "$config_dir"
    rm /tmp/printerconfig.zip
    echo "3D Printers installed"
}

# Setup webapp url shortcuts as applications
create_shortcuts(){
    echo "Creating shortcuts"

    icons_dir="$HOME/.icons/"
    shortcuts_dir="$HOME/.local/share/applications/"

    wget --no-check-certificate "$icons" -O /tmp/icons.zip
    unzip /tmp/icons.zip -d "$icons_dir"
    rm /tmp/icons.zip

    wget --no-check-certificate "$shortcuts" -O /tmp/shortcuts.zip
    unzip /tmp/shortcuts.zip -d "$shortcuts_dir"
    rm /tmp/shortcuts.zip

    echo "Shortcuts created"
}

install_config(){
    wget --no-check-certificate "$deskenv" -O deskenv.conf
    dconf load / < deskenv.conf
}

create_folders(){
    mkdir "$HOME/3D Objects/"
    mkdir "$HOME/Code/"
    mkdir "$HOME/Students/"
    mkdir "$HOME/CTF/"
    install -D <(echo 1) $HOME/.var/app/com.prusa3d.PrusaSlicer/config/PrusaSlicer/emilerawesome.txt
}

# Main script
create_folders
check_flatpak
install_flatpak_apps
install_apt_packages
install_bun
install_lightburn
install_3D_printers
create_shortcuts
install_config

echo "Installation script complete."
