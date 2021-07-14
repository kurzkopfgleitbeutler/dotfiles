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

    # ---------- MAIN ----------------
    main () {
	hello
	check_for_app $runtime_dependencies

	ln -vs ~/dotfiles/env/.profile ~/.profile
	if [ -n "$(sed -n '/^export my_base/p' ~/dotfiles/env/.profile)" ]
	then
	    sed -i "1i export my_base=\'$script_path\'" ~/dotfiles/env/.profile
	fi

	# bash
	ln -vs ~/dotfiles/bash/.bashrc ~/.bashrc
	ln -vs ~/dotfiles/bash/.bash_aliases ~/.bash_aliases
	ln -vs ~/dotfiles/bash/.bash_setenv ~/.bash_setenv
	ln -vs ~/dotfiles/bash/.inputrc ~/.inputrc

	#emacs
	ln -vs ~/dotfiles/emacs/init.el ~/.config/emacs/init.el
	if [ "$distname" = "fedora" ]
	then
	    trysudo ln -vs ~/dotfiles/emacs/site-start.el /usr/share/emacs/site-lisp/site-start.d/site-start.el
	elif [ "$distname" = "ubuntu" ]
	then
	    trysudo ln -vs ~/dotfiles/emacs/site-start.el /usr/local/share/emacs/site-lisp/site-start.el
	fi

	# env
	ln -vs ~/dotfiles/env/.profile  ~/.profile
	ln -vs ~/dotfiles/env/.Xresources  ~/.Xresources

	# git
	ln -vs ~/dotfiles/git/.gitconfig ~/.gitconfig

	# i3
	ln -vs ~/dotfiles/i3/config ~/.config/i3/config

	# neovim
	ln -vs ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
	# flatpak version
	mkdir -v ~/.var/app/io.neovim.nvim/config/nvim
	ln -vs ~/dotfiles/nvim/init.vim ~/.var/app/io.neovim.nvim/config/nvim/init.vim
	# note that nvim plugin manager junegunn/vim-plug uses ~/.local/share/nvim/ to put plugins
	# but the flatpak version needs them in ~/.var/app/io.neovim.nvim/data/nvim

	# vim
	ln -vs ~/dotfiles/vim/.vimrc ~/.vimrc

	printf "%b\n" ""
    }
    log main $@
)
scope $@

# ---------- COMMENTS ------------
