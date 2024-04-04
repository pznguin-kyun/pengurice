<h1 align="center">✨ penguinRice ✨ </h1>
<p align="center">📜 A script that rice your Linux/*nix system.</p>

<p align="center">
    <a href="https://github.com/Haruzona/penguinRice/stargazers"><img src="https://img.shields.io/github/stars/Haruzona/penguinRice?style=for-the-badge&color=%23ff8989"></a>
    <a href="https://github.com/Haruzona/penguinRice/issues"><img src="https://img.shields.io/github/issues/Haruzona/penguinRice?style=for-the-badge&color=%23a978f6"></a>
    <a href="https://github.com/Haruzona/penguinRice/pulls"><img src="https://img.shields.io/github/issues-pr/Haruzona/penguinRice?style=for-the-badge&color=%23a978f6"></a>
    <a href="https://github.com/Haruzona/penguinRice/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Haruzona/penguinRice?style=for-the-badge&color=%23f2ff8a"></a>
</p>

# Table of Contents
- [About ⁉️](#about)
- [Gallery 📷](#gallery)
- [Installation 🛠️](#installation)
- [Keybindings ⌨️](#keybindings)
- [Credits 👨‍🔧](#credits)

# About
- Dotfiles: [penguinDotfiles](https://github.com/Haruzona/penguinDotfiles)
- Window Manager: [bspwm](https://github.com/baskerville/bspwm)
- Terminal: [Alacritty](https://alacritty.org/)
- Browser: [Librewolf](https://librewolf.net/)
- File Manager: [Ranger](https://ranger.github.io/)/[Nemo](https://github.com/linuxmint/nemo)
- Text Editor: [NeoVim](https://neovim.io)
- PDF Viewer: [Zathura](https://pwmt.org/projects/zathura/)
- RSS Reader: [Newsboat](https://newsboat.org/)
- Calendar: [Calcurse](https://www.calcurse.org/)
- Video player: [mpv](https://mpv.io)
- Music player: [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)
- Fetch: [neofetch](https://github.com/dylanaraps/neofetch)
- System monitor: [Htop](https://htop.dev)
- Manage screens: [ARandR](https://christian.amsuess.com/tools/arandr/)

# Gallery
| bloom                                          | catppuccin                                     | dracula                                       |
| :--------------------------------------------- | :--------------------------------------------- | :-------------------------------------------- |
| ![bloom](https://i.imgur.com/m0F9ZsP.png)      | ![catppuccin](https://i.imgur.com/x2J3zFt.png) | ![dracula](https://i.imgur.com/tDZ8VmE.png)   |
| everforest                                     | gruvbox                                        | macaroni                                      |
| ![everforest](https://i.imgur.com/6SEhR5f.png) | ![gruvbox](https://i.imgur.com/K1GlJk8.png)    | ![macaroni](https://i.imgur.com/6ReXidY.png)  |
| monochrome                                     | nord                                           | rosepine                                      |
| ![monochrome](https://i.imgur.com/y3tnFkw.png) | ![nord](https://i.imgur.com/CmhW7Jb.png)       | ![rosepine](https://i.imgur.com/16Y0WZT.png)  |
| snowy                                          | tokyonight                                     |
| ![snowy](https://i.imgur.com/YnxsCFS.png)      | ![tokyonight](https://i.imgur.com/DgYvmt4.png) |

# Installation
## Distros
- Arch Linux and Arch-based distros (EndeavourOS, Artix Linux, Arco Linux, ArchCraft, ...)
- RedHat-based distros (RHEL, Fedora, Nobara, ...)
- Debian and Debian-based distros (Ubuntu, Pop! OS, ...)
- SUSE and openSUSE
- Void Linux

## Install with git
```
git clone --depth 1 https://github.com/Haruzona/penguinRice
cd penguinRice
./penguinrice.sh
```

## Install with curl
```
curl -LO https://raw.githubusercontent.com/Haruzona/penguinRice/main/penguinrice.sh
bash penguinrice-linux.sh
```

## Install manually
Read [penguinDotfiles's README](https://github.com/Haruzona/penguinDotfiles) for more information

## Some notes
- If your system doesn't have `bash`, install it
- Tested on latest Arch Linux, Fedora 38, Debian 12, Ubuntu 23.04, OpenSUSE Tumbleweed, latest Void Linux.
- This script MUST BE run as root
- If you dont have display manager (or login manager), you can login with xinit.
```
startx
```

# Keybindings
These are the basic keybinds. Read through the `bspwm/config/keys` file for more keybinds like increasing gaps and restoring gaps.
> Note: Super = Windows key

| Keys                                              | Function                          |
| :------------------------------------------------ | :-------------------------------- |
| `Super + Enter`                                   | Launch terminal (alacritty)       |
| `Super + Q`                                       | Close window                      |
| `Super + Alt + R`                                 | Restart window manager (bspwm)    |
| `Super + D`                                       | Open launcher (rofi)              |
| `Super + BackSpace`                               | Open powermenu                    |
| `Super + X`                                       | Open menu                         |
| `Super + Tab`                                     | Open window menu                  |
| `Super + Shift + C`                               | Open colorscheme changer          |
| `Super + Delete`                                  | Screenshot menu                   |
| `Super + Shift + B`                               | Toggle bar (polybar)              |
| `Super + Shift + P`                               | Toggle compositor (picom)         |
| `Super + T/Shift + T/F/S/`                        | Tile/Pseudo Tile/Float/Fullscreen |
| `Super + R`                                       | Rotate window                     |
| `Super + H/J/K/L or Left/Down/Up/Right`           | Change Focus                      |
| `Super + Shift + H/J/K/L or Left/Down/Up/Right`   | Move window                       |

# Credits
- [Contributors](https://github.com/Haruzona/penguinRice/graphs/contributors)
- Some people on Discord

<h1 align="center">🌟 Good Luck and Seeya! 🌟</h1>
