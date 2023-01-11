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

cs () {
    now="$(date '+%Y-%m-%d-%H-%M-%S')"
    printf "%b\n" "$@" > "${now}_clamscan_report.txt"
    clamscan --recursive --allmatch --detect-pua=yes --detect-structured=yes --heuristic-scan-precedence=yes --max-filesize=2048M --log="${now}_clamscan_report.txt" -- $@
    # clamscan --recursive --allmatch --detect-pua=yes --detect-structured=yes --heuristic-scan-precedence=yes --max-filesize=2048M -- $@ | tee "$@"_clam_report.txt
}

p () {
    if [ "$#" -eq "0" ]
    then
	id="$(pstree -alpsU | rofi -threads 0 -dmenu -i -p "Select a process" | awk '{print $1}' | awk -F',' '{print $2}')"
	# echo $id
	pstree -alpsU "$id"
	read -p "Kill this process?" -n 1 flagkill
	printf "%b\n" ""
	if [ "$flagkill" = "y" ]
	then
	    kill "$id"
	fi
	return
    fi

    if [ "$#" -eq "1" ]
    then
	id="$(pgrep $1)"
	num="$(wc -l <<< "$id")"
	if [ "$num" -eq "1" ]
	then
	    pstree -alpsU "$id"
	    read -p "Kill this process?" -n 1 flagkill
	    printf "%b\n" ""
	    if [ "$flagkill" = "y" ]
	    then
		kill "$id"
	    fi
	else
	    i=1
	    for oneid in $id
	    do
		printf "%b" "[$i] "
		pstree -U "$oneid"
		i=$((i + 1))
	    done
	    read -p "Kill one of these processes?" -n 1 flagkill
	    printf "%b\n" ""
	    if [ "$flagkill" = "y" ]
	    then
		read -p "Select process to kill: " flagid

		pstree -alpsU "$oneid" # TODO: Change to pid of $i
		read -p "Kill this process?" -n 1 flagkill2
		printf "%b\n" ""
		if [ "$flagkill2" = "y" ]
		then
		    kill "$id"
		fi
		#kill "$oneid"
	    fi
	fi
	return
    fi

    for arg in $@
    do
	id="$(pgrep $arg)"
	num="$(wc -l <<< "$id")"
	pstree -U "$id"
    done

    	# pstree -alpsU $ids
	# read -p "Kill process?" -n 1 flagkill
	# printf "%b\n" ""
	# if [ "$flagkill" = "y" ]
	# then
	#     kill $ids
	# fi

    #    pstree -alpsU "$id" #| rofi -threads 0 -dmenu -i -auto-select -p "Kill which process?"
    # pkill name
}

perms () {
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
	# access rights in octal | user name of owner | block size | quoted file name with dereference if symbolic link
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

c () {
    # in this instance, $* instead of $@ makes sense
    # otherwise, spaces between arguments get lost
    printf "%b" "$*" | xclip -selection clipboard
}
