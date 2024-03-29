export my_base=""
export my_emacs_user_full_name=""
export my_emacs_user_mail_address=""
export my_emacs_org_directory=""
export my_emacs_emms_source_file_default_directory=""
export my_emacs_projects_dired_symlink=""
export my_emacs_projectile_searchpath=""

export TERMINAL="urxvt" # i3-sensible-terminal

# Use 'Print' key as right-click
/usr/bin/xmodmap -e 'keycode 107 = Menu'

# distname="$(awk -F'=' '/^ID=/ {print tolower($2)}' /etc/*-release)"
# if [ "$distname" = "ubuntu" ]
# then
# elif [ "$distname" = "fedora" ]
# then
# fi

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# fix dircolors for Selenized
export LS_COLORS="$LS_COLORS:ow=1;7;34:st=30;44:su=30;41"

# gnupg
export GPG_TTY=$(tty)

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$base/bash/.bashrc" ]; then
	source "$base/bash/.bashrc"
    elif [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# include Telegram
if [ -d "$HOME/apps/Telegram" ] ; then
    PATH="$PATH:$HOME/apps/Telegram"
fi


# https://askubuntu.com/questions/60218/how-to-add-a-directory-to-the-path
# `$ pip3 install wheel --upgrade` leads to "The script wheel is installed in '~/.local/bin' which is not on PATH. Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location."
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi
. "$HOME/.cargo/env"

# add flatpak bins to path
if [ -d "/var/lib/flatpak/exports/bin" ] ; then
    PATH="$PATH:/var/lib/flatpak/exports/bin"
fi

# add java home to path: readlink -f $(which java)
if [ -f "$(which java)" ] ; then
    export JAVA_HOME=$(readlink -f $(which java) | sed "s:/bin/java::")
    PATH="$PATH:$JAVA_HOME/bin"
fi

# https://wiki.archlinux.org/title/SSH_keys#ssh-agent
# since upgrade to ubuntu 22.04, the bash alias: ssh-agent; pass -c ssh-keygen-github; ssh-add ~/.ssh/github
# doesn't work anymore. Also, the alias: eval "$(ssh-agent)"; pass -c ssh-keygen-github; ssh-add ~/.ssh/github
# spawns an $SSH_AGENT_PID only as child of the current bash.
# without this, alias workgit='eval "$(ssh-agent)"; pass -c ssh-keygen-github; ssh-add ~/.ssh/' is a small workaround for only bash
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [ ! -f "$SSH_AUTH_SOCK" ]
then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
fi
