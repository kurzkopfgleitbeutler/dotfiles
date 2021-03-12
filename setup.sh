#!/bin/sh
scope () {

    script_path="$(dirname "$(readlink -e -- "$0")")"
    script_name="$(basename "$0")"
    logfile_name="$(date -Iseconds)_setup_log.txt"

    profile="~/.profile"

    bashrc="~/.bashrc"
    bashaliases="~/.bash_aliases"
    bashfunctions="~/.bash_functions"
    bashenv="~/.bash_setenv"
    inputrc="~/.inputrc"

    emacsinit="~/.config/emacs/init.el"
    emacssitestart="/usr/local/share/emacs/site-lisp/site-start.el"

    gitconfig="~/.gitconfig"

    vimrc="~/.vimrc"
    nviminit="~/.config/nvim/init.vim"

    hello () {
	printf "%b\n" "$script_path/$script_name" | tee -a $logfile_name
	printf "%b\n" "Symlink configuration files in appropriate places" | tee -a $logfile_name
    }

    trylink () {
	unset fail
	if [ ! -e "$1" ]
	then
	    printf "%b\n" "ERROR: no file to symlink ($1)" | tee -a $logfile_name
	else
	    if [ -e "$2" ]
	    then
		printf "%b\n" "ERROR: $2 already exists, not touching it" | tee -a $logfile_name
	    else
		printf "%b\n" "ln $script_path/$1 $2" | tee -a $logfile_name
		# https://hyperpolyglot.org/shell#exceptions-note
		trap "printf \"%b\n\" \" ...FAIL\" | tee -a $logfile_name; fail=\"$2\"" ERR
		ln "$script_path/$1" "$2"
		trap - ERR
	    fi
	fi
    }

    main () {
	hello

	# set environment variables
	trylink .profile $profile
	# prepend environment variable dynamically, only if trylinking worked, and it’s not already set
	if [ "$fail" != "$profile" ]
	then
	    if [ -z "$base" ]
	    then
		printf "%b\n" "file $profile : export base=\'$script_path\'" | tee -a $logfile_name
		sed -i "1i export base=\'$script_path\'" $profile
	    else
		printf "%b\n" "ERROR: environment variable 'base' is already set, not prepending its definition to $profile" | tee -a $logfile_name
	    fi
	fi

	# bash
	trylink bash/.bashrc $bashrc
	# only need linking in HOME if $base is unset
	if [ -z "$base" ]
	then
	    printf "%b\n" "no environment variable 'base', linking all bash files in HOME" | tee -a $logfile_name
	    trylink bash/.bash_aliases $bashaliases
	    trylink bash/.bash_functions $bashfunctions
	    trylink bash/.bash_setenv $bashenv
	    trylink bash/.inputrc $inputrc
	fi

	# emacs
	trylink emacs/init.el $emacsinit
	# setuid fuer admin Rechte
	trylink emacs/site-start.el $emacssitestart

	# git
	trylink git/.gitconfig $gitconfig

	# vi
	trylink vi/.vimrc $vimrc
	trylink vi/nvim/init.vim $nviminit

	# notify of failures
	printf "%b\n" "grep 'ERROR:' $logfile_name"
	printf "%b" "grep '...FAIL' $logfile_name"
    }
    main
}
scope $@
