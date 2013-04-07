set nocompatible

" get rid of menu, -m and toolbar, -T in gVim
set guioptions-=m
set guioptions-=T

" setup all the defaults for tabs
set expandtab
set nowrap
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Turn on the spell checker & suggest 6 words when something is incorrect
"set spell
"set spelllang=gb
"set spellsuggest=6

" Turn on tooltips
"set ballooneval
"set balloondelay=400

" add the cursor line highlight
set cursorline
set incsearch
set linespace=1
set novisualbell

" disable all backup files
set nobackup
set nowritebackup
set noswapfile 

" disable all error sound notification
set noerrorbells

" set the filetype, plugins, indent to on
filetype plugin on
filetype indent on

set nu

syntax on

" set 256 colors to on
set t_Co=265

" set my colorscheme to molokai
colorscheme molokai

" enable code folding
set foldenable

set linespace=0

au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2
au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2
au BufRead,BufNewFile *.rb,*.rhtml set autoindent
au BufRead,BufNewFile *.rb,*.rhtml set smartindent

au BufRead,BufNewFile *.go set shiftwidth=8
au BufRead,BufNewFile *.go set softtabstop=8
au BufRead,BufNewFile *.go set tabstop=8
au BufRead,BufNewFile *.go set noexpandtab

