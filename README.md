# dotfiles

	git clone https://github.com/kurzkopfgleitbeutler/dotfiles ~/dotfiles
	~/dotfiles/setup.sh

~/dotfiles/.gitattributes:

	.profile filter=clean-env
	.gitconfig filter=clean-gitprofile

~/dotfiles/.git/config:

	[filter "clean-env"]
		clean = "sed -E 's/^(export my_[^\"]*\")[^\"]*/#\\1/'"
	[filter "clean-gitprofile"]
		clean = "sed -E 's/= (.*)/=/'"

use ssh for credentials:

        git remote -v
	git remote remove origin
	git remote add origin git@github.com:kurzkopfgleitbeutler/dotfiles.git
	git push --set-upstream origin master
