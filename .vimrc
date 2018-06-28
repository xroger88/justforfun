" A sensible vimrc for Go development
"
" Please note that the following settings are some default that I used
" for years. However it might be not the case for you (and your
" environment). I highly encourage to change/adapt the vimrc to your own
" needs. Think of a vimrc as a garden that needs to be maintained and fostered
" throughout years. Keep it clean and useful - Fatih Arslan

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'}
Plug 'fatih/molokai'
: Plug 'honza/vim-snippets'
" Plug 'neomake/neomake'
call plug#end()

execute pathogen#infect()
execute pathogen#helptags()
syntax on

""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""
set nocompatible                " Enables us Vim specific features
filetype off                    " Reset filetype detection first ...
filetype plugin indent on       " ... and enable filetype detection
set ttyfast                     " Indicate fast terminal conn for faster redraw
if !has('nvim')
	set ttymouse=xterm2             " Indicate terminal type for mouse codes
	set ttyscroll=3                 " Speedup scrolling
endif
set laststatus=2                " Show status line always
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically read changed files
set autoindent                  " Enabile Autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set noerrorbells                " No beeps
" line numbers
set number                      " Show line numbers
:highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
set showcmd                     " Show me what I'm typing
set noswapfile                  " Don't use swapfile
set nobackup                    " Don't create annoying backup files
set splitright                  " Vertical windows should be split to right
set splitbelow                  " Horizontal windows should split to bottom
set autowrite                   " Automatically save before :next, :make etc.
set hidden                      " Buffer should still exist if window is closed
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set noshowmatch                 " Do not show matching brackets by flickering
set noshowmode                  " We show the mode with airline or lightline
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not it begins with upper case
set completeopt=menu,menuone    " Show popup menu, even if there is one entry
set pumheight=10                " Completion window max size
set nocursorcolumn              " Do not highlight column (speeds up highlighting)
set nocursorline                " Do not highlight cursor (speeds up highlighting)
set lazyredraw                  " Wait to redraw
" ctags
set tags=./tags,tags,~/commontags
" fzf --- fuzzy finder
set rtp+=~/.fzf


" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/vim/tmp/undo//
endif


""""""""""""""""""""""
"      Mappings      "
""""""""""""""""""""""

" Set leader shortcut to a comma ','. By default it's the backslash
" let mapleader = ","

" Jump to next error with Ctrl-n and previous error with Ctrl-m. Close the
" quickfix window with <leader>a
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Act like D and C
nnoremap Y y$

" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h


"""""""""""""""""""""
"      Plugins      "
"""""""""""""""""""""

" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>

" Default setting
set noexpandtab
set tabstop=2
set shiftwidth=2

augroup go
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" .vimrc auto update
" if has("autocmd")
"   autocmd bufwritepost .vimrc source $MYVIMRC
" endif

" For on-demend minpac packages
if &compatible
	" `:set nocp` has many side effects. Therefore this should be done
	" only when 'compatible' is set.
	set nocompatible
endif

if 1 " exists('*minpac#init')
	packadd minpac
	call minpac#init()
	" for easy editing
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-unimpaired')
	call minpac#add('tommcdo/vim-exchange')
	call minpac#add('AndrewRadev/splitjoin.vim')
	" for IDE plugins
	call minpac#add('scrooloose/nerdtree')
	call minpac#add('ctrlpvim/ctrlp.vim') 
	call minpac#add('wesleyche/SrcExpl')
	call minpac#add('SirVer/ultisnips')
	let g:UltiSnipsUsePythonVersion = 3
	call minpac#add('tpope/vim-scriptease', {'type':'opt'})
	call minpac#add('scrooloose/syntastic')
	call minpac#add('vim-airline/vim-airline')
	call minpac#add('airblade/vim-gitgutter')
	call minpac#add('tpope/vim-fugitive')

	" for interacting with tmux in vim
	call minpac#add('benmills/vimux')

	" --- for auto-completion
	call minpac#add('Shougo/deoplete.nvim')
	call minpac#add('zchee/deoplete-go', { 'do': 'make'})	

	if !has('nvim')
		call minpac#add('roxma/nvim-yarp')
		call minpac#add('roxma/vim-hug-neovim-rpc')
	endif

	" neocomplete like
	set completeopt+=noinsert
	" deoplete.nvim recommend
	set completeopt+=noselect

	" Path to python interpreter for neovim
	let g:python3_host_prog  = '/usr/bin/python3'
	" Skip the check of neovim module
	let g:python3_host_skip_check = 1

	" Run deoplete.nvim automatically
	let g:deoplete#enable_at_startup = 1
	" deoplete-go settings
	let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
	let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']


	" hot key for source exploration
	nmap <F7> :TlistToggle<CR>
	let Tlist_Use_Right_Window = 1
	let Tlist_GainFocus_On_ToggleOpen = 1
	nmap <F8> :SrcExplToggle<CR>
	nmap <F9> :NERDTreeToggle<CR>
	let NERDTreeWinPos = "left"

	" for coloring
	call minpac#add('lifepillar/vim-solarized8', {'type':'opt'})
	call minpac#add('nanotech/jellybeans.vim', {'type':'opt'})

	" for minpac itself update
	call minpac#add('t-takata/minpac', {'type':'opt'})
endif

" minpac commands:
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

" Colorscheme
syntax enable
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
" colorscheme molokai
colorscheme solarized8_light_flat

" key mapping in terminal mode (nvim)
if has('nvim')
  " Terminal mode:
  tnoremap <C-h> <c-\><c-n><c-w>h
  tnoremap <C-j> <c-\><c-n><c-w>j
  tnoremap <C-k> <c-\><c-n><c-w>k
  tnoremap <C-l> <c-\><c-n><c-w>l
  " Insert mode:
  inoremap <C-h> <Esc><c-w>h
  inoremap <C-j> <Esc><c-w>j
  inoremap <C-k> <Esc><c-w>k
  inoremap <C-l> <Esc><c-w>l
  " Visual mode:
  vnoremap <C-h> <Esc><c-w>h
  vnoremap <C-j> <Esc><c-w>j
  vnoremap <C-k> <Esc><c-w>k
  vnoremap <C-l> <Esc><c-w>l
  " Normal mode:
  nnoremap <C-h> <c-w>h
  nnoremap <C-j> <c-w>j
  nnoremap <C-k> <c-w>k
  nnoremap <C-l> <c-w>l
  nnoremap <silent> vv <c-w>s
endif
