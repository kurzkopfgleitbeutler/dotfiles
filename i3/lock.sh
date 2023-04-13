#!/bin/sh

img=/tmp/i3lock.png
#img=/usr/share/wallpapers/Next/contents/images/1920x1080.png

if [ $(command -v import) ] && [ $(command -v convert) ]
then
    #scrot -o $img
    # BUG: ffmpeg -f x11grab -framerate 1 -video_size 1920x1080 -i :0.0 -vframes 1 "$img"
    # from imagemagick:
    import -window root "$img"
    convert "$img" -scale 10% -scale 1000% "$img"
else
    img1=/usr/share/wallpapers/Next/contents/images/1920x1080.png
    img2=/usr/share/wallpapers/Next/contents/images_dark/1920x1080.png
    r=$(( $(dd if=/dev/urandom count=1 2> /dev/null | cksum | cut -d' ' -f1) % 2 ))
    if [ "$r" -eq 1 ]
    then
	img=$img1
    else
	img=$img2
    fi
fi

i3lock --no-unlock-indicator --image="$img" --pointer=win --ignore-empty-password
