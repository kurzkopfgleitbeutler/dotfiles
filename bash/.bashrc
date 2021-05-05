# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# alternatives:
# [ -z "$PS1" ] && return
# [[ "$-" != *i* ]] && return

# Shell Options (man bash, see section shopt)
#
shopt -s autocd cdspell checkwinsize dirspell dotglob histappend nocaseglob

# Aliases
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f "$my_base/bash/.bash_aliases" ]; then
    source "$my_base/bash/.bash_aliases"
elif [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

# Environment Variables
#
if [ -f "$my_base/bash/.bash_setenv" ]; then
    source "$my_base/bash/.bash_setenv"
elif [ -f "$HOME/.bash_setenv" ]; then
    source "$HOME/.bash_setenv"
fi

# Functions
#
if [ -f "$my_base/bash/.bash_functions" ]; then
    source "$my_base/bash/.bash_functions"
elif [ -f "$HOME/.bash_functions" ]; then
    source "$HOME/.bash_functions"
fi

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Prompt Customization
#
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
    *)
	;;
esac

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# customize tab completion
#
if [ -f "$my_base/bash/.inputrc" ]; then
    source "$my_base/bash/.inputrc"
elif [ -f "$HOME/.inputrc" ]; then
    source "$HOME/.inputrc"
fi
# Git Bash Completions
#
if [ -f "$my_base/bash/git-completion.bash" ]; then
    source "$my_base/bash/git-completion.bash"
elif [ -f "$HOME/git-completion.bash" ]; then
    source "$HOME/git-completion.bash"
fi
# Rust Bash Completions
#
if [ -f "$my_base/bash/bash-completion/rustup" ]; then
    source "$my_base/bash/bash-completion/rustup"
fi
if [ -f "$my_base/bash/bash-completion/cargo" ]; then
    source "$my_base/bash/bash-completion/cargo"
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
    fi
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
	# check because c-n-f could've been removed in the meantime
	if [ -x /usr/lib/command-not-found ]; then
	    /usr/lib/command-not-found -- "$1"
	    return $?
	elif [ -x /usr/share/command-not-found/command-not-found ]; then
	    /usr/share/command-not-found/command-not-found -- "$1"
	    return $?
	else
	    printf "%s: command not found\n" "$1" >&2
	    return 127
	fi
    }
fi

# sfdx autocomplete setup
SFDX_AC_BASH_SETUP_PATH=${HOME}/.cache/sfdx/autocomplete/bash_setup && test -f $SFDX_AC_BASH_SETUP_PATH && source $SFDX_AC_BASH_SETUP_PATH;
