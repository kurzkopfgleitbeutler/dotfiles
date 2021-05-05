# dotfiles

	mkdir -p ~/yourbasehere/.config
	git clone https://github.com/kurzkopfgleitbeutler/dotfiles ~/yourbasehere/.config
	~/yourbasehere/.config/setup.sh

~/yourbasehere/.config/.gitattributes:

	.profile filter=clean-env
	.gitconfig filter=clean-gitprofile

~/yourbasehere/.config/.git/config:

	[filter "clean-env"]
		clean = "sed -E 's/^(export my_[^\"]*\")[^\"]*/#\\1/'"
	[filter "clean-gitprofile"]
		clean = "sed -E 's/= (.*)/=/'"
