set nocompatible						" Disable strange Vi defaults.
set autoindent 							" Autoindent when starting new line, or using `o` or `O`.
set backspace=indent,eol,start			" Allow backspace in insert mode.
set complete-=i							" Don't scan included files. The .tags file is more performant.
set smarttab							" Use 'shiftwidth' when using `<Tab>` in front of a line. By default it's used only for shift commands (`<`, `>`).
set nrformats-=octal					" Disable octal format for number processing.
set incsearch							" Enable highlighted case-insensitive incremential search.
set laststatus=2						" Always show window statuses, even if there's only one.
set ruler								" Show the line and column number of the cursor position.
set display+=lastline					" When 'wrap' is on, display last line even if it doesn't fit.
set encoding=utf-8						" Force utf-8 encoding
set autoread 							" Reload unchanged files automatically.
set sessionoptions-=options				" Don't save options in sessions
set viewoptions-=options				" Don't save options in views
set switchbuf=usetab					" If opening buffer, search first in opened windows.
set hidden								" Hide buffers instead of asking if to save them.
set cursorline							" Highlight line under cursor. It helps with navigation.
set cursorlineopt=number
set scrolloff=8							" Keep 8 lines above or below the cursor when scrolling.
set noerrorbells						" Disable any annoying beeps on errors.
set belloff=all
set nomodeline							" Don't parse modelines (google "vim modeline vulnerability").
set foldmethod=indent					" Folding Settings
set foldnestmax=3						
set nofoldenable
set noshowmode							" This is handled by lightline now
filetype plugin on
filetype indent on

" Allow for mappings including `Esc`, while preserving
" zero timeout after pressing it manually.
" (only vim needs a fix for this)
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif


" Increase history size to 1000 items.
if &history < 1000
  set history=1000
endif

" Allow for up to 50 opened tabs on Vim start.
if &tabpagemax < 50
  set tabpagemax=50
endif


" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif


" Autocomplete commands using nice menu in place of window status.
" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
set wildmenu

set termguicolors
set splitright
set tabstop=4
set shiftwidth=4
set completeopt=menu,menuone,noselect
set omnifunc=syntaxcomplete#Complete
set runtimepath-=~/.config/vimfiles
set runtimepath^=~/.config/vim


" Relative line setings (abridged from myusuf3/numbers.vim)
" excludes toggling when changing modes
	set number
	set relativenumber

	if (!exists('g:numbers_exclude'))
		let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree', 'Mundo', 'MundoDiff']
	endif

	function! CheckFtForRelNum()
		if index(g:numbers_exclude, &ft) >= 0
			setlocal norelativenumber
			setlocal nonumber
		endif
	endfunc

	augroup rel_numbers_check
		au!
		autocmd bufnewfile  * :call CheckFtForRelNum()
		autocmd bufreadpost * :call CheckFtForRelNum()
		autocmd winenter    * :setlocal relativenumber
		autocmd winleave    * :setlocal norelativenumber
	augroup end

" Vim Plug Init
	if !(has('win32') || has('win64'))
		let s:data_dir = has('nvim') ? stdpath('data') : '~/.config/vim'
	else 
		let s:data_dir = has('nvim') ? stdpath('data') : $USERPROFILE.'/.config/vim'
	endif
	if empty(glob(s:data_dir . '/autoload/plug.vim'))
		execute '!curl -fLo '.s:data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
	" autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
			" \| PlugInstall --sync | source $MYVIMRC
			" \| endif

	call plug#begin(has('nvim') ? stdpath('data').'/plugged' : (s:data_dir.'/plugged'))
		"=================== Core Features ===================
		Plug 'tpope/vim-fugitive'
		Plug 'sheerun/vim-polyglot'
		Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
		Plug 'junegunn/fzf.vim'
		Plug 'sbdchd/neoformat'
		Plug 'dense-analysis/ale'
		"=================== UI Plugins ===================
		Plug 'mhinz/vim-startify'
		Plug 'itchyny/lightline.vim',
		Plug 'mbbill/undotree'
		Plug 'ryanoasis/vim-devicons'
		Plug 'flazz/vim-colorschemes'
		Plug 'ap/vim-buftabline'
		Plug 'tribela/vim-transparent'
"		Plug 'liuchengxu/vim-which-key'
		"=================== Misc Plugins ===================
		Plug 'tpope/vim-commentary'
		Plug 'junegunn/vim-peekaboo'
		Plug 'raimondi/delimitMate'

	call plug#end()



" Colorschemeing
colorscheme papercolor

" ALE config
let g:ale_completion_enabled = 1
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" BufTabLine Config
let g:buftabline_numbers=2
let g:buftabline_indicators=1

" Lightline config
let g:lightline = {
      \ 'colorscheme': 'papercolor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
	  \ 'enable': {'tabline': 0 },
      \ }
autocmd VimEnter,BufEnter,WinEnter,BufDelete,FileChangedShellPost,BufReadPost * call lightline#update()


" Startify Config
let g:startify_change_to_vcs_root = 1
let g:startify_enable_unsafe = 1
let g:startify_lists=[{ 'type': 'files', 'header': ['   MRU']},]

let g:lambda_header = [
    \'',
     \'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
     \'⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀ ',
     \'⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀ ',
     \'⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀ ',
     \'⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀ ',
     \'⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀ ',
     \'⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀ ',
     \'⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀ ',
     \'⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀ ',
     \'⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿⠇⠀ ',
     \'⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿⡟⠀⠀ ',
     \'⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀ ',
     \'⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀ ',
     \'⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀ ',
     \'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
     \]

let g:startify_custom_header = startify#center(g:lambda_header)


" Nice keybinds
let mapleader = '\'
 
tnoremap <Esc> <C-\><C-n>
noremap  <Leader>p "+p
inoremap <M-F> <C-o>:Neoformat<CR>
nnoremap <M-F> :Neoformat<CR>

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

nnoremap <silent> <F5> :UndotreeToggle<CR>
