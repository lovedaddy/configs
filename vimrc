set nocompatible
set expandtab
set nowrap
set shiftwidth=2
set softtabstop=2
set tabstop=2
set spell
set spellsuggest=6

"set ballooneval
"set balloondelay=400

set cursorline
set incsearch
set linespace=1
set novisualbell
set nobackup
set noerrorbells

set nu

syntax on

set foldenable

au BufRead,BufNewFile *.rb,*.rhtml set shiftwidth=2
au BufRead,BufNewFile *.rb,*.rhtml set softtabstop=2

au BufRead,BufNewFile *.go set shiftwidth=8
au BufRead,BufNewFile *.go set softtabstop=8
au BufRead,BufNewFile *.go set tabstop=8
au BufRead,BufNewFile *.go set noexpandtab

