#!/bin/bash

GTK_CSS="/usr/share/themes/Arc-Dark/gtk-3.0/gtk.css"
CURRENT_DIR="$(pwd)"
IMPORT_LINE="@import url(\"file://${CURRENT_DIR}/styles.css\");"

# Определяем команды для пакетного менеджера
if command -v apt &> /dev/null; then
  INSTALL_CMD="apt update && apt install -y"
  REMOVE_CMD="apt remove --purge -y"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
  FONT_PKG="fonts-noto-core"
elif command -v pacman &> /dev/null; then
  INSTALL_CMD="pacman -Sy --noconfirm"
  REMOVE_CMD="pacman -Rns --noconfirm"
  THEME_PKG="arc-gtk-theme"
  ICON_PKG="papirus-icon-theme"
  FONT_PKG="noto-fonts"
elif command -v dnf &> /dev/null; then
  INSTALL_CMD="dnf install -y"
  REMOVE_CMD="dnf remove -y"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
  FONT_PKG="google-noto-sans-fonts"
elif command -v zypper &> /dev/null; then
  INSTALL_CMD="zypper install -y"
  REMOVE_CMD="zypper remove -y"
  THEME_PKG="arc-theme"
  ICON_PKG="papirus-icon-theme"
  FONT_PKG="google-noto-fonts"
else
  echo "No supported package manager found"
  exit 1
fi

check_sudo() {
  [ "$EUID" -ne 0 ] && exec sudo "$0" "$@"
}

add_import() {
  chmod 666 "$GTK_CSS"
  if ! grep -q "styles.css" "$GTK_CSS"; then
    sed -i "1a\\$IMPORT_LINE" "$GTK_CSS"
    echo "Added"
  else
    echo "Already exists"
  fi
}

remove_import() {
  chmod 666 "$GTK_CSS"
  if grep -q "styles.css" "$GTK_CSS"; then
    sed -i "/styles.css/d" "$GTK_CSS"
    echo "Removed"
  else
    echo "Not found"
  fi
}

case "$1" in
  install)
    check_sudo "$@"
    eval "$INSTALL_CMD $THEME_PKG $ICON_PKG $FONT_PKG"
    add_import
    echo -e "\nTo apply theme in XFCE:"
    echo "1. Settings -> Appearance -> Arc-Dark"
    echo "3. Settings -> Appearance -> Fonts -> Default Font -> Noto Sans Regular 9"
    echo "2. Settings -> Icons -> Papirus-Dark"
    echo "4. Settings -> Desktop -> Style: None -> Color: #1A1E23"
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
    eval "$REMOVE_CMD $THEME_PKG $ICON_PKG"
    ;;
  *)
    echo "Usage: ./run.sh {install|add|remove|uninstall}"
    exit 1
    ;;
esac
