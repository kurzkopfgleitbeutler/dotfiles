#!/bin/sh
scope ()
(
    # ---------- VARIABLES -----------
    script_path="$(dirname "$(readlink -e -- "$0")")"
    script_name="$(basename "$0")"
    logfile_name=/dev/null
    runtime_dependencies="sudo ln sed"
    export SUDO_ASKPASS="$(which ssh-askpass)"
    unset verbose
    unset distname

    distname="$(awk -F'=' '/^ID=/ {print tolower($2)}' /etc/*-release)"
    # if [ "$distname" = "ubuntu" ]
    # then
    # elif [ "$distname" = "fedora" ]
    # then
    # fi

    # ---------- ARGPARSE ------------
    while getopts 'lv' c
    do
	case $c in
	    l) logfile_name="log_${script_name%.*}.txt"; shift ;;
	    v) verbose=1; shift ;;
	    --) shift; break ;;
	    *) echo "[ERROR] unsupported argument: $1"; usage ;;
	esac
    done

    # ---------- FUNCTIONS -----------
    usage () {
	printf "%b\n" "Usage: $script_name [-v] [-l]"
	exit 2
    }
    hello () {
	printf "%b\n" "[INFO] $script_path/$script_name\n$(date -Iseconds)"
	printf "%b\n" "Symlink configuration files in appropriate places"
    }
    log () {
	if [ -n "$verbose" ]
	then
	    "$@" | tee -a $logfile_name
	else
	    "$@" >> $logfile_name
	fi
    }
    debug () {
	if [ -n "$debug" ]
	then
	    "$@"
	fi
    }
    check_for_app () {
	for dep in $@
	do
	    if [ -n "$(which $dep)" ]
	    then
		printf "%b\n" "found $dep"
	    else
		printf "%b\n" "[ERROR] $dep not found, aborting"
		exit 2
	    fi
	done
    }
    trysudo () {
	if [ -n "$(getent group sudo | grep -o $USER)" ]
	then
	    if [ -n "$SUDO_ASKPASS" ]
	    then
		sudo -A "$@"
	    else
		read -s -t 30 -p "[sudo] password for $USER: " sudoPW
		echo $sudoPW | sudo -S "$@"
		unset sudoPW
	    fi
	else
	    printf "%b\n" "[WARN] $USER has no sudo rights: $@"
	fi
    }
    which_os () {
	if [ -r /etc/redhat-release ]
	then
	    distname="fedora"
	elif [ -r /etc/os-release ] # or /etc/lsb-release
	then
	    distname="ubuntu"
	fi
    }
    enso () {
	# "ensure_softlink"
	if [ -h "$2" ]
	then
	    rm "$2"
	fi
	ln -vs "$1" "$2"
    }

    # ---------- MAIN ----------------
    main () {
	hello
	check_for_app $runtime_dependencies

	# env
	enso ~/dotfiles/env/.profile ~/.profile
	if [ -z "$(sed -n '/^export my_base/p' ~/dotfiles/env/.profile)" ]
	then
	    sed -i "1i export my_base=\'$script_path\'" ~/dotfiles/env/.profile
	fi
	enso ~/dotfiles/env/.Xresources  ~/.Xresources

	# bash
	enso ~/dotfiles/bash/.bashrc ~/.bashrc
	enso ~/dotfiles/bash/.bash_aliases ~/.bash_aliases
	enso ~/dotfiles/bash/.bash_setenv ~/.bash_setenv
	enso ~/dotfiles/bash/.inputrc ~/.inputrc

	#emacs
	enso ~/dotfiles/emacs/init.el ~/.config/emacs/init.el
	if [ "$distname" = "fedora" ]
	then
	    trysudo ln -vs ~/dotfiles/emacs/site-start.el /usr/share/emacs/site-lisp/site-start.d/site-start.el
	elif [ "$distname" = "ubuntu" ]
	then
	    trysudo ln -vs ~/dotfiles/emacs/site-start.el /usr/local/share/emacs/site-lisp/site-start.el
	fi

	# git
	enso ~/dotfiles/git/.gitconfig ~/.gitconfig

	# i3
	enso ~/dotfiles/i3/config ~/.config/i3/config
	# mkdir -v ~/.config/i3status
	enso ~/dotfiles/i3/i3status/config ~/.config/i3status/config

	# mpv
	if [ "$distname" = "ubuntu" ]
	then
	    enso ~/dotfiles/mpv/mpv.conf ~/.config/mpv/mpv.conf
	fi

	# neovim
	enso ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
	# flatpak version
	if [ -n "$(which io.neovim.nvim)" ]
	then
	    mkdir -v ~/.var/app/io.neovim.nvim/config/nvim
	    enso ~/dotfiles/nvim/init.vim ~/.var/app/io.neovim.nvim/config/nvim/init.vim
	    # note that nvim plugin manager junegunn/vim-plug uses ~/.local/share/nvim/ to put plugins
	    # but the flatpak version needs them in ~/.var/app/io.neovim.nvim/data/nvim
	fi

	# vim
	enso ~/dotfiles/vim/.vimrc ~/.vimrc

	printf "%b\n" ""
    }
    log main $@
)
scope $@

# ---------- COMMENTS ------------
