"keep this first - it disables backwards compatibility to vi
set nocompatible

"disable modelines, they are a big security vulnerability
set modelines=0

"Use pathogen to easily modify the runtime path to include all plugins under the ~/.vim/bundle directory
filetype plugin indent on
syntax on

set nowrap
set autoindent
set showmode
set showcmd
set ttyfast
set wildmenu
set wildmode=list:longest
"set cursorline
set backspace=indent,eol,start
set laststatus=2
set encoding=utf-8
set scrolloff=3
set sidescrolloff=5
set relativenumber
set undofile
set undodir=~/dotfiles/vim/undofiles

set hidden "This means that you can have unwritten changes to a file and open a new file using :e, without being forced to write or undo your changes first.


"visualize whitespace
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
"...but not tabs in html files
autocmd filetype html,xml set listchars-=tab:>.

"toggle paste mode
set pastetoggle=<F2>

"Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"terminal supports 256 colors
set t_Co=256
"use 24-bit colors
"set termguicolors

"code folding
set foldmethod=syntax
"use views for persistency
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview
let perl_fold=1

"colorscheme
colo desert
"stuff used by molokai colorscheme
"let g:molokai_original = 1
"let g:rehash256 = 1

"searching
set smartcase incsearch hlsearch
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
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

"keymap
"...use ; for commands, needs way less shift hitting than default
nnoremap ; :
cmap w!! w !sudo tee > /dev/null %
inoremap jk <Esc>

"make help appear in a vertical split on the bottomright instead of a horizontal one when invoking with :h
cabbrev h vert bo h
