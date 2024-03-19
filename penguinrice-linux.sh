#!/usr/bin/env bash

# penguinRice: p3nguin-kun's auto rice script
# by p3nguin-kun <p3nguinkun@proton.me>
# See LICENSE file for copyright and license details.
# To understand everything else, start reading main().

# consts
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
BLD=$(tput bold)
CNC=$(tput sgr0)

# vars
date=$(date +%Y%m%d-%H%M%S)
git_repo="https://github.com/p3nguin-kun/penguinDotfiles"
branch="bspwm"

# functions

logo() {
	local text="${1:?}"
	# shellcheck disable=SC2183
	printf '%s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}"
}

root_checking(){
if [ ! "$(id -u)" = 0 ]; then
	echo "This script MUST BE run as root."
	exit 1
fi
}

intro(){
    logo "Welcome!"
printf '%s%sWelcome to penguinRice!\nThis script will automatically install fully-featured tiling window manager-based system on any Linux system.\nMy dotfiles DO NOT modify any of your system configuration.\nYou will be prompted for your root password to install missing dependencies.\nThis script doesnt have potential power to break your system, it only copies files from my repo to your HOME directory. %s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
	read -rp " Do you want to continue? [Y/n]: " yn
	case $yn in
	[Nn]*) exit ;;
	*) break ;;
	esac
done
}

read_username(){
    read -rp "First, type your username here: " username
}

check_distro(){
  if command -v pacman &>/dev/null; then
    distro="nyarch"
  elif command -v apt &>/dev/null; then
    distro="debnyan"
  elif command -v dnf &>/dev/null; then
    distro="fedornya"
  elif command -v zypper &>/dev/null; then
    distro="sus"
  elif command -v xbps-install &>/dev/null; then
    distro="vowoid"
  fi
}

update(){
    logo "Updating system"
    case $distro in
      nyarch) 
        rm -rf /var/lib/pacman/db.lck
        case "$(readlink -f /sbin/init)" in
	      *systemd*)
          pacman -Sy --noconfirm --needed archlinux-keyring ;;
        *)
          pacman --noconfirm --needed -Sy artix-keyring artix-archlinux-support ;;
        esac
        pacman -Syyuu --noconfirm ;;
      debnyan) apt update -y && apt upgrade -y ;;
      fedornya) dnf update -y ;;
      sus) zypper dup -y ;;
      vowoid) xbps-install -Syu ;;
    esac
}

setup_before_install(){
    logo "Setup before install"
    case "$distro" in
    nyarch)
        pacman -Sy --noconfirm --needed curl git base-devel
        case "$(readlink -f /sbin/init)" in
	      *systemd*) return ;;
	      *)
		    logo "Enabling Arch Repositories"
		    grep -q "^\[extra\]" /etc/pacman.conf ||
			  echo -e "[extra]\nInclude = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
		    pacman -Sy --noconfirm >/dev/null
		    pacman-key --populate archlinux >/dev/null ;;
        esac
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay && cd /tmp/yay && sudo -u "$username" makepkg -si --noconfirm && cd
    ;;
    debnyan)
        apt install -y curl git wget gnupg lsb-release apt-transport-https ca-certificates
        distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)
        wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
        sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
        apt update
        ;;
    vowoid)
        xbps-install -Sy curl git ;;
    fedornya)
        dnf install curl git
        dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
        dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y 
        dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo
        ;;
    sus) 
        zypper in -y curl git
        eval "$(cat /etc/os-release)"
        if [ -f /etc/os-release ]; then
            case $ID in
		        opensuse-tumbleweed)
			        zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/" packman
    			    zypper dup --from packman --allow-vendor-change -y ;;
    		    opensuse-leap)
    			    # shellcheck disable=SC2154
    			    zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/" packman
    			    zypper dup --from packman --allow-vendor-change -y ;;
    		    suse)
    			    zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/SLE_$releasever/" packman
    			    zypper dup --from packman --allow-vendor-change -y ;;
    		esac
        fi
        rpm --import https://rpm.librewolf.net/pubkey.gpg
        zypper ar -ef https://rpm.librewolf.net librewolf
        zypper ref
    ;;
  esac
}

install_pkgs(){
    logo "Installing packages"
    [ -f /tmp/"$distro".txt ] && rm -rf /tmp/"$distro".txt
    curl -o /tmp/"$distro".txt https://raw.githubusercontent.com/p3nguin-kun/penguinRice/main/packages/"$distro".txt
    case "$distro" in
        debnyan) xargs -a /tmp/"$distro".txt apt install -y ;;
        fedornya) xargs -a /tmp/"$distro".txt dnf install -y --allowerasing ;;
        nyarch) 
            xargs -a /tmp/"$distro".txt pacman -Sy --noconfirm --needed
            sudo -u "$username" yay -S --noconfirm librewolf-bin
        ;;
        sus) xargs -a /tmp/"$distro".txt zypper in -y ;;
        vowoid) xargs -a /tmp/"$distro".txt xbps-install -Sy ;;
    esac
}

