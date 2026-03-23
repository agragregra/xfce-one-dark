#!/bin/bash

GTK_CSS="/usr/share/themes/Arc-Dark/gtk-3.0/gtk.css"
CURRENT_DIR="$(pwd)"
IMPORT_LINE="@import url(\"file://${CURRENT_DIR}/styles.css\");"

check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        exec sudo "$0" "$@"
    fi
}

add_import() {
    if [ ! -f "$GTK_CSS" ]; then
        echo "Error: $GTK_CSS not found"
        exit 1
    fi
    cp "$GTK_CSS" "${GTK_CSS}.backup"
    chmod 666 "$GTK_CSS"
    sed -i "1a\\
$IMPORT_LINE" "$GTK_CSS"
    echo "Added"
}

remove_import() {
    if [ ! -f "$GTK_CSS" ]; then
        echo "Error: $GTK_CSS not found"
        exit 1
    fi
    cp "$GTK_CSS" "${GTK_CSS}.backup"
    chmod 666 "$GTK_CSS"
    sed -i '2d' "$GTK_CSS"
    echo "Removed"
}

case "$1" in
    install)
        check_sudo "$@"
        apt update
        apt install -y arc-theme papirus-icon-theme
        echo "Installed Arc-Dark theme and Papirus-Dark icons"
        add_import
        echo ""
        echo "To apply theme in XFCE:"
        echo "1. Settings Manager -> Appearance -> Arc-Dark"
        echo "2. Settings Manager -> Icons -> Papirus-Dark"
        echo "3. Settings Manager -> Desktop -> Style: None -> Color: #1A1E23"
        ;;
    add)
        check_sudo "$@"
        add_import
        ;;
    remove)
        check_sudo "$@"
        remove_import
        ;;
    uninstall)
        check_sudo "$@"
        apt remove --purge arc-theme papirus-icon-theme -y
        ;;
    *)
        echo "Usage: ./run.sh {install|add|remove|uninstall}"
        exit 1
        ;;
esac
