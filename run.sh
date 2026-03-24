#!/bin/bash

GTK_CSS="/usr/share/themes/Arc-Dark/gtk-3.0/gtk.css"
CURRENT_DIR="$(pwd)"
IMPORT_LINE="@import url(\"file://${CURRENT_DIR}/styles.css\");"

if command -v apt &> /dev/null; then
  PKG_MANAGER="apt"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
elif command -v pacman &> /dev/null; then
  PKG_MANAGER="pacman"
  INSTALL_CMD="pacman -Sy --noconfirm"
  REMOVE_CMD="pacman -Rns --noconfirm"
  THEME_PKG="arc-gtk-theme"
  ICON_PKG="papirus-icon-theme"
elif command -v dnf &> /dev/null; then
  PKG_MANAGER="dnf"
  INSTALL_CMD="dnf install -y"
  REMOVE_CMD="dnf remove -y"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
elif command -v zypper &> /dev/null; then
  PKG_MANAGER="zypper"
  INSTALL_CMD="zypper install -y"
  REMOVE_CMD="zypper remove -y"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
else
  echo "No supported package manager found"
  exit 1
fi

check_sudo() {
  if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
  fi
}

add_import() {
  chmod 666 "$GTK_CSS"
  sed -i "1a\\
$IMPORT_LINE" "$GTK_CSS"
  echo "Added"
}

remove_import() {
  chmod 666 "$GTK_CSS"
  sed -i '2d' "$GTK_CSS"
  echo "Removed"
}

case "$1" in
  install)
    check_sudo "$@"
    if [ "$PKG_MANAGER" = "apt" ]; then
      apt update
      apt install -y $THEME_PKG $ICON_PKG
    else
      $INSTALL_CMD $THEME_PKG $ICON_PKG
    fi
    add_import
    echo ""
    echo "To apply theme in XFCE:"
    echo "1. Settings -> Appearance -> Arc-Dark"
    echo "2. Settings -> Icons -> Papirus-Dark"
    echo "3. Settings -> Desktop -> Style: None -> Color: #1A1E23"
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
    if [ "$PKG_MANAGER" = "apt" ]; then
      apt remove --purge -y $THEME_PKG $ICON_PKG
    else
      $REMOVE_CMD $THEME_PKG $ICON_PKG
    fi
    ;;
  *)
    echo "Usage: ./run.sh {install|add|remove|uninstall}"
    exit 1
    ;;
esac
