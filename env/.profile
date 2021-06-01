export my_base=""
export my_emacs_user_full_name=""
export my_emacs_user_mail_address=""
export my_emacs_org_directory=""
export my_emacs_emms_source_file_default_directory=""
export my_emacs_projects_dired_symlink=""
export my_emacs_projectile_searchpath=""
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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
    PATH="$HOME/.local/bin:$PATH"
fi
. "$HOME/.cargo/env"
