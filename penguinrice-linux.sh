#!/usr/bin/env bash

# penguinRice
# GitHub: p3nguin-kun

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

date=$(date +%Y%m%d-%H%M%S)

logo() {
	local text="${1:?}"
	printf ' %s [%s%s %s%s %s]%s\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}"
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
    read -rp "Type your username here: " username
}

done_msg(){
    printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 1
}

update(){
    logo "Updating system"
    if command -v pacman &>/dev/null; then
        rm -rf /var/lib/pacman/db.lck
        case "$(readlink -f /sbin/init)" in
	    *systemd*)
            pacman -Sy --noconfirm --needed archlinux-keyring ;;
        *)
            pacman --noconfirm --needed -Sy artix-keyring artix-archlinux-support ;;
        esac
        pacman -Syu --noconfirm
    elif command -v apt &>/dev/null; then
        apt update -y && apt upgrade -y
    elif command -v dnf &>/dev/null; then
        dnf update -y
    elif command -v zypper &>/dev/null; then
        zypper dup -y
    elif command -v xbps-install &>/dev/null; then
	    xbps-install -Syu
    fi
    done_msg
}

setup_before_install(){
    if command -v pacman &>/dev/null; then
        case "$(readlink -f /sbin/init)" in
	    *systemd*)
		    return ;;
	    *)
		    logo "Enabling Arch Repositories"
		    grep -q "^\[extra\]" /etc/pacman.conf ||
			echo "[extra]
Include = /etc/pacman.d/mirrorlist-arch" >>/etc/pacman.conf
		    pacman -Sy --noconfirm >/dev/null 2>&1
		    pacman-key --populate archlinux >/dev/null 2>&1
		    ;;
	    esac
    elif command -v dnf &>/dev/null; then
        logo "Adding repos"
        dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
        dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
    elif command -v zypper &>/dev/null; then
        logo "Adding repos"
        if [ -f /etc/os-release ]; then
	    eval "$(cat /etc/os-release)"
	    case $ID in
		    opensuse-tumbleweed)
			    zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
			    zypper dup --from packman --allow-vendor-change -y
			    ;;
		    opensuse-leap)
			    zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
			    zypper dup --from packman --allow-vendor-change -y
			    ;;
		    suse)
			    zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/SLE_$releasever/' packman
			    zypper dup --from packman --allow-vendor-change -y
			    ;;
		esac
        fi
    fi
    done_msg
}

install_xorg(){
    logo "Installing X.org (display server)"
    if command -v pacman &>/dev/null; then
        pacman -S --needed --noconfirm xorg xorg-drivers
    elif command -v apt &>/dev/null; then
        apt install -y xorg xserver-xorg
    elif command -v dnf &>/dev/null; then
        dnf install -y xorg-x11-server-Xorg xorg-x11-drivers
    elif command -v zypper &>/dev/null; then
        zypper in -y xorg-x11-server xorg-x11-driver-video
    elif command -v xbps-install &>/dev/null; then
	xbps-install -Sy xorg
    fi
    done_msg
}

install_pipewire(){
    logo "Installing pipewire (audio)"
    if command -v pacman &>/dev/null; then
        yes y | pacman -S --needed pipewire pipewire-pulse wireplumber
    elif command -v apt &>/dev/null; then
        apt install -y pipewire wireplumber
    elif command -v dnf &>/dev/null; then
        dnf install -y pipewire wireplumber
    elif command -v zypper &>/dev/null; then
        zypper in -y pipewire wireplumber
    elif command -v xbps-install &>/dev/null; then
	xbps-install -Sy pipewire wireplumber
    fi
    done_msg
}

install_pkgs(){
    logo "Installing packages"
    if command -v pacman &>/dev/null; then
        install_pkgs_pacman
    elif command -v apt &>/dev/null; then
        install_pkgs_apt
    elif command -v dnf &>/dev/null; then
        install_pkgs_dnf
    elif command -v zypper &>/dev/null; then
        install_pkgs_zypper
    elif command -v xbps-install &>/dev/null; then
	install_pkgs_xbps
    fi
    done_msg
}

