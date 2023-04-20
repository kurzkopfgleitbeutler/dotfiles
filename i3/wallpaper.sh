#!/bin/sh

# if [ "$(command -v xdpyinfo)" ]
# then
#     res="$(xdpyinfo | awk '/dimensions/ {print $2}')"
# else
#     res="1920x1080"
# fi

convert -size 480x270 xc: +noise Random -virtual-pixel tile -blur 0x5 -normalize -fx g -sigmoidal-contrast 15x50% -solarize 50% /tmp/fehbg.png
feh --bg-fill /tmp/fehbg.png
exit

if [ -d  "$HOME/wallpapers" ]
then
    location="$HOME/wallpapers"
else
    if [ -d /usr/share/backgrounds ]
    then
	location="/usr/share/backgrounds"
    else
	exit
    fi
fi

target="$(find "$location" -type f -size -5M \( \
	      -iname '*.jpg' \
	      -o -iname '*.png' \
	      -o -iname '*.gif' \) \
	     | shuf \
	     | head -n 1)"

if [ -r "$target" ] && [ "$(file --mime-type -b "$target" | awk -F'/' '{ print $1 }')" = "image" ]
then
    feh --bg-fill "$target"
    gsettings set org.gnome.desktop.background picture-uri "$target"
    gsettings set org.gnome.desktop.screensaver picture-uri "$target"
fi

# for file in $(find /usr/share/gnome-background-properties/ -type f -iname '*wallpaper*')
# do :
# done
