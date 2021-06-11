"disable modelines, they are a big security vulnerability
"set modelines=0

" Load vim-plug https://jordaneldredge.com/blog/why-i-switched-from-vundle-to-plug/
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
	execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
" https://github.com/junegunn/vim-plug
call plug#begin('~/.local/share/nvim/plugged')
" colorschemes
" Plug 'nanotech/jellybeans.vim'
" Plug 'joshdick/onedark.vim'
" language highlighting
Plug 'sheerun/vim-polyglot'
" IDE likeness
"Plug 'roxma/nvim-completion-manager'
"Plug 'roxma/nvim-cm-racer'
"Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins'}
call plug#end()

"set nowrap
"set showmode
"set showcmd
"set wildmode=list:longest
"set cursorline
"set scrolloff=3
"set sidescrolloff=5
"set relativenumber
"set undofile
"set undodir=~/dotfiles/nvim/undofiles

set hidden "This means that you can have unwritten changes to a file and open a new file using :e, without being forced to write or undo your changes first.
set title

"visualize whitespace
"set list

"toggle paste mode
"set pastetoggle=<F2>

"Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"terminal supports 256 colors
"set t_Co=256
"use 24-bit colors
set termguicolors
" set background=light
" colorscheme jellybeans
colo desert

"code folding
"set foldmethod=syntax
"use views for persistency
"autocmd BufWinLeave ?* mkview
"autocmd BufWinEnter ?* silent loadview
"let perl_fold=1

"searching
set smartcase
"...clear highlighting
nmap <silent> ,/ :nohlsearch<CR>

"set leader to space
let mapleader = "\<Space>"
"leader keymap
"...copy & paste to system clipboard with <Space>p and <Space>y
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
"...Quickly edit/reload the vimrc file
"nmap <silent> <leader>ev :e $MYVIMRC<CR>
"nmap <silent> <leader>sv :so $MYVIMRC<CR>
"nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

"keymap
"...use ; for commands, needs way less shift hitting than default
nnoremap ; :
cmap w!! w !sudo tee > /dev/null %
inoremap jk <Esc>

"make help appear in a vertical split on the bottomright instead of a horizontal one when invoking with :h
cabbrev h vert bo h

"number of context lines around cursor
set scrolloff=3