install_pkgs_pacman(){
    pacman -S --needed --noconfirm alacritty alsa-utils arandr bspwm brightnessctl calcurse dunst feh firefox git gtk-engine-murrine gvfs gvfs-afc gvfs-mtp gvfs-smb htop i3lock imagemagick libnotify lxappearance-gtk3 maim mpc mpd mpv ncmpcpp neofetch neovim networkmanager newsboat pcmanfm-gtk3 picom polybar ranger rofi sed sxhkd sudo udisks2 ueberzug unzip xclip xdg-user-dirs-gtk xorg-xinit xss-lock zathura zathura-pdf-mupdf zip zsh
}

install_pkgs_apt(){
    apt install -y alacritty alsa-utils arandr bspwm brightnessctl calcurse dunst feh git gtk2-engines-murrine gvfs gvfs-common gvfs-daemons htop i3lock imagemagick lxappearance libnotify-bin maim mpc mpd mpv ncmpcpp neovim neofetch network-manager newsboat pcmanfm picom polybar ranger rofi sed sxhkd sudo udisks2 ueberzug unzip xclip xdg-user-dirs-gtk xinit xss-lock zathura zathura-pdf-poppler zip zsh
}

install_pkgs_dnf(){
    dnf install -y --allowerasing alacritty alsa-utils arandr bspwm brightnessctl calcurse dunst feh firefox git gtk-murrine-engine gvfs gvfs-afc gvfs-mtp gvfs-smb htop i3lock ImageMagick lxappearance libnotify maim mpc mpd mpv ncmpcpp neovim neofetch NetworkManager newsboat pcmanfm picom polybar ranger rofi sed sxhkd sudo udisks2 unzip xclip xdg-user-dirs-gtk xorg-x11-xinit xss-lock zathura zathura-pdf-mupdf zip zsh
}

install_pkgs_zypper(){
    zypper in -y alacritty arandr bspwm brightnessctl calcurse dunst feh firefox git gtk2-engine-murrine gvfs htop i3lock ImageMagick lxappearance libnotify maim mpd mpv ncmpcpp neofetch neovim NetworkManager newsboat pcmanfm picom polybar ranger rofi sed sxhkd sudo udisks2 ueberzug unzip xclip xdg-user-dirs-gtk xinit xss-lock yad zathura zathura-pdf-mupdf zip zsh
}

install_pkgs_xbps(){
    xbps-install -Sy alacritty alsa-utils arandr bspwm brightnessctl btop calcurse dunst feh firefox git gtk-engine-murrine gvfs gvfs-afc gvfs-mtp gvfs-smb i3lock ImageMagick libnotify lxappearance maim mpc mpd mpv ncmpcpp neofetch neovim NetworkManager newsboat pcmanfm picom polybar psmisc ranger rofi sed sxhkd sudo udisks2 unzip xclip xdg-user-dirs-gtk xinit xss-lock zathura zathura-pdf-mupdf zip zsh
}

prepare_user_folders(){
    logo "Preparing user and folders"
    getent passwd $username > /dev/null
    if [ $? -eq 0 ]; then
        echo $username "exists"
    else
        echo $username "does not exist"
        echo "Creating new user"
        useradd -m $username
        passwd $username
    fi
    mkdir -p /home/$username/
    mkdir -p /home/$username/.config/
    mkdir -p /home/$username/.fonts/
    mkdir -p /home/$username/.themes/
    mkdir -p /home/$username/.icons/
    done_msg
}

clone_dotfiles(){
    logo "Downloading dotfiles"
    [ -d /tmp/penguinDotfiles ] && rm -rf /tmp/penguinDotfiles
    git clone --depth=1 https://github.com/p3nguin-kun/penguinDotfiles /tmp/penguinDotfiles
    done_msg
}

