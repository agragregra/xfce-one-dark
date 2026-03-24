# Xfce One Dark Theme

One Dark theme for Xfce based on Arc-Dark.

## Installation

```
git clone https://github.com/agragregra/xfce-one-dark; cd xfce-one-dark; rm -rf .git; chmod +x run.sh;
```

```
sudo ./run.sh install
````

Then manually apply theme in Xfce:
- Settings -> Appearance -> Arc-Dark
- Settings -> Icons -> Papirus-Dark
- Settings -> Desktop -> Style: None -> Color: #1A1E23

## Usage

Add custom styles:
```
sudo ./run.sh add
```

Remove custom styles:
```
sudo ./run.sh remove
```

Uninstall theme and icons:
```
sudo ./run.sh uninstall
```

## Files

- `styles.css` - custom One Dark styles with color variables
- `run.sh` - installation manager script
- `gtk-main-dark.css` - original Arc-Dark theme file, used as reference
