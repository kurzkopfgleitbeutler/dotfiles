alias aus='shutdown now'
alias clamscan='clamscan --recursive --allmatch --detect-pua=yes --detect-structured=yes --heuristic-scan-precedence=yes --max-filesize=2048M'
alias clip='xclip -selection clipboard'
alias dla='youtube-dl -x -f bestaudio --write-description --restrict-filenames --add-metadata --xattrs --write-sub --sub-lang en,en-GB,de'
alias dlcv='youtube-dl --skip-download --continue --no-post-overwrites --no-overwrites --restrict-filenames --ignore-errors --output "%(playlist)s/subtitles/%(upload_date)s_%(playlist_index)s_%(title)s-%(id)s.%(ext)s" --write-sub --all-subs --batch-file urls --quiet > >(tee list_subs) && youtube-dl --continue --download-archive index --no-post-overwrites --no-overwrites --restrict-filenames --ignore-errors -f "worstvideo+worstaudio" --add-metadata --xattrs --output "%(playlist)s/%(upload_date)s_%(playlist_index)s_%(title)s-%(id)s.%(ext)s" --write-description --merge-output-format mkv --embed-subs --all-subs --batch-file urls --playlist-random --quiet > >(tee list)'
alias dlca='youtube-dl -x --continue --download-archive index --no-post-overwrites --no-overwrites --restrict-filenames --ignore-errors -f bestaudio --add-metadata --xattrs --output "%(playlist)s/%(upload_date)s_%(playlist_index)s_%(title)s-%(id)s.%(ext)s" --write-description --embed-subs --all-subs --batch-file urls --playlist-random | tee list'
alias dlma='youtube-dl -x --restrict-filenames --ignore-errors -f bestaudio --write-description --add-metadata --xattrs --write-sub --embed-subs --all-subs --batch-file urls'
alias dlmv='youtube-dl --restrict-filenames --ignore-errors -f bestvideo+bestaudio/best --write-description --add-metadata --xattrs --merge-output-format mkv --embed-subs --all-subs --batch-file urls'
alias old_dlp='youtube-dl -x --output "%(playlist_index)s_%(title)s-%(id)s.%(ext)s" --restrict-filenames --ignore-errors -f bestaudio --write-description --add-metadata --xattrs --write-sub --sub-lang en,en-GB,de --batch-file urls'
alias dlp='youtube-dl -x --continue --download-archive index --no-post-overwrites --no-overwrites --output "%(playlist_index)s_%(title)s-%(id)s.%(ext)s" --restrict-filenames --ignore-errors -f bestaudio --write-description --add-metadata --xattrs --write-sub --all-subs --batch-file urls && mkdir subtitles && mv *.vtt *.description subtitles'
alias dlv='youtube-dl -f bestvideo+bestaudio --write-description --restrict-filenames --add-metadata --xattrs --merge-output-format mkv --embed-subs --all-subs'
alias dvd='mpv dvd://1'
alias e='emacs-nox'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias ga='git add'
alias gb='git branch'
alias gch='git checkout'
alias gco='git commit'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log -3'
alias gpl='git pull'
alias gps='git push'
alias grep='grep --color=auto'
alias gs='git status'
alias l='ls -CFAlhv --color=auto --group-directories-first'
alias ll='tree -afpuhFi --dirsfirst -L 1 --'
alias m='mpv --no-audio-display --shuffle $(cat playlist.m3u|shuf)'
alias mkdir='mkdir -pv'
alias mv='mv -v'
alias psk='ps -ely | grep'
alias r='ranger'
alias raus='lsblk -e7; udisksctl unmount --no-user-interaction --block-device'
alias rein='lsblk -e7; udisksctl mount --no-user-interaction --block-device'
alias rm='rm -rf'
alias rmdir='rmdir --ignore-fail-on-non-empty -v'
alias rp='rsync -vaHAX'
alias today='touch $(date -I)_'
alias update='sudo apt update && apt list --upgradable && sudo apt upgrade && sudo apt autoremove && sudo apt-get autoclean && flatpak update && flatpak uninstall --delete-data --unused && sudo youtube-dl --update'
alias v='io.neovim.nvim'
alias workgit='ssh-agent; pass -c ssh-keygen; ssh-add ~/.ssh/github'
