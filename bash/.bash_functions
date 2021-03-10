# bind 'les' to syntax-highlighting-enabled less through python's pygments
les () {
	pygmentize -gf terminal256 -P style=monokai "$1" | less -R
}

# avoid losing data when moving to new hard drives, file systems etc
ropy () {
     rsync --verbose --archive --hard-links --acls --xattrs --partial --delete-during "$1" "$2" >> "$2"/sync-report.txt 2>> "$2"/sync-errors.txt
}