#!/usr/bin/env bash

# --- penguinRice ---
# GitHub: p3nguin-kun

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
BLD=$(tput bold)
CNC=$(tput sgr0)

# --- Vars ---
date=$(date +%Y%m%d-%H%M%S)
git_repo="https://github.com/p3nguin-kun/penguinDotfiles"
branch="bspwm"

# --- Functions ---

logo() {
	local text="${1:?}"
	printf '[%s %s %s %s %s]\n\n' "${CRE}" "${CNC}" "${CYE}" "${text}"
}

root_checking(){
if [ ! "$(id -u)" = 0 ]; then
	echo "This script MUST BE run as root."
	exit 1
fi
}

done_msg(){
    printf "%s%sDone!!%s\n\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 1
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
        pacman -Syyuu ;;
      debnyan) apt update -y && apt upgrade -y ;;
      fedornya) dnf update -y ;;
      sus) zypper dup -y ;;
      vowoid) xbps-install -Syu ;;
    esac
    done_msg
}

setup_before_install(){
  case $distro in
    nyarch)
      case "$(readlink -f /sbin/init)" in
	      *systemd*) return ;;
	      *)
		    logo "Enabling Arch Repositories"
		    grep -q "^\[extra\]" /etc/pacman.conf ||
			  echo -e "[extra]\nInclude = /etc/pacman.d/mirrorlist-arch" >> /etc/pacman.conf
		    pacman -Sy --noconfirm >/dev/null
		    pacman-key --populate archlinux >/dev/null ;;
      esac
    ;;
    fedornya)
      logo "Adding repos"
      dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
      dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y ;;
    sus) 
      logo "Adding repos"
      eval "$(cat /etc/os-release)"
      if [ -f /etc/os-release ]; then
      case $ID in
		    opensuse-tumbleweed)
			    zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/" packman
			    zypper dup --from packman --allow-vendor-change -y ;;
		    opensuse-leap)
			    zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/" packman
			    zypper dup --from packman --allow-vendor-change -y ;;
		    suse)
			    zypper ar -cfp 90 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/SLE_$releasever/" packman
			    zypper dup --from packman --allow-vendor-change -y ;;
		  esac
      fi
    ;;
  esac
  done_msg
}

install_pkgs(){
    logo "Installing packages"
    [ -f /tmp/"$distro".txt ] && rm -rf /tmp/"$distro".txt
    curl -o /tmp/"$distro".txt https://raw.githubusercontent.com/p3nguin-kun/penguinRice/main/packages/"$distro".txt
    case $distro in
      nyarch) pacman -S --needed --noconfirm - < /tmp/"$distro".txt ;;
      debnyan) apt install -y - < /tmp/"$distro".txt ;;
      fedornya) dnf install -y --allowerasing - < /tmp/"$distro".txt ;;
      sus) zypper in -y - < /tmp/"$distro".txt ;;
      vowoid) xbps-install -Sy - < /tmp/"$distro".txt ;;
    esac
    done_msg
}

prepare_user_folders(){
    logo "Preparing user and folders"
    if [ "$(id -u "$username" > /dev/null)" -eq 0 ]; then
        echo "$username" "exists"
    else
        echo "$username" "does not exist"
        echo "Creating new user"
        useradd -m "$username"
        passwd "$username"
    fi
    mkdir -p /home/"$username"/
    done_msg
}

clone_dotfiles(){
    dotfiles_dir="/tmp/dotfiles"
    logo "Downloading dotfiles"
    [ -d $dotfiles_dir ] && rm -rf $dotfiles_dir
    git clone --depth=1 "$git_repo" -b "$branch" "$dotfiles_dir"
    done_msg
}

backup_dotfiles(){
  backup_folder=/home/$username/.RiceBackup
  logo "Backing-up dotfiles"
  echo "Backup files will be stored in /home/$username/.RiceBackup" "${BLD}" "${CRE}" "$HOME" "${CNC}"
  sleep 1
if [ ! -d "$backup_folder" ]; then
	mkdir -p "$backup_folder"
fi

for folder in alacritty bspwm gtk-3.0 htop mpd ncmpcpp neofetch newsboat nvim pipewire ranger; do
	if [ -d /home/"$username"/.config/$folder ]; then
		mv /home/"$username"/.config/$folder "$backup_folder/${folder}_$date"
  fi
done

for file in .xinitrc .fehbg .zshrc .Xresources; do
  [ -f /home/"$username"/$file ] && mv /home/"$username"/"$file" /home/"$username"/.RiceBackup/"$file"-backup-"$date"
done
done_msg
}

install_dotfiles(){
logo "Installing dotfiles.."
printf "Copying files to respective directories..\n"
cp -rfT /tmp/dotfiles/main/ /home/"$username"/
chown -R "$username":"$username" /home/"$username"
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
  cp -R /tmp/dotfiles/misc/firefox/* /home/"$username"/.mozilla/firefox/*.default-*/
  chown -R "$username":"$username" /home/"$username"/.mozilla/firefox/
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
    done_msg
}

complete_msg(){
    logo "Done!"
    echo -e "Thanks for using penguinRice!\n" "${BLD}" "${CYE}" "${CNC}"
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

# --- Main ---

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
config_firefox
enable_services
change_shell
complete_msg
