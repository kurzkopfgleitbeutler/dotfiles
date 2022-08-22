emacs () {
      emacsclient "$@" 2>/dev/null || /usr/bin/emacs "$@"
}

# bind 'les' to syntax-highlighting-enabled less through python's pygments
les () {
    pygmentize -gf terminal256 -P style=monokai "$1" | less -R
}

# avoid losing data when moving to new hard drives, file systems etc
ropy () {
    rsync --verbose --archive --hard-links --acls --xattrs --partial --delete-during "$1" "$2" >> "$2"/sync-report.txt 2>> "$2"/sync-errors.txt
}

clamscan () {
    clamscan --recursive --allmatch --detect-pua=yes --detect-structured=yes --heuristic-scan-precedence=yes --max-filesize=2048M $@ | tee "$@"_clam_report.txt
}

p () {
    # awk 'BEGIN { print "permissions octal owner	hardlinks filetype	name" } { printf("%-11s %5s %5s %8s %-12s %s\n", $1, $2, $3, $4, $5, $6) }'
    # { printf "%b\n" "permissions octal owner hardlinks filetype name" ; stat -c '%A %a %U %h %F %N' $* ; } | column -t
    #find . -maxdepth 1 -printf "%M %m %u %n %y %f\n" | column -t
    # tree -afpuhFi --dirsfirst -L 1 --

    # octal perms
    # owner
    # num of hardlinks
    # type (d / f / l )
    # size for humans
    # name with link resolution
    # { stat -c '%a %U %h' * ; }
    # if I try to combine the outputs of stat and find, they'll be printed after each other
    for f in *
    do
	# ls -CFAlhv --group-directories-first --color=always
	# stat -c '%a' $f && ls -CldhF --color=auto --time-style=long-iso $f | sed -e 's/[drwx+-]* [0-9]*//'
	# printf "%b\n" "next file: "
	# echo "$f"
	{ find "$f" -maxdepth 0 -printf "%Y %f " ; stat -c '%a %U %h' "$f" ; } | awk '{ printf("%s %s %s %s %s\n", $3, $4, $5, $1, $2) }' # | column -t
	# read -p "next?" p
	# echo "$f"
    done
}
perms () {
    p
}

l () {
    script='
function human(x) {
    if (x<1000) {return x} else {x/=1024}
    s="kMGTEPZY";
    while (x>=1000 && length(s)>1) {
    	  x/=1024; s=substr(s,2)
    }
    return int(x+0.5) substr(s,1,1)
}
{
    printf("%-4s %-6s ", $1, $2);
    h=sub(/^[0-9]+/, human($3));
    printf("%4s", $h);
    $1=$2=$3="";
    printf("%s\n", $0);
}'

    if [ $# -eq 0 ]
    then
	stat -c '%a %U %s %N' * | awk -e "$script"
    else
	for arg in $@
	do
	    if [ "$arg" = "." ]
	    then
		stat -c '%a %U %s %N' * | awk -e "$script"
	    else
		if [ "${arg: -1}" = "/" ]
		then
		    stat -c '%a %U %s %N' "$arg"* | awk -e "$script"
		else
		    stat -c '%a %U %s %N' "$arg"/* | awk -e "$script"
		fi
	    fi
	done
    fi
}
