<h1 align="center">penguinRice</h1>
<p align="center">A script that rice your Linux/*nix system.</a>
<p>
  <div align="center">
    <a href="#details">Details</a> -  
    <a href="#gallery">Gallery</a> - 
    <a href="#installation">Install</a> - 
    <a href="#credits">Credits</a>
  </div>
</p>
penguinRice is for people who want to use a simple but fully functional Linux setup.

# Details
<img src="https://i.imgur.com/6ReXidY.png" alt="penguinrice" align="right" height="240px">

- Dotfiles: [penguinDotfiles](https://github.com/p3nguin-kun/penguinDotfiles)
- Window Manager: [bspwm](https://github.com/baskerville/bspwm)
- Terminal: [alacritty](https://alacritty.org/)
- Browser: [firefox](https://www.mozilla.org/en-US/firefox)
- File Manager: [ranger](https://ranger.github.io/)/[pcmanfm](https://github.com/lxde/pcmanfm)
- Text Editor: [neovim](https://neovim.io)
- PDF Viewer: [zathura](https://pwmt.org/projects/zathura/)
- Calendar: [calcurse](https://www.calcurse.org/)
- Video player: [mpv](https://mpv.io)
- Music player: [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)
- Fetch: [neofetch](https://github.com/dylanaraps/neofetch)
- System monitor: [htop](https://htop.dev)
- Manage screens: [arandr](https://christian.amsuess.com/tools/arandr/)

# Gallery
<details>
<summary>Click to preview</summary>

| bloom                                          | catppuccin                                     | dracula                                       |
| :--------------------------------------------- | :--------------------------------------------- | :-------------------------------------------- |
| ![bloom](https://i.imgur.com/m0F9ZsP.png)      | ![catppuccin](https://i.imgur.com/x2J3zFt.png) | ![dracula](https://i.imgur.com/tDZ8VmE.png)   |
| everforest                                     | gruvbox                                        | macaroni                                      |
| ![everforest](https://i.imgur.com/6SEhR5f.png) | ![gruvbox](https://i.imgur.com/K1GlJk8.png)    | ![macaroni](https://i.imgur.com/6ReXidY.png)  |
| monochrome                                     | nord                                           | rosepine                                      |
| ![monochrome](https://i.imgur.com/y3tnFkw.png) | ![nord](https://i.imgur.com/CmhW7Jb.png)       | ![rosepine](https://i.imgur.com/16Y0WZT.png)  |
| snowy                                          | tokyonight                                     | vaporwave                                     |
| ![snowy](https://i.imgur.com/YnxsCFS.png)      | ![tokyonight](https://i.imgur.com/DgYvmt4.png) | ![vaporwave](https://i.imgur.com/xyvSKMN.png) |

</details>

# Installation
## Distros
- Arch Linux and Arch-based distros (EndeavourOS, Artix Linux, Arco Linux, ArchCraft, ...)
- RedHat-based distros (RHEL, Fedora, Nobara, ...)
- Debian and Debian-based distros (Ubuntu, Pop! OS, ...)
- SUSE and openSUSE
- Void Linux

## Install with git
```
git clone --depth 1 https://github.com/p3nguin-kun/penguinRice
cd penguinRice
root: ./penguinrice-linux.sh
user: sudo ./penguinrice-linux.sh or su -c 'penguinrice-linux.sh'
```

## Install with curl
```
curl -sSL https://raw.githubusercontent.com/p3nguin-kun/penguinRice/main/penguinrice-linux.sh
root: ./penguinrice-linux.sh
user: sudo ./penguinrice-linux.sh or su -c './penguinrice-linux.sh'
```

## Some notes
- If your system doesn't have `bash`, install it
- Tested on archlinux latest, fedora 38, debian 12, ubuntu 23.04, opensuse tumbleweed, voidlinux latest.
- This script MUST BE run as root
- If you dont have display manager (or login manager), you can login with xinit.
```
startx
```

#  References


# Credits
- [Contributors](https://github.com/p3nguin-kun/penguinRice/graphs/contributors)
- Some people on Discord
- [penguinFox](https://github.com/p3nguin-kun/penguinFox): Firefox config
- [mvim](https://github.com/p3nguin-kun/mvim): NeoVim config

# Contributions
1. Fork this project.
2. Edit files
3. Make a pull request.