backup_dotfiles(){
    backup_folder=/home/$username/.RiceBackup
    logo "Backing-up dotfiles"
printf "Backup files will be stored in /home/$username/.RiceBackup \n\n" "${BLD}" "${CRE}" "$HOME" "${CNC}"
sleep 1

if [ ! -d "$backup_folder" ]; then
	mkdir -p "$backup_folder"
fi

for folder in alacritty bspwm gtk-3.0 htop mpd ncmpcpp neofetch nvim ranger; do
	if [ -d "/home/$username/.config/$folder" ]; then
		mv "/home/$username/.config/$folder" "$backup_folder/${folder}_$date"
		echo "$folder folder backed up successfully at $backup_folder/${folder}_$date"
	else
		echo "The folder $folder does not exist in $HOME/.config/"
	fi
done

for folder in chrome; do
	if [ -d "$HOME"/.mozilla/firefox/*.default-*/$folder ]; then
		mv "$HOME"/.mozilla/firefox/*.default-*/$folder "$backup_folder"/${folder}_$date
    echo "$folder folder backed up successfully at $backup_folder/${folder}_$date"
	fi
done

for file in user.js; do
	if [ -e "$HOME"/.mozilla/firefox/*.default-*/$file ]; then
		mv "$HOME"/.mozilla/firefox/*.default-*/$file "$backup_folder"/${file}_$date
    echo "$file file backed up successfully at $backup_folder/${file}_$date"
	fi
done

[ -f /home/$username/.Xresources ] && mv /home/$username/.Xresources /home/$username/.RiceBackup/.Xresources-backup-"$(date +%Y.%m.%d-%H.%M.%S)"
[ -f /home/$username/.zshrc ] && mv /home/$username/.zshrc /home/$username/.RiceBackup/.zshrc-backup-"$(date +%Y.%m.%d-%H.%M.%S)"
[ -f /home/$username/.fehbg ] && mv /home/$username/.fehbg /home/$username/.RiceBackup/.fehbg-backup-"$(date +%Y.%m.%d-%H.%M.%S)"
[ -f /home/$username/.xinitrc ] && mv /home/$username/.xinitrc /home/$username/.RiceBackup/.xinitrc-backup-"$(date +%Y.%m.%d-%H.%M.%S)"
done_msg
}

install_dotfiles(){
logo "Installing dotfiles.."
printf "Copying files to respective directories..\n"
cp -R /tmp/penguinDotfiles/config/* /home/$username/.config
cp -R /tmp/penguinDotfiles/themes/* /home/$username/.themes
cp -R /tmp/penguinDotfiles/icons/* /home/$username/.icons
cp -R /tmp/penguinDotfiles/fonts/* /home/$username/.fonts
cp -RT /tmp/penguinDotfiles/fonts/local/ /home/$username/.local/
cp -RT /tmp/penguinDotfiles/home/ /home/$username
chown -R $username:$username /home/$username
done_msg
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
    done_msg
    if command -v pacman &>/dev/null; then
        logo "Configuring pacman (for what???)"
        sed -i "s/^#Color$/Color/" /etc/pacman.conf
        sed -i "s/#NoProgressBar/ILoveCandy/" /etc/pacman.conf
        sed -i "s/#VerbosePkgLists/VerbosePkgLists/" /etc/pacman.conf
        sed -i "s/#ParallelDownloads\ =\ 5/ParallelDownloads\ =\ 5/" /etc/pacman.conf
        done_msg
    fi
}

config_firefox(){
  logo "Config Firefox"
  sudo -u "$username" firefox --headless >/dev/null &
  sleep 2
  cp -R /tmp/penguinDotfiles/misc/firefox/* /home/$username/.mozilla/firefox/*.default-*/
  pkill -u "$username" firefox
  sleep 1
  done_msg
}

enable_services(){
    if command -v systemctl &>/dev/null; then
        logo "Enabling services"
        systemctl enable NetworkManager
        systemctl disable NetworkManager-wait-online.service
        sudo -u "$username" systemctl --user disable pipewire.service
        sudo -u "$username" systemctl --user disable pipewire-pulse.service
        sudo -u "$username" systemctl --user disable wireplumber.service
    elif command -v loginctl &>/dev/null; then
        ln -s /etc/sv/NetworkManager /var/service/
    fi
    done_msg
}

check_shell(){
    awk -F: -v user=$username '$1 == user {print $NF}' /etc/passwd
}

change_shell(){
    logo "Changing shell to zsh"
    if [ $(check_shell) != "/usr/bin/zsh" ]; then
	    echo "Changing shell to zsh"
	    chsh -s /usr/bin/zsh $username
    else
	    printf "%s%sYour shell is already zsh\n" "${BLD}" "${CGR}" "${CNC}"
    fi
    done_msg
}

complete_msg(){
    logo "Done!"
    printf "%s%sThanks for using penguinRice! %s\n" "${BLD}" "${CYE}" "${CNC}"
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

root_checking
intro
read_username
prepare_user_folders
update
setup_before_install
install_xorg
install_pipewire
install_pkgs
clone_dotfiles
backup_dotfiles
install_dotfiles
config_smth
config_firefox
enable_services
change_shell
complete_msg
