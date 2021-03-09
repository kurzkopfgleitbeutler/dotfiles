#!/bin/sh
scope () {

    script_path="$(dirname "$(readlink -e -- "$0")")"
    script_name="$(basename "$0")"
    logfile_name="log.txt"

    bashrc="~/.bashrc"
    bashaliases="~/.bash_aliases"
    bashenv="~/.bash_setenv"
    inputrc="~/.inputrc"

    emacsinit="~/.config/emacs/init.el"
    emacssitestart="/usr/local/share/emacs/site-lisp/site-start.el"

    gitconfig="~/.gitconfig"

    vimrc="~/.vimrc"
    nviminit=""

    hello () {
	printf "%b\n" "\n" | tee -a $logfile_name
	date -Iseconds | tee -a $logfile_name
	printf "%b\n" "Symlink configuration files in appropriate places" | tee -a $logfile_name
	printf "%b\n" "HOME is $HOME" | tee -a $logfile_name
	printf "%b\n" "current working directory is $script_path" | tee -a $logfile_name
	printf "%b\n" "script name is $script_name" | tee -a $logfile_name
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
	# export base="$script_path"

	# bash
	trylink bash/.bashrc $bashrc
	trylink bash/.bash_aliases $bashaliases
	trylink bash/.bash_setenv $bashenv
	if [ "$fail" != "$bashenv" ]; then sed -i "1i export base=$script_path" $bashenv; fi # prepend environment variable dynamically, only if trylinking worked
	trylink bash/.inputrc $inputrc

	# emacs
	trylink emacs/init.el $emacsinit
	trylink emacs/site-start.el $emacssitestart

	# vi
	trylink vi/.vimrc $vimrc

	# notify of failures
	printf "%b\n" "grep 'ERROR:' $logfile_name"
	printf "%b" "grep '...FAIL' $logfile_name"
    }
    main
}
scope $@