prepare_user_folders(){
    logo "Preparing user and folders"
    if [ ! "$(id -u "$username" > /dev/null)" ]; then
        echo "$username" "exists"
    else
        echo "$username" "does not exist"
        echo "Creating new user"
        useradd -m "$username"
        passwd "$username"
    fi
    mkdir -p /home/"$username"/
}

clone_dotfiles(){
    dotfiles_dir="/tmp/dotfiles"
    logo "Downloading dotfiles"
    [ -d $dotfiles_dir ] && rm -rf $dotfiles_dir
    git clone --depth=1 "$git_repo" -b "$branch" "$dotfiles_dir"
}

backup_dotfiles(){
  backup_folder=/home/"$username"/.RiceBackup
  logo "Backing-up dotfiles"
  echo "Backup files will be stored in /home/$username/.RiceBackup" "${BLD}" "${CRE}" "$HOME" "${CNC}"
  sleep 1
    if [ ! -d "$backup_folder" ]; then
    	mkdir -p "$backup_folder"
    fi
    [ -d /home/"$username"/.config/bspwm/user ] && mv /home/"$username"/.config/bspwm/user /tmp/bsp_backup
    for folder in alacritty bspwm dunst gtk-3.0 htop i3lock mpd ncmpcpp neofetch newsboat nvim picom pipewire polybar ranger rofi zsh; do
    	if [ -d /home/"$username"/.config/$folder ]; then
    		mv /home/"$username"/.config/$folder "$backup_folder/${folder}_$date"
      fi
    done

    for file in .xinitrc .fehbg .zshrc .Xresources; do
      [ -f /home/"$username"/$file ] && mv /home/"$username"/"$file" /home/"$username"/.RiceBackup/"$file"-backup-"$date"
    done
}

install_dotfiles(){
    logo "Installing dotfiles.."
    printf "Copying files to respective directories..\n"
    cp -rfT /tmp/dotfiles/main/ /home/"$username"/
    [ -d /tmp/bsp_backup ] && mv /tmp/bsp_backup /home/"$username"/.config/bspwm/user
    chown -R "$username":"$username" /home/"$username"
    fc-cache -fv
}

config_smth(){
    logo "Enable Tap to Click"
    [ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
	# Enable left mouse button by tapping
	Option "Tapping" "on"
EndSection' >/etc/X11/xorg.conf.d/40-libinput.conf
    if command -v pacman &>/dev/null; then
        logo "Configuring pacman (for what???)"
        sed -i "s/^#Color$/Color/" /etc/pacman.conf
        sed -i "s/#NoProgressBar/ILoveCandy/" /etc/pacman.conf
        sed -i "s/#VerbosePkgLists/VerbosePkgLists/" /etc/pacman.conf
        sed -i "s/#ParallelDownloads\ =\ 5/ParallelDownloads\ =\ 5/" /etc/pacman.conf
    fi
}

enable_services(){
    if command -v systemctl &>/dev/null; then
        logo "Enabling services"
        systemctl enable NetworkManager
        systemctl disable NetworkManager-wait-online.service
        sudo -u "$username" systemctl --user enable pipewire.service
        sudo -u "$username" systemctl --user enable pipewire-pulse.service
        sudo -u "$username" systemctl --user enable wireplumber.service
    elif command -v loginctl &>/dev/null; then
        ln -s /etc/sv/NetworkManager /var/service/
        ln -s /etc/sv/elogind /var/service/
        ln -s /etc/sv/dbus /var/service/
    fi
}

check_shell(){
    awk -F: -v user="$username" '$1 == user {print $NF}' /etc/passwd
}

change_shell(){
    logo "Changing shell to zsh"
    if [ "$(check_shell)" != "/usr/bin/zsh" ]; then
	    echo "Changing shell to zsh"
	    chsh -s /usr/bin/zsh "$username"
    else
	    echo -e "Your shell is already zsh\n" "${BLD}" "${CGR}" "${CNC}"
    fi
}

complete_msg(){
    logo "Done!"
    echo -e "Thanks for using penguinRice!\n" "${BLD}" "${CYE}" "${CNC}"
    echo -e "Before restart, you need to remember the following things:\n\n1. If you use Display Manager, choose 'bspwm' as session/desktop environment and log in.\n2. If you use tty, you just need to log in to your account.\n"
    while true; do
	    read -rp "Do you want to restart now? [Y/n]: " yn2
	    case $yn2 in
	      [Nn]*) exit ;;
        *) reboot_msg ;;
	    esac
    done
}

reboot_msg(){
    printf "%s%sYour system will be rebooted now %s\n" "${BLD}" "${CYE}" "${CNC}"
    if command -v systemctl &>/dev/null; then
        systemctl reboot
    elif command -v loginctl &>/dev/null; then
        loginctl reboot
    else
        reboot
    fi
}

# main
main(){
    root_checking
    intro
    read_username
    prepare_user_folders
    check_distro
    update
    setup_before_install
    install_pkgs
    clone_dotfiles
    backup_dotfiles
    install_dotfiles
    config_smth
    enable_services
    change_shell
    complete_msg
}

main
exit 0
