" Global configs

set encoding=utf-8

if has('mouse')
  set mouse=a
endif

" typo for :w
command WQ wq
command Wq wq
command W w
command Q q
command X x
command Xa xa

" mergetool
nnoremap <F2> :diffget //2<CR>
nnoremap <F3> :diffget //3<CR>

" history scroller (from Practical Vim)
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" File types {{{
au! BufRead,BufNewFile *.ipl setfiletype ipl
au! BufRead,BufNewFile *.iml setfiletype iml
autocmd FileType iml nnoremap <silent> <leader>mf :w<CR> <bar> :silent !imlformat<CR>
" }}}

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
autocmd FileType haskell setlocal shiftwidth=2
autocmd FileType haskell setlocal tabstop=2
autocmd FileType haskell setlocal softtabstop=2
autocmd FileType ocaml setlocal shiftwidth=2
autocmd FileType ocaml setlocal tabstop=2
autocmd FileType ocaml setlocal softtabstop=2
autocmd FileType reason setlocal shiftwidth=2
autocmd FileType reason setlocal tabstop=2
autocmd FileType reason setlocal softtabstop=2
autocmd FileType vue setlocal shiftwidth=2
autocmd FileType vue setlocal tabstop=2
autocmd FileType vue setlocal softtabstop=2
autocmd FileType cpp setlocal shiftwidth=2
autocmd FileType cpp setlocal tabstop=2
autocmd FileType cpp setlocal softtabstop=2
autocmd FileType cuda setlocal shiftwidth=2
autocmd FileType cuda setlocal tabstop=2
autocmd FileType cuda setlocal softtabstop=2
autocmd FileType sh setlocal shiftwidth=2
autocmd FileType sh setlocal tabstop=2
autocmd FileType sh setlocal softtabstop=2
" }}} Spaces & Tabs

" Clipboard {{{
set clipboard+=unnamed
" }}} Clipboard

" live preview when search and replace
set inccommand=nosplit

" tab shortcuts {{{

" move tabs
nnoremap <silent> <A-Left> :tabm -1<CR>
nnoremap <silent> <A-Right> :tabm +1<CR>

" tabv to open a tab to readonly
cabbrev tabv tab sview +setlocal\ nomodifiable

" Use <F8> to toggle `tab ball` and `tabo`
let notabs = 0
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>
" }}} tab shortcuts

syntax on
filetype plugin indent on

" UI Config {{{
set number                   " show line number
set showcmd                  " show command in bottom bar
set wildmenu                 " visual autocomplete for command menu
set wildmode=longest:full,full
" set showmatch                " highlight matching brace
" }}} UI Config

" For StandardEbooks Production
autocmd FileType xhtml setlocal noexpandtab list listchars=tab:»·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·
" let Gdiffsplit wrap
autocmd FileType xhtml nnoremap <F6> :tabdo windo set wrap<CR>

" IML comment {{{
call tcomment#type#Define('iml',            '(* %s *)'         )
call tcomment#type#Define('iml_block',      "(*%s*)\n   "      )
call tcomment#type#Define('iml_inline',     '(* %s *)'         )
" }}} IML comment

" lean.nvim {
let maplocalleader = "\<Space>"
" }
