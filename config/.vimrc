let g:skip_plug_load = 0
set nocompatible				" Disable strange Vi defaults.
set autoindent 					" Autoindent when starting new line, or using `o` or `O`.
set backspace=indent,eol,start	" Allow backspace in insert mode.
set complete-=i					" Don't scan included files. The .tags file is more performant.
set smarttab					" Use 'shiftwidth' when using `<Tab>` in front of a line. By default it's used only for shift commands (`<`, `>`).
set nrformats-=octal			" Disable octal format for number processing.
set incsearch					" Enable highlighted case-insensitive incremential search.
set laststatus=2				" Always show window statuses, even if there's only one.
set ruler						" Show the line and column number of the cursor position.
set display+=lastline			" When 'wrap' is on, display last line even if it doesn't fit.
set encoding=utf-8				" Force utf-8 encoding
set autoread 					" Reload unchanged files automatically.
set sessionoptions-=options		" Don't save options in sessions
set viewoptions-=options		" Don't save options in views
set switchbuf=usetab			" If opening buffer, search first in opened windows.
set hidden						" Hide buffers instead of asking if to save them.
set cursorline					" Highlight line under cursor. It helps with navigation.
set cursorlineopt=number
set scrolloff=8					" Keep 8 lines above or below the cursor when scrolling.
set noerrorbells				" Disable any annoying beeps on errors.
set belloff=all
set nomodeline					" Don't parse modelines (google "vim modeline vulnerability").
set foldmethod=indent			" Folding Settings
set foldnestmax=5
set nofoldenable
set noshowmode					" This is handled by lightline now
set re=1
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

" Relative line setings (abridged from myusuf3/numbers.vim)
" excludes toggling when changing modes
	set number
	set relativenumber

	if (!exists('g:numbers_exclude'))
		let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree', 'Mundo', 'MundoDiff']
	endif

	fun! CheckFtForRelNum()
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
" For NixOS where plugins are managed externally, gate this with a boolean that the flake
" Adds when creating the config based on this file
	if get(g:, 'skip_plug_load', 0) == 0
		set runtimepath-=~/.config/vimfiles
		set runtimepath^=~/.config/vim

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
			"=================== Misc Plugins ===================
			Plug 'junegunn/vim-peekaboo'
			Plug 'raimondi/delimitMate'

		call plug#end()
	endif

" ALE config
let g:ale_completion_enabled = 1
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Lightline config
let g:lightline = {
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


nnoremap <silent> <F5> :UndotreeToggle<CR>

" Port of the Papercolor Dark theme but less so it's portable by script
" Source: https://github.com/NLKNguyen/papercolor-theme/blob/0cfe64ffb24c21a6101b5f994ca342a74c977aef/colors/PaperColor.vim
" (Under MIT License)
	let s:palette = {
	\ 'color03': ['#d7af5f', '179'], 'color04': ['#5fafd7', '74' ], 'color05': ['#808080', '244'],
	\ 'color00': ['#1c1c1c', '234'], 'color01': ['#af005f', '125'], 'color02': ['#5faf00', '70' ],
	\ 'color06': ['#d7875f', '173'], 'color07': ['#d0d0d0', '252'], 'color08': ['#585858', '240'],
	\ 'color09': ['#5faf5f', '71' ], 'color10': ['#afd700', '148'], 'color11': ['#af87d7', '140'],
	\ 'color12': ['#ffaf00', '214'], 'color13': ['#ff5faf', '205'], 'color14': ['#00afaf', '37' ],
	\ 'color15': ['#5f8787', '66' ], 'color16': ['#5fafd7', '74' ], 'color17': ['#d7af00', '178'],
	\ 'cursor_fg':              ['#1c1c1c', '234'], 'cursor_bg':              ['#c6c6c6', '251'],
	\ 'cursorline':             ['#303030', '236'], 'cursorcolumn':           ['#303030', '236'],
	\ 'cursorlinenr_fg':        ['#ffff00', '226'], 'cursorlinenr_bg':        ['#1c1c1c', '234'],
	\ 'popupmenu_fg':           ['#c6c6c6', '251'], 'popupmenu_bg':           ['#303030', '236'],
	\ 'search_fg':              ['#000000', '16' ], 'search_bg':              ['#00875f', '29' ],
	\ 'incsearch_fg':           ['#00875f', '29' ], 'incsearch_bg':           ['#000000', '16' ],
	\ 'linenumber_fg':          ['#585858', '240'], 'linenumber_bg':          ['#1c1c1c', '234'],
	\ 'vertsplit_fg':           ['#5f8787', '66' ], 'vertsplit_bg' :          ['#1c1c1c', '234'],
	\ 'statusline_active_fg':   ['#1c1c1c', '234'], 'statusline_active_bg':   ['#5f8787', '66' ],
	\ 'statusline_inactive_fg': ['#bcbcbc', '250'], 'statusline_inactive_bg': ['#3a3a3a', '237'],
	\ 'todo_fg':                ['#ff8700', '208'], 'todo_bg':                ['#1c1c1c', '234'],
	\ 'error_fg':               ['#af005f', '125'], 'error_bg':               ['#5f0000', '52' ],
	\ 'matchparen_bg':          ['#4e4e4e', '239'], 'matchparen_fg':          ['#c6c6c6', '251'],
	\ 'visual_fg':              ['#000000', '16' ], 'visual_bg':              ['#8787af', '103'],
	\ 'folded_fg':              ['#d787ff', '177'], 'folded_bg':              ['#5f005f', '53' ],
	\ 'wildmenu_fg':            ['#1c1c1c', '234'], 'wildmenu_bg':            ['#afd700', '148'],
	\ 'spellbad':               ['#5f0000', '52' ], 'spellcap':               ['#5f005f', '53' ],
	\ 'spellrare':              ['#005f00', '22' ], 'spelllocal':             ['#00005f', '17' ],
	\ 'diffadd_fg':             ['#87d700', '112'], 'diffadd_bg':             ['#005f00', '22' ],
	\ 'diffdelete_fg':          ['#af005f', '125'], 'diffdelete_bg':          ['#5f0000', '52' ],
	\ 'difftext_fg':            ['#5fffff', '87' ], 'difftext_bg':            ['#008787', '30' ],
	\ 'diffchange_fg':          ['#d0d0d0', '252'], 'diffchange_bg':          ['#005f5f', '23' ],
	\ 'tabline_bg':             ['#262626', '235'],
	\ 'tabline_active_fg':      ['#121212', '233'], 'tabline_active_bg':      ['#00afaf', '37' ],
	\ 'tabline_inactive_fg':    ['#bcbcbc', '250'], 'tabline_inactive_bg':    ['#585858', '240'],
	\ 'buftabline_bg':          ['#262626', '235'],
	\ 'buftabline_current_fg':  ['#121212', '233'], 'buftabline_current_bg':  ['#00afaf', '37' ],
	\ 'buftabline_active_fg':   ['#00afaf', '37' ], 'buftabline_active_bg':   ['#585858', '240'],
	\ 'buftabline_inactive_fg': ['#bcbcbc', '250'], 'buftabline_inactive_bg': ['#585858', '240'],
	\}

	" Identify Color Mode + Set Formatting Attrs.:
	fun! s:identify_color_mode()
		let s:MODE_16_COLOR = 0
		let s:MODE_256_COLOR = 1
		let s:MODE_GUI_COLOR = 2
		if has("gui_running")  || has('termguicolors') && &termguicolors || has('nvim') && $NVIM_TUI_ENABLE_TRUE_COLOR
			let s:mode       = s:MODE_GUI_COLOR
			let s:ft_bold    = " cterm=bold gui=bold "
			let s:ft_none    = " cterm=none gui=none "
			let s:ft_reverse = " cterm=reverse gui=reverse "
			let s:ft_italic  = " cterm=italic gui=italic "
			let s:ft_italic_bold = " cterm=italic,bold gui=italic,bold "
		 elseif (&t_Co >= 256)
			let s:mode       = s:MODE_256_COLOR
			let s:ft_bold    = " cterm=bold "
			let s:ft_none    = " cterm=none "
			let s:ft_reverse = " cterm=reverse "
			let s:ft_italic  = " cterm=italic  "
			let s:ft_italic_bold = " cterm=italic,bold "
		 else
			let s:mode       = s:MODE_16_COLOR
			let s:ft_bold    = ""
			let s:ft_none    = " cterm=none "
			let s:ft_reverse = " cterm=reverse "
			let s:ft_italic  = ""
			let s:ft_italic_bold = ""
		 endif
	endfun

	" Set Color Variables:
	fun! s:set_color_variables()
		" Helper:
		" -------
		" Function to dynamically generate variables that store the color strings
		" for setting highlighting, used for optimization by reducing fn calls
		" Each color name will have 2 variables with prefix
		" s:fg_ and s:bg_. For example:
		" if a:color_name is 'Normal' and a:color_value is ['#000000', '0', 'Black'],
		" the following 2 variables will be created:
		"   s:fg_Normal that stores the string ' guifg=#000000 '
		"   s:bg_Normal that stores the string ' guibg=#000000 '
		" Depending on the color mode, ctermfg and ctermbg will be either 0 or Black
		if s:mode == s:MODE_GUI_COLOR
			fun! s:create_color_variables(color_name, rich_color, term_color)
				let {'s:fg_' . a:color_name} = ' guifg=' . a:rich_color[0] . ' '
				let {'s:bg_' . a:color_name} = ' guibg=' . a:rich_color[0] . ' '
				let {'s:sp_' . a:color_name} = ' guisp=' . a:rich_color[0] . ' '
			endfun
		elseif s:mode == s:MODE_256_COLOR
			fun! s:create_color_variables(color_name, rich_color, term_color)
				let {'s:fg_' . a:color_name} = ' ctermfg=' . a:rich_color[1] . ' '
				let {'s:bg_' . a:color_name} = ' ctermbg=' . a:rich_color[1] . ' '
				let {'s:sp_' . a:color_name} = ''
			endfun
		else
			fun! s:create_color_variables(color_name, rich_color, term_color)
				let {'s:fg_' . a:color_name} = ' ctermfg=' . a:term_color . ' '
				let {'s:bg_' . a:color_name} = ' ctermbg=' . a:term_color . ' '
				let {'s:sp_' . a:color_name} = ''
			endfun
		endif

		" Color value format: Array [<GUI COLOR/HEX >, <256-Base>, <16-Base>]
		" 16-Base is terminal's native color palette that can be alternated through
		" the terminal settings. The 16-color names are according to `:h cterm-colors`

		let color00 = get(s:palette, 'color00')
		let color01 = get(s:palette, 'color01')
		let color02 = get(s:palette, 'color02')
		let color03 = get(s:palette, 'color03')
		let color04 = get(s:palette, 'color04')
		let color05 = get(s:palette, 'color05')
		let color06 = get(s:palette, 'color06')
		let color07 = get(s:palette, 'color07')
		let color08 = get(s:palette, 'color08')
		let color09 = get(s:palette, 'color09')
		let color10 = get(s:palette, 'color10')
		let color11 = get(s:palette, 'color11')
		let color12 = get(s:palette, 'color12')
		let color13 = get(s:palette, 'color13')
		let color14 = get(s:palette, 'color14')
		let color15 = get(s:palette, 'color15')

		call s:create_color_variables('background', color00 , 'Black')
		call s:create_color_variables('negative',   color01 , 'DarkRed')
		call s:create_color_variables('positive',   color02 , 'DarkGreen')
		call s:create_color_variables('olive',      color03 , 'DarkYellow') " string
		call s:create_color_variables('neutral',    color04 , 'DarkBlue')
		call s:create_color_variables('comment',    color05 , 'DarkMagenta')
		call s:create_color_variables('navy',       color06 , 'DarkCyan') " storageclass
		call s:create_color_variables('foreground', color07 , 'LightGray')

		call s:create_color_variables('nontext',    color08 , 'DarkGray')
		call s:create_color_variables('red',        color09 , 'LightRed') " import / try/catch
		call s:create_color_variables('pink',       color10 , 'LightGreen') " statement, type
		call s:create_color_variables('purple',     color11 , 'LightYellow') " if / conditional
		call s:create_color_variables('accent',     color12 , 'LightBlue')
		call s:create_color_variables('orange',     color13 , 'LightMagenta') " number
		call s:create_color_variables('blue',       color14 , 'LightCyan') " other keyword
		call s:create_color_variables('highlight',  color15 , 'White')

		" EXTENDED COLORS:
		" From here on, all colors are optional and must have default values (3rd parameter of the
		" `get` command) that point to the above basic colors in case the target theme doesn't
		" provide the extended colors. The default values should be reasonably sensible.
		" The terminal color must be provided also.
		call s:create_color_variables('aqua',  get(s:palette, 'color16', color14) , 'LightCyan')
		call s:create_color_variables('green', get(s:palette, 'color17', color13) , 'LightMagenta')
		call s:create_color_variables('wine',  get(s:palette, 'color18', color11) , 'LightYellow')
		" LineNumber: when set number
		call s:create_color_variables('linenumber_fg', get(s:palette, 'linenumber_fg', color08) , 'DarkGray')
		call s:create_color_variables('linenumber_bg', get(s:palette, 'linenumber_bg', color00) , 'Black')
		" Vertical Split: when there are more than 1 window side by side, ex: <C-W><C-V>
		call s:create_color_variables('vertsplit_fg', get(s:palette, 'vertsplit_fg', color15) , 'White')
		call s:create_color_variables('vertsplit_bg', get(s:palette, 'vertsplit_bg', color00) , 'Black')
		" Statusline: when set status=2
		call s:create_color_variables('statusline_active_fg', get(s:palette, 'statusline_active_fg', color00) , 'Black')
		call s:create_color_variables('statusline_active_bg', get(s:palette, 'statusline_active_bg', color15) , 'White')
		call s:create_color_variables('statusline_inactive_fg', get(s:palette, 'statusline_inactive_fg', color07) , 'LightGray')
		call s:create_color_variables('statusline_inactive_bg', get(s:palette, 'statusline_inactive_bg', color08) , 'DarkGray')
		" Cursor: in normal mode
		call s:create_color_variables('cursor_fg', get(s:palette, 'cursor_fg', color00) , 'Black')
		call s:create_color_variables('cursor_bg', get(s:palette, 'cursor_bg', color07) , 'LightGray')
		call s:create_color_variables('cursorline', get(s:palette, 'cursorline', color00) , 'Black')
		" CursorColumn: when set cursorcolumn
		call s:create_color_variables('cursorcolumn', get(s:palette, 'cursorcolumn', color00) , 'Black')
		" CursorLine Number: when set cursorline number
		call s:create_color_variables('cursorlinenr_fg', get(s:palette, 'cursorlinenr_fg', color13) , 'LightMagenta')
		call s:create_color_variables('cursorlinenr_bg', get(s:palette, 'cursorlinenr_bg', color00) , 'Black')
		" Popup Menu: when <C-X><C-N> for autocomplete
		call s:create_color_variables('popupmenu_fg', get(s:palette, 'popupmenu_fg', color07) , 'LightGray')
		call s:create_color_variables('popupmenu_bg', get(s:palette, 'popupmenu_bg', color08) , 'DarkGray') " TODO: double check this, might resolve an issue
		" Search: ex: when * on a word
		call s:create_color_variables('search_fg', get(s:palette, 'search_fg', color00) , 'Black')
		call s:create_color_variables('search_bg', get(s:palette, 'search_bg', color15) , 'Yellow')
		" IncSearch: ex: during a search
		call s:create_color_variables('incsearch_fg', get(s:palette, 'incsearch_fg', color00) , 'Black')
		call s:create_color_variables('incsearch_bg', get(s:palette, 'incsearch_bg', color15) , 'Yellow')
		" Todo: ex: TODO
		call s:create_color_variables('todo_fg', get(s:palette, 'todo_fg', color05) , 'LightYellow')
		call s:create_color_variables('todo_bg', get(s:palette, 'todo_bg', color00) , 'Black')
		" Error: ex: turn spell on and have invalid words
		call s:create_color_variables('error_fg', get(s:palette, 'error_fg', color01) , 'DarkRed')
		call s:create_color_variables('error_bg', get(s:palette, 'error_bg', color00) , 'Black')
		" Match Parenthesis: selecting an opening/closing pair and the other one will be highlighted
		call s:create_color_variables('matchparen_fg', get(s:palette, 'matchparen_fg', color00) , 'LightMagenta')
		call s:create_color_variables('matchparen_bg', get(s:palette, 'matchparen_bg', color05) , 'Black')
		" Visual:
		call s:create_color_variables('visual_fg', get(s:palette, 'visual_fg', color08) , 'Black')
		call s:create_color_variables('visual_bg', get(s:palette, 'visual_bg', color07) , 'White')
		" Folded:
		call s:create_color_variables('folded_fg', get(s:palette, 'folded_fg', color00) , 'Black')
		call s:create_color_variables('folded_bg', get(s:palette, 'folded_bg', color05) , 'DarkYellow')
		" WildMenu: Autocomplete command, ex: :color <tab><tab>
		call s:create_color_variables('wildmenu_fg', get(s:palette, 'wildmenu_fg', color00) , 'Black')
		call s:create_color_variables('wildmenu_bg', get(s:palette, 'wildmenu_bg', color06) , 'LightGray')
		" Tabline: when having tabs, ex: :tabnew
		call s:create_color_variables('tabline_bg',          get(s:palette, 'tabline_bg',          color00) , 'Black')
		call s:create_color_variables('tabline_active_fg',   get(s:palette, 'tabline_active_fg',   color07) , 'LightGray')
		call s:create_color_variables('tabline_active_bg',   get(s:palette, 'tabline_active_bg',   color00) , 'Black')
		call s:create_color_variables('tabline_inactive_fg', get(s:palette, 'tabline_inactive_fg', color07) , 'Black')
		call s:create_color_variables('tabline_inactive_bg', get(s:palette, 'tabline_inactive_bg', color08) , 'DarkMagenta')
		" Spelling: when spell on and there are spelling problems like this for example: papercolor. a vim color scheme
		call s:create_color_variables('spellbad', get(s:palette, 'spellbad', color04) , 'DarkRed')
		call s:create_color_variables('spellcap', get(s:palette, 'spellcap', color05) , 'DarkMagenta')
		call s:create_color_variables('spellrare', get(s:palette, 'spellrare', color06) , 'DarkYellow')
		call s:create_color_variables('spelllocal', get(s:palette, 'spelllocal', color01) , 'DarkBlue')
		" Diff:
		call s:create_color_variables('diffadd_fg', get(s:palette, 'diffadd_fg', color00) , 'Black')
		call s:create_color_variables('diffadd_bg', get(s:palette, 'diffadd_bg', color02) , 'DarkGreen')
		call s:create_color_variables('diffdelete_fg', get(s:palette, 'diffdelete_fg', color00) , 'Black')
		call s:create_color_variables('diffdelete_bg', get(s:palette, 'diffdelete_bg', color04) , 'DarkRed')
		call s:create_color_variables('difftext_fg', get(s:palette, 'difftext_fg', color00) , 'Black')
		call s:create_color_variables('difftext_bg', get(s:palette, 'difftext_bg', color06) , 'DarkYellow')
		call s:create_color_variables('diffchange_fg', get(s:palette, 'diffchange_fg', color00) , 'Black')
		call s:create_color_variables('diffchange_bg', get(s:palette, 'diffchange_bg', color14) , 'LightYellow')
		call s:create_color_variables('buftabline_bg',          get(s:palette, 'buftabline_bg',          color00) , 'Black')
		call s:create_color_variables('buftabline_current_fg',  get(s:palette, 'buftabline_current_fg',  color07) , 'LightGray')
		call s:create_color_variables('buftabline_current_bg',  get(s:palette, 'buftabline_current_bg',  color05) , 'DarkMagenta')
		call s:create_color_variables('buftabline_active_fg',   get(s:palette, 'buftabline_active_fg',   color07) , 'LightGray')
		call s:create_color_variables('buftabline_active_bg',   get(s:palette, 'buftabline_active_bg',   color12) , 'LightBlue')
		call s:create_color_variables('buftabline_inactive_fg', get(s:palette, 'buftabline_inactive_fg', color07) , 'LightGray')
		call s:create_color_variables('buftabline_inactive_bg', get(s:palette, 'buftabline_inactive_bg', color00) , 'Black')

		" Neovim terminal colors https://neovim.io/doc/user/nvim_terminal_emulator.html#nvim-terminal-emulator-configuration
		" TODO: Fix this
		let g:terminal_color_0  = color00[0]
		let g:terminal_color_1  = color01[0]
		let g:terminal_color_2  = color02[0]
		let g:terminal_color_3  = color03[0]
		let g:terminal_color_4  = color04[0]
		let g:terminal_color_5  = color05[0]
		let g:terminal_color_6  = color06[0]
		let g:terminal_color_7  = color07[0]
		let g:terminal_color_8  = color08[0]
		let g:terminal_color_9  = color09[0]
		let g:terminal_color_10 = color10[0]
		let g:terminal_color_11 = color11[0]
		let g:terminal_color_12 = color12[0]
		let g:terminal_color_13 = color13[0]
		let g:terminal_color_14 = color14[0]
		let g:terminal_color_15 = color15[0]

		" Vim 8's :terminal buffer ANSI colors
		if has('terminal')
		let g:terminal_ansi_colors = [color00[0], color01[0], color02[0], color03[0],
			\ color04[0], color05[0], color06[0], color07[0], color08[0], color09[0],
			\ color10[0], color11[0], color12[0], color13[0], color14[0], color15[0]]
		endif
	endfun

	" Apply Syntax Highlightings: {{{

	fun! s:apply_syntax_highlightings()
		exec 'hi Normal' . s:fg_foreground . s:bg_background
		set background=dark
		exec 'hi EndOfBuffer' . s:fg_cursor_fg  . s:ft_none
		exec 'hi NonText' . s:fg_nontext . s:bg_background
		exec 'hi LineNr' . s:fg_linenumber_fg . s:bg_linenumber_bg
		exec 'hi Conceal' . s:fg_linenumber_fg . s:bg_linenumber_bg
		exec 'hi VertSplit' . s:fg_vertsplit_bg . s:bg_vertsplit_fg
		exec 'hi FoldColumn' . s:fg_folded_fg . s:bg_background . s:ft_none
		exec 'hi Cursor' . s:fg_cursor_fg . s:bg_cursor_bg
		exec 'hi SpecialKey' . s:fg_nontext
		exec 'hi Search' . s:fg_search_fg . s:bg_search_bg
		exec 'hi IncSearch' . s:fg_incsearch_fg . s:bg_incsearch_bg
		exec 'hi StatusLine' . s:fg_statusline_active_bg . s:bg_statusline_active_fg
		exec 'hi StatusLineNC' . s:fg_statusline_inactive_bg . s:bg_statusline_inactive_fg
		exec 'hi StatusLineTerm' . s:fg_statusline_active_bg . s:bg_statusline_active_fg
		exec 'hi StatusLineTermNC' . s:fg_statusline_inactive_bg . s:bg_statusline_inactive_fg
		exec 'hi Visual' . s:fg_visual_fg . s:bg_visual_bg
		exec 'hi Directory' . s:fg_blue
		exec 'hi ModeMsg' . s:fg_olive
		exec 'hi MoreMsg' . s:fg_olive
		exec 'hi Question' . s:fg_olive
		exec 'hi WarningMsg' . s:fg_pink
		exec 'hi MatchParen' . s:fg_matchparen_fg . s:bg_matchparen_bg
		exec 'hi Folded' . s:fg_folded_fg . s:bg_folded_bg
		exec 'hi WildMenu' . s:fg_wildmenu_fg . s:bg_wildmenu_bg . s:ft_bold

		if version >= 700
			exec 'hi CursorLine'  . s:bg_cursorline . s:ft_none
			if s:mode == s:MODE_16_COLOR
				exec 'hi CursorLineNr' . s:fg_cursorlinenr_fg . s:bg_cursorlinenr_bg
			else
				exec 'hi CursorLineNr' . s:fg_cursorlinenr_fg . s:bg_cursorlinenr_bg . s:ft_none
			endif
			exec 'hi CursorColumn'  . s:bg_cursorcolumn . s:ft_none
			exec 'hi PMenu' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none
			exec 'hi PMenuSel' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_reverse
			exec 'hi SignColumn' . s:fg_green . s:bg_background . s:ft_none
		end
		if version >= 703
			exec 'hi ColorColumn'  . s:bg_cursorcolumn . s:ft_none
		end

		exec 'hi TabLine' . s:fg_tabline_inactive_fg . s:bg_tabline_inactive_bg . s:ft_none
		exec 'hi TabLineFill' . s:fg_tabline_bg . s:bg_tabline_bg . s:ft_none
		exec 'hi TabLineSel' . s:fg_tabline_active_fg . s:bg_tabline_active_bg . s:ft_none

		exec 'hi BufTabLineCurrent' . s:fg_buftabline_current_fg . s:bg_buftabline_current_bg . s:ft_none
		exec 'hi BufTabLineActive' . s:fg_buftabline_active_fg . s:bg_buftabline_active_bg . s:ft_none
		exec 'hi BufTabLineHidden' . s:fg_buftabline_inactive_fg . s:bg_buftabline_inactive_bg . s:ft_none
		exec 'hi BufTabLineFill'  . s:bg_buftabline_bg . s:ft_none

		" Standard Group Highlighting:
		exec 'hi Comment' . s:fg_comment . s:ft_italic
		exec 'hi Constant' . s:fg_orange
		exec 'hi String' . s:fg_olive
		exec 'hi Character' . s:fg_olive
		exec 'hi Number' . s:fg_orange
		exec 'hi Boolean' . s:fg_green . s:ft_bold
		exec 'hi Float' . s:fg_orange
		exec 'hi Identifier' . s:fg_navy
		exec 'hi Function' . s:fg_foreground
		exec 'hi Statement' . s:fg_pink . s:ft_none
		exec 'hi Conditional' . s:fg_purple . s:ft_bold
		exec 'hi Repeat' . s:fg_purple . s:ft_bold
		exec 'hi Label' . s:fg_blue
		exec 'hi Operator' . s:fg_aqua . s:ft_none
		exec 'hi Keyword' . s:fg_blue
		exec 'hi Exception' . s:fg_red
		exec 'hi PreProc' . s:fg_blue
		exec 'hi Include' . s:fg_red
		exec 'hi Define' . s:fg_blue
		exec 'hi Macro' . s:fg_blue
		exec 'hi PreCondit' . s:fg_aqua
		exec 'hi Type' . s:fg_pink . s:ft_bold
		exec 'hi StorageClass' . s:fg_navy . s:ft_bold
		exec 'hi Structure' . s:fg_blue . s:ft_bold
		exec 'hi Typedef' . s:fg_pink . s:ft_bold
		exec 'hi Special' . s:fg_foreground
		exec 'hi SpecialChar' . s:fg_foreground
		exec 'hi Tag' . s:fg_green
		exec 'hi Delimiter' . s:fg_aqua
		exec 'hi SpecialComment' . s:fg_comment . s:ft_bold
		exec 'hi Debug' . s:fg_orange
		exec 'hi Error' . s:fg_error_fg . s:bg_error_bg
		exec 'hi Todo' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold
		exec 'hi Title' . s:fg_comment
		exec 'hi Global' . s:fg_blue

		" VimL Highlighting
		exec 'hi vimCommand' . s:fg_pink
		exec 'hi vimVar' . s:fg_navy
		exec 'hi vimFuncKey' . s:fg_pink
		exec 'hi vimFunction' . s:fg_blue . s:ft_bold
		exec 'hi vimNotFunc' . s:fg_pink
		exec 'hi vimMap' . s:fg_red
		exec 'hi vimAutoEvent' . s:fg_aqua . s:ft_bold
		exec 'hi vimMapModKey' . s:fg_aqua
		exec 'hi vimFuncName' . s:fg_purple
		exec 'hi vimIsCommand' . s:fg_foreground
		exec 'hi vimFuncVar' . s:fg_aqua
		exec 'hi vimLet' . s:fg_red
		exec 'hi vimContinue' . s:fg_aqua
		exec 'hi vimMapRhsExtend' . s:fg_foreground
		exec 'hi vimCommentTitle' . s:fg_comment . s:ft_italic_bold
		exec 'hi vimBracket' . s:fg_aqua
		exec 'hi vimParenSep' . s:fg_aqua
		exec 'hi vimNotation' . s:fg_aqua
		exec 'hi vimOper' . s:fg_foreground
		exec 'hi vimOperParen' . s:fg_foreground
		exec 'hi vimSynType' . s:fg_purple
		exec 'hi vimSynReg' . s:fg_pink . s:ft_none
		exec 'hi vimSynRegion' . s:fg_foreground
		exec 'hi vimSynMtchGrp' . s:fg_pink
		exec 'hi vimSynNextgroup' . s:fg_pink
		exec 'hi vimSynKeyRegion' . s:fg_green
		exec 'hi vimSynRegOpt' . s:fg_blue
		exec 'hi vimSynMtchOpt' . s:fg_blue
		exec 'hi vimSynContains' . s:fg_pink
		exec 'hi vimGroupName' . s:fg_foreground
		exec 'hi vimGroupList' . s:fg_foreground
		exec 'hi vimHiGroup' . s:fg_foreground
		exec 'hi vimGroup' . s:fg_navy . s:ft_bold
		exec 'hi vimOnlyOption' . s:fg_blue

		" Makefile Highlighting
		exec 'hi makeIdent' . s:fg_blue
		exec 'hi makeSpecTarget' . s:fg_olive
		exec 'hi makeTarget' . s:fg_red
		exec 'hi makeStatement' . s:fg_aqua . s:ft_bold
		exec 'hi makeCommands' . s:fg_foreground
		exec 'hi makeSpecial' . s:fg_orange . s:ft_bold

		" CMake Highlighting (Builtin)
		exec 'hi cmakeStatement' . s:fg_blue
		exec 'hi cmakeArguments' . s:fg_foreground
		exec 'hi cmakeVariableValue' . s:fg_pink

		" CMake Highlighting (Plugin: https://github.com/pboettch/vim-cmake-syntax)
		exec 'hi cmakeCommand' . s:fg_blue
		exec 'hi cmakeCommandConditional' . s:fg_purple . s:ft_bold
		exec 'hi cmakeKWset' . s:fg_orange
		exec 'hi cmakeKWvariable_watch' . s:fg_orange
		exec 'hi cmakeKWif' . s:fg_orange
		exec 'hi cmakeArguments' . s:fg_foreground
		exec 'hi cmakeKWproject' . s:fg_pink
		exec 'hi cmakeGeneratorExpressions' . s:fg_orange
		exec 'hi cmakeGeneratorExpression' . s:fg_aqua
		exec 'hi cmakeVariable' . s:fg_pink
		exec 'hi cmakeProperty' . s:fg_aqua
		exec 'hi cmakeKWforeach' . s:fg_aqua
		exec 'hi cmakeKWunset' . s:fg_aqua
		exec 'hi cmakeKWmacro' . s:fg_aqua
		exec 'hi cmakeKWget_property' . s:fg_aqua
		exec 'hi cmakeKWset_tests_properties' . s:fg_aqua
		exec 'hi cmakeKWmessage' . s:fg_aqua
		exec 'hi cmakeKWinstall_targets' . s:fg_orange
		exec 'hi cmakeKWsource_group' . s:fg_orange
		exec 'hi cmakeKWfind_package' . s:fg_aqua
		exec 'hi cmakeKWstring' . s:fg_olive
		exec 'hi cmakeKWinstall' . s:fg_aqua
		exec 'hi cmakeKWtarget_sources' . s:fg_orange

		" C Highlighting
		exec 'hi cType' . s:fg_pink . s:ft_bold
		exec 'hi cFormat' . s:fg_olive
		exec 'hi cStorageClass' . s:fg_navy . s:ft_bold

		exec 'hi cBoolean' . s:fg_green . s:ft_bold
		exec 'hi cCharacter' . s:fg_olive
		exec 'hi cConstant' . s:fg_green . s:ft_bold
		exec 'hi cConditional' . s:fg_purple . s:ft_bold
		exec 'hi cSpecial' . s:fg_olive . s:ft_bold
		exec 'hi cDefine' . s:fg_blue
		exec 'hi cNumber' . s:fg_orange
		exec 'hi cPreCondit' . s:fg_aqua
		exec 'hi cRepeat' . s:fg_purple . s:ft_bold
		exec 'hi cLabel' . s:fg_aqua
		exec 'hi cDelimiter' . s:fg_blue
		exec 'hi cOperator' . s:fg_aqua
		exec 'hi cCustomParen' . s:fg_foreground
		exec 'hi cOctalZero' . s:fg_purple . s:ft_bold
		exec 'hi cFunction' . s:fg_blue

		" CPP highlighting
		exec 'hi cppBoolean' . s:fg_green . s:ft_bold
		exec 'hi cppSTLnamespace' . s:fg_purple
		exec 'hi cppSTLexception' . s:fg_pink
		exec 'hi cppSTLfunctional' . s:fg_foreground . s:ft_bold
		exec 'hi cppSTLiterator' . s:fg_foreground . s:ft_bold
		exec 'hi cppExceptions' . s:fg_red
		exec 'hi cppStatement' . s:fg_blue
		exec 'hi cppStorageClass' . s:fg_navy . s:ft_bold
		exec 'hi cppAccess' . s:fg_orange . s:ft_bold
		exec 'hi cppSTLconstant' . s:fg_green . s:ft_bold
		exec 'hi cppSTLtype' . s:fg_pink . s:ft_bold
		exec 'hi cppSTLfunction' . s:fg_blue
		exec 'hi cppSTLios' . s:fg_olive . s:ft_bold

		" Rust highlighting
		exec 'hi rustKeyword' . s:fg_pink
		exec 'hi rustModPath' . s:fg_blue
		exec 'hi rustModPathSep' . s:fg_blue
		exec 'hi rustLifetime' . s:fg_purple
		exec 'hi rustStructure' . s:fg_aqua . s:ft_bold
		exec 'hi rustAttribute' . s:fg_aqua . s:ft_bold
		exec 'hi rustPanic' . s:fg_olive . s:ft_bold
		exec 'hi rustTrait' . s:fg_blue . s:ft_bold
		exec 'hi rustEnum' . s:fg_green . s:ft_bold
		exec 'hi rustEnumVariant' . s:fg_green
		exec 'hi rustSelf' . s:fg_orange
		exec 'hi rustSigil' . s:fg_aqua . s:ft_bold
		exec 'hi rustOperator' . s:fg_aqua . s:ft_bold
		exec 'hi rustMacro' . s:fg_olive . s:ft_bold
		exec 'hi rustMacroVariable' . s:fg_olive
		exec 'hi rustAssert' . s:fg_olive . s:ft_bold
		exec 'hi rustConditional' . s:fg_purple . s:ft_bold

		" Lex highlighting
		exec 'hi lexCFunctions' . s:fg_foreground
		exec 'hi lexAbbrv' . s:fg_purple
		exec 'hi lexAbbrvRegExp' . s:fg_aqua
		exec 'hi lexAbbrvComment' . s:fg_comment
		exec 'hi lexBrace' . s:fg_navy
		exec 'hi lexPat' . s:fg_aqua
		exec 'hi lexPatComment' . s:fg_comment
		exec 'hi lexPatTag' . s:fg_orange
		" exec 'hi lexPatBlock' . s:fg_foreground . s:ft_bold
		exec 'hi lexSlashQuote' . s:fg_foreground
		exec 'hi lexSep' . s:fg_foreground
		exec 'hi lexStartState' . s:fg_orange
		exec 'hi lexPatTagZone' . s:fg_olive . s:ft_bold
		exec 'hi lexMorePat' . s:fg_olive . s:ft_bold
		exec 'hi lexOptions' . s:fg_olive . s:ft_bold
		exec 'hi lexPatString' . s:fg_olive

		" Yacc highlighting
		exec 'hi yaccNonterminal' . s:fg_navy
		exec 'hi yaccDelim' . s:fg_orange
		exec 'hi yaccInitKey' . s:fg_aqua
		exec 'hi yaccInit' . s:fg_navy
		exec 'hi yaccKey' . s:fg_purple
		exec 'hi yaccVar' . s:fg_aqua

		" NASM highlighting
		exec 'hi nasmStdInstruction' . s:fg_navy
		exec 'hi nasmGen08Register' . s:fg_aqua
		exec 'hi nasmGen16Register' . s:fg_aqua
		exec 'hi nasmGen32Register' . s:fg_aqua
		exec 'hi nasmGen64Register' . s:fg_aqua
		exec 'hi nasmHexNumber' . s:fg_purple
		exec 'hi nasmStorage' . s:fg_aqua . s:ft_bold
		exec 'hi nasmLabel' . s:fg_pink
		exec 'hi nasmDirective' . s:fg_blue . s:ft_bold
		exec 'hi nasmLocalLabel' . s:fg_orange

		" GAS highlighting
		exec 'hi gasSymbol' . s:fg_pink
		exec 'hi gasDirective' . s:fg_blue . s:ft_bold
		exec 'hi gasOpcode_386_Base' . s:fg_navy
		exec 'hi gasDecimalNumber' . s:fg_purple
		exec 'hi gasSymbolRef' . s:fg_pink
		exec 'hi gasRegisterX86' . s:fg_blue
		exec 'hi gasOpcode_P6_Base' . s:fg_navy
		exec 'hi gasDirectiveStore' . s:fg_foreground . s:ft_bold

		" MIPS highlighting
		exec 'hi mipsInstruction' . s:fg_pink
		exec 'hi mipsRegister' . s:fg_navy
		exec 'hi mipsLabel' . s:fg_aqua . s:ft_bold
		exec 'hi mipsDirective' . s:fg_purple . s:ft_bold

		" Shell/Bash highlighting
		exec 'hi bashStatement' . s:fg_foreground . s:ft_bold
		exec 'hi shDerefVar' . s:fg_aqua . s:ft_bold
		exec 'hi shDerefSimple' . s:fg_aqua
		exec 'hi shFunction' . s:fg_orange . s:ft_bold
		exec 'hi shStatement' . s:fg_foreground
		exec 'hi shLoop' . s:fg_purple . s:ft_bold
		exec 'hi shQuote' . s:fg_olive
		exec 'hi shCaseEsac' . s:fg_aqua . s:ft_bold
		exec 'hi shSnglCase' . s:fg_purple . s:ft_none
		exec 'hi shFunctionOne' . s:fg_navy
		exec 'hi shCase' . s:fg_navy
		exec 'hi shSetList' . s:fg_navy
		" @see Dockerfile Highlighting section for more sh*

		" PowerShell Highlighting
		exec 'hi ps1Type' . s:fg_green . s:ft_bold
		exec 'hi ps1Variable' . s:fg_navy
		exec 'hi ps1Boolean' . s:fg_navy . s:ft_bold
		exec 'hi ps1FunctionInvocation' . s:fg_pink
		exec 'hi ps1FunctionDeclaration' . s:fg_pink
		exec 'hi ps1Keyword' . s:fg_blue . s:ft_bold
		exec 'hi ps1Exception' . s:fg_red
		exec 'hi ps1Operator' . s:fg_aqua . s:ft_bold
		exec 'hi ps1CommentDoc' . s:fg_purple
		exec 'hi ps1CDocParam' . s:fg_orange

		" HTML Highlighting
		exec 'hi htmlTitle' . s:fg_green . s:ft_bold
		exec 'hi htmlH1' . s:fg_green . s:ft_bold
		exec 'hi htmlH2' . s:fg_aqua . s:ft_bold
		exec 'hi htmlH3' . s:fg_purple . s:ft_bold
		exec 'hi htmlH4' . s:fg_orange . s:ft_bold
		exec 'hi htmlTag' . s:fg_comment
		exec 'hi htmlTagName' . s:fg_wine
		exec 'hi htmlArg' . s:fg_pink
		exec 'hi htmlEndTag' . s:fg_comment
		exec 'hi htmlString' . s:fg_blue
		exec 'hi htmlScriptTag' . s:fg_comment
		exec 'hi htmlBold' . s:fg_foreground . s:ft_bold
		exec 'hi htmlItalic' . s:fg_comment . s:ft_italic
		exec 'hi htmlBoldItalic' . s:fg_navy . s:ft_italic_bold
		" exec 'hi htmlLink' . s:fg_blue . s:ft_bold
		exec 'hi htmlTagN' . s:fg_wine . s:ft_bold
		exec 'hi htmlSpecialTagName' . s:fg_wine
		exec 'hi htmlComment' . s:fg_comment . s:ft_italic
		exec 'hi htmlCommentPart' . s:fg_comment . s:ft_italic

		" CSS Highlighting
		exec 'hi cssIdentifier' . s:fg_pink
		exec 'hi cssPositioningProp' . s:fg_foreground
		exec 'hi cssNoise' . s:fg_foreground
		exec 'hi cssBoxProp' . s:fg_foreground
		exec 'hi cssTableAttr' . s:fg_purple
		exec 'hi cssPositioningAttr' . s:fg_navy
		exec 'hi cssValueLength' . s:fg_orange
		exec 'hi cssFunctionName' . s:fg_blue
		exec 'hi cssUnitDecorators' . s:fg_aqua
		exec 'hi cssColor' . s:fg_blue . s:ft_bold
		exec 'hi cssBraces' . s:fg_pink
		exec 'hi cssBackgroundProp' . s:fg_foreground
		exec 'hi cssTextProp' . s:fg_foreground
		exec 'hi cssDimensionProp' . s:fg_foreground
		exec 'hi cssClassName' . s:fg_pink

		" Markdown Highlighting
		exec 'hi markdownHeadingRule' . s:fg_pink . s:ft_bold
		exec 'hi markdownH1' . s:fg_pink . s:ft_bold
		exec 'hi markdownH2' . s:fg_orange . s:ft_bold
		exec 'hi markdownBlockquote' . s:fg_pink
		exec 'hi markdownCodeBlock' . s:fg_olive
		exec 'hi markdownCode' . s:fg_olive
		exec 'hi markdownLink' . s:fg_blue . s:ft_bold
		exec 'hi markdownUrl' . s:fg_blue
		exec 'hi markdownLinkText' . s:fg_pink
		exec 'hi markdownLinkTextDelimiter' . s:fg_purple
		exec 'hi markdownLinkDelimiter' . s:fg_purple
		exec 'hi markdownCodeDelimiter' . s:fg_blue

		exec 'hi mkdCode' . s:fg_olive
		exec 'hi mkdLink' . s:fg_blue . s:ft_bold
		exec 'hi mkdURL' . s:fg_comment
		exec 'hi mkdString' . s:fg_foreground
		exec 'hi mkdBlockQuote' . s:fg_pink
		exec 'hi mkdLinkTitle' . s:fg_pink
		exec 'hi mkdDelimiter' . s:fg_aqua
		exec 'hi mkdRule' . s:fg_pink

		" reStructuredText Highlighting
		exec 'hi rstSections' . s:fg_pink . s:ft_bold
		exec 'hi rstDelimiter' . s:fg_pink . s:ft_bold
		exec 'hi rstExplicitMarkup' . s:fg_pink . s:ft_bold
		exec 'hi rstDirective' . s:fg_blue
		exec 'hi rstHyperlinkTarget' . s:fg_green
		exec 'hi rstExDirective' . s:fg_foreground
		exec 'hi rstInlineLiteral' . s:fg_olive
		exec 'hi rstInterpretedTextOrHyperlinkReference' . s:fg_blue

		" Python Highlighting
		exec 'hi pythonImport' . s:fg_pink . s:ft_bold
		exec 'hi pythonExceptions' . s:fg_red
		exec 'hi pythonException' . s:fg_purple . s:ft_bold
		exec 'hi pythonInclude' . s:fg_red
		exec 'hi pythonStatement' . s:fg_pink
		exec 'hi pythonConditional' . s:fg_purple . s:ft_bold
		exec 'hi pythonRepeat' . s:fg_purple . s:ft_bold
		exec 'hi pythonFunction' . s:fg_aqua . s:ft_bold
		exec 'hi pythonPreCondit' . s:fg_purple
		exec 'hi pythonExClass' . s:fg_orange
		exec 'hi pythonOperator' . s:fg_purple . s:ft_bold
		exec 'hi pythonBuiltin' . s:fg_foreground
		exec 'hi pythonDecorator' . s:fg_orange

		exec 'hi pythonString' . s:fg_olive
		exec 'hi pythonEscape' . s:fg_olive . s:ft_bold
		exec 'hi pythonStrFormatting' . s:fg_olive . s:ft_bold

		exec 'hi pythonBoolean' . s:fg_green . s:ft_bold
		exec 'hi pythonBytesEscape' . s:fg_olive . s:ft_bold
		exec 'hi pythonDottedName' . s:fg_purple
		exec 'hi pythonStrFormat' . s:fg_foreground

		exec 'hi pythonBuiltinFunc' . s:fg_blue
		exec 'hi pythonBuiltinObj' . s:fg_red

		" Java Highlighting
		exec 'hi javaExternal' . s:fg_pink
		exec 'hi javaAnnotation' . s:fg_orange
		exec 'hi javaTypedef' . s:fg_aqua
		exec 'hi javaClassDecl' . s:fg_aqua . s:ft_bold
		exec 'hi javaScopeDecl' . s:fg_blue . s:ft_bold
		exec 'hi javaStorageClass' . s:fg_navy . s:ft_bold
		exec 'hi javaBoolean' . s:fg_green . s:ft_bold
		exec 'hi javaConstant' . s:fg_blue
		exec 'hi javaCommentTitle' . s:fg_wine
		exec 'hi javaDocTags' . s:fg_aqua
		exec 'hi javaDocComment' . s:fg_comment
		exec 'hi javaDocParam' . s:fg_foreground
		exec 'hi javaStatement' . s:fg_pink

		" JavaScript Highlighting
		exec 'hi javaScriptBraces' . s:fg_blue
		exec 'hi javaScriptParens' . s:fg_blue
		exec 'hi javaScriptIdentifier' . s:fg_pink
		exec 'hi javaScriptFunction' . s:fg_blue . s:ft_bold
		exec 'hi javaScriptConditional' . s:fg_purple . s:ft_bold
		exec 'hi javaScriptRepeat' . s:fg_purple . s:ft_bold
		exec 'hi javaScriptBoolean' . s:fg_green . s:ft_bold
		exec 'hi javaScriptNumber' . s:fg_orange
		exec 'hi javaScriptMember' . s:fg_navy
		exec 'hi javaScriptReserved' . s:fg_navy
		exec 'hi javascriptNull' . s:fg_comment . s:ft_bold
		exec 'hi javascriptGlobal' . s:fg_foreground
		exec 'hi javascriptStatement' . s:fg_pink
		exec 'hi javaScriptMessage' . s:fg_foreground
		exec 'hi javaScriptMember' . s:fg_foreground

		" TypeScript Highlighting
		exec 'hi typescriptDecorators' . s:fg_orange
		exec 'hi typescriptLabel' . s:fg_purple . s:ft_bold

		" @target https://github.com/pangloss/vim-javascript
		exec 'hi jsImport' . s:fg_pink . s:ft_bold
		exec 'hi jsExport' . s:fg_pink . s:ft_bold
		exec 'hi jsModuleAs' . s:fg_pink . s:ft_bold
		exec 'hi jsFrom' . s:fg_pink . s:ft_bold
		exec 'hi jsExportDefault' . s:fg_pink . s:ft_bold
		exec 'hi jsFuncParens' . s:fg_blue
		exec 'hi jsFuncBraces' . s:fg_blue
		exec 'hi jsParens' . s:fg_blue
		exec 'hi jsBraces' . s:fg_blue
		exec 'hi jsNoise' . s:fg_blue

		" Jsx Highlighting
		" @target https://github.com/MaxMEllon/vim-jsx-pretty
		exec 'hi jsxTagName' . s:fg_wine
		exec 'hi jsxComponentName' . s:fg_wine
		exec 'hi jsxAttrib' . s:fg_pink
		exec 'hi jsxEqual' . s:fg_comment
		exec 'hi jsxString' . s:fg_blue
		exec 'hi jsxCloseTag' . s:fg_comment
		exec 'hi jsxCloseString' . s:fg_comment
		exec 'hi jsxDot' . s:fg_wine
		exec 'hi jsxNamespace' . s:fg_wine
		exec 'hi jsxPunct' . s:fg_comment

		" Json Highlighting
		" @target https://github.com/elzr/vim-json
		exec 'hi jsonKeyword' . s:fg_blue
		exec 'hi jsonString' . s:fg_olive
		exec 'hi jsonQuote' . s:fg_comment
		exec 'hi jsonNoise' . s:fg_foreground
		exec 'hi jsonKeywordMatch' . s:fg_foreground
		exec 'hi jsonBraces' . s:fg_foreground
		exec 'hi jsonNumber' . s:fg_orange
		exec 'hi jsonNull' . s:fg_purple . s:ft_bold
		exec 'hi jsonBoolean' . s:fg_green . s:ft_bold
		exec 'hi jsonCommentError' . s:fg_pink . s:bg_background

		" Go Highlighting
		exec 'hi goDirective' . s:fg_red
		exec 'hi goDeclaration' . s:fg_blue . s:ft_bold
		exec 'hi goStatement' . s:fg_pink
		exec 'hi goConditional' . s:fg_purple . s:ft_bold
		exec 'hi goConstants' . s:fg_orange
		exec 'hi goFunction' . s:fg_orange
		" exec 'hi goTodo' . s:fg_comment . s:ft_bold
		exec 'hi goDeclType' . s:fg_blue
		exec 'hi goBuiltins' . s:fg_purple

		" Systemtap Highlighting
		" exec 'hi stapBlock' . s:fg_comment . s:ft_none
		exec 'hi stapComment' . s:fg_comment . s:ft_none
		exec 'hi stapProbe' . s:fg_aqua . s:ft_bold
		exec 'hi stapStat' . s:fg_navy . s:ft_bold
		exec 'hi stapFunc' . s:fg_foreground
		exec 'hi stapString' . s:fg_olive
		exec 'hi stapTarget' . s:fg_navy
		exec 'hi stapStatement' . s:fg_pink
		exec 'hi stapType' . s:fg_pink . s:ft_bold
		exec 'hi stapSharpBang' . s:fg_comment
		exec 'hi stapDeclaration' . s:fg_pink
		exec 'hi stapCMacro' . s:fg_blue

		" DTrace Highlighting
		exec 'hi dtraceProbe' . s:fg_blue
		exec 'hi dtracePredicate' . s:fg_purple . s:ft_bold
		exec 'hi dtraceComment' . s:fg_comment
		exec 'hi dtraceFunction' . s:fg_foreground
		exec 'hi dtraceAggregatingFunction' . s:fg_blue . s:ft_bold
		exec 'hi dtraceStatement' . s:fg_navy . s:ft_bold
		exec 'hi dtraceIdentifier' . s:fg_pink
		exec 'hi dtraceOption' . s:fg_pink
		exec 'hi dtraceConstant' . s:fg_orange
		exec 'hi dtraceType' . s:fg_pink . s:ft_bold

		" PlantUML Highlighting
		exec 'hi plantumlPreProc' . s:fg_orange . s:ft_bold
		exec 'hi plantumlDirectedOrVerticalArrowRL' . s:fg_pink
		exec 'hi plantumlDirectedOrVerticalArrowLR' . s:fg_pink
		exec 'hi plantumlString' . s:fg_olive
		exec 'hi plantumlActivityThing' . s:fg_purple
		exec 'hi plantumlText' . s:fg_navy
		exec 'hi plantumlClassPublic' . s:fg_olive . s:ft_bold
		exec 'hi plantumlClassPrivate' . s:fg_red
		exec 'hi plantumlColonLine' . s:fg_orange
		exec 'hi plantumlClass' . s:fg_navy
		exec 'hi plantumlHorizontalArrow' . s:fg_pink
		exec 'hi plantumlTypeKeyword' . s:fg_blue . s:ft_bold
		exec 'hi plantumlKeyword' . s:fg_pink . s:ft_bold

		exec 'hi plantumlType' . s:fg_blue . s:ft_bold
		exec 'hi plantumlBlock' . s:fg_pink . s:ft_bold
		exec 'hi plantumlPreposition' . s:fg_orange
		exec 'hi plantumlLayout' . s:fg_blue . s:ft_bold
		exec 'hi plantumlNote' . s:fg_orange
		exec 'hi plantumlLifecycle' . s:fg_aqua
		exec 'hi plantumlParticipant' . s:fg_foreground . s:ft_bold

		" Haskell Highlighting
		exec 'hi haskellType' . s:fg_aqua . s:ft_bold
		exec 'hi haskellIdentifier' . s:fg_orange . s:ft_bold
		exec 'hi haskellOperators' . s:fg_pink
		exec 'hi haskellWhere' . s:fg_foreground . s:ft_bold
		exec 'hi haskellDelimiter' . s:fg_aqua
		exec 'hi haskellImportKeywords' . s:fg_pink
		exec 'hi haskellStatement' . s:fg_purple . s:ft_bold

		" SQL/MySQL Highlighting
		exec 'hi sqlStatement' . s:fg_pink . s:ft_bold
		exec 'hi sqlType' . s:fg_blue . s:ft_bold
		exec 'hi sqlKeyword' . s:fg_pink
		exec 'hi sqlOperator' . s:fg_aqua
		exec 'hi sqlSpecial' . s:fg_green . s:ft_bold

		exec 'hi mysqlVariable' . s:fg_olive . s:ft_bold
		exec 'hi mysqlType' . s:fg_blue . s:ft_bold
		exec 'hi mysqlKeyword' . s:fg_pink
		exec 'hi mysqlOperator' . s:fg_aqua
		exec 'hi mysqlSpecial' . s:fg_green . s:ft_bold

		" Octave/MATLAB Highlighting
		exec 'hi octaveVariable' . s:fg_foreground
		exec 'hi octaveDelimiter' . s:fg_pink
		exec 'hi octaveQueryVar' . s:fg_foreground
		exec 'hi octaveSemicolon' . s:fg_purple
		exec 'hi octaveFunction' . s:fg_navy
		exec 'hi octaveSetVar' . s:fg_blue
		exec 'hi octaveUserVar' . s:fg_foreground
		exec 'hi octaveArithmeticOperator' . s:fg_aqua
		exec 'hi octaveBeginKeyword' . s:fg_purple . s:ft_bold
		exec 'hi octaveElseKeyword' . s:fg_purple . s:ft_bold
		exec 'hi octaveEndKeyword' . s:fg_purple . s:ft_bold
		exec 'hi octaveStatement' . s:fg_pink

		" Ruby Highlighting
		exec 'hi rubyModule' . s:fg_navy . s:ft_bold
		exec 'hi rubyClass' . s:fg_pink . s:ft_bold
		exec 'hi rubyPseudoVariable' . s:fg_comment . s:ft_bold
		exec 'hi rubyKeyword' . s:fg_pink
		exec 'hi rubyInstanceVariable' . s:fg_purple
		exec 'hi rubyFunction' . s:fg_foreground . s:ft_bold
		exec 'hi rubyDefine' . s:fg_pink
		exec 'hi rubySymbol' . s:fg_aqua
		exec 'hi rubyConstant' . s:fg_blue
		exec 'hi rubyAccess' . s:fg_navy
		exec 'hi rubyAttribute' . s:fg_green
		exec 'hi rubyInclude' . s:fg_red
		exec 'hi rubyLocalVariableOrMethod' . s:fg_orange
		exec 'hi rubyCurlyBlock' . s:fg_foreground
		exec 'hi rubyCurlyBlockDelimiter' . s:fg_aqua
		exec 'hi rubyArrayDelimiter' . s:fg_aqua
		exec 'hi rubyStringDelimiter' . s:fg_olive
		exec 'hi rubyInterpolationDelimiter' . s:fg_orange
		exec 'hi rubyConditional' . s:fg_purple . s:ft_bold
		exec 'hi rubyRepeat' . s:fg_purple . s:ft_bold
		exec 'hi rubyControl' . s:fg_purple . s:ft_bold
		exec 'hi rubyException' . s:fg_purple . s:ft_bold
		exec 'hi rubyExceptional' . s:fg_purple . s:ft_bold
		exec 'hi rubyBoolean' . s:fg_green . s:ft_bold

		" Fortran Highlighting
		exec 'hi fortranUnitHeader' . s:fg_blue . s:ft_bold
		exec 'hi fortranIntrinsic' . s:fg_blue . s:bg_background . s:ft_none
		exec 'hi fortranType' . s:fg_pink . s:ft_bold
		exec 'hi fortranTypeOb' . s:fg_pink . s:ft_bold
		exec 'hi fortranStructure' . s:fg_aqua
		exec 'hi fortranStorageClass' . s:fg_navy . s:ft_bold
		exec 'hi fortranStorageClassR' . s:fg_navy . s:ft_bold
		exec 'hi fortranKeyword' . s:fg_pink
		exec 'hi fortranReadWrite' . s:fg_aqua . s:ft_bold
		exec 'hi fortranIO' . s:fg_navy
		exec 'hi fortranOperator' . s:fg_aqua . s:ft_bold
		exec 'hi fortranCall' . s:fg_aqua . s:ft_bold
		exec 'hi fortranContinueMark' . s:fg_green

		" ALGOL Highlighting (Plugin: https://github.com/sterpe/vim-algol68)
		exec 'hi algol68Statement' . s:fg_blue . s:ft_bold
		exec 'hi algol68Operator' . s:fg_aqua . s:ft_bold
		exec 'hi algol68PreProc' . s:fg_green
		exec 'hi algol68Function' . s:fg_blue

		" R Highlighting
		exec 'hi rType' . s:fg_blue
		exec 'hi rArrow' . s:fg_pink
		exec 'hi rDollar' . s:fg_blue

		" XXD Highlighting
		exec 'hi xxdAddress' . s:fg_navy
		exec 'hi xxdSep' . s:fg_pink
		exec 'hi xxdAscii' . s:fg_pink
		exec 'hi xxdDot' . s:fg_aqua

		" PHP Highlighting
		exec 'hi phpIdentifier' . s:fg_foreground
		exec 'hi phpVarSelector' . s:fg_pink
		exec 'hi phpKeyword' . s:fg_blue
		exec 'hi phpRepeat' . s:fg_purple . s:ft_bold
		exec 'hi phpConditional' . s:fg_purple . s:ft_bold
		exec 'hi phpStatement' . s:fg_pink
		exec 'hi phpAssignByRef' . s:fg_aqua . s:ft_bold
		exec 'hi phpSpecialFunction' . s:fg_blue
		exec 'hi phpFunctions' . s:fg_blue
		exec 'hi phpComparison' . s:fg_aqua
		exec 'hi phpBackslashSequences' . s:fg_olive . s:ft_bold
		exec 'hi phpMemberSelector' . s:fg_blue
		exec 'hi phpStorageClass' . s:fg_purple . s:ft_bold
		exec 'hi phpDefine' . s:fg_navy
		exec 'hi phpIntVar' . s:fg_navy . s:ft_bold

		" Perl Highlighting
		exec 'hi perlFiledescRead' . s:fg_green
		exec 'hi perlMatchStartEnd' . s:fg_pink
		exec 'hi perlStatementFlow' . s:fg_pink
		exec 'hi perlStatementStorage' . s:fg_pink
		exec 'hi perlFunction' . s:fg_pink . s:ft_bold
		exec 'hi perlMethod' . s:fg_foreground
		exec 'hi perlStatementFiledesc' . s:fg_orange
		exec 'hi perlVarPlain' . s:fg_navy
		exec 'hi perlSharpBang' . s:fg_comment
		exec 'hi perlStatementInclude' . s:fg_aqua . s:ft_bold
		exec 'hi perlStatementScalar' . s:fg_purple
		exec 'hi perlSubName' . s:fg_aqua . s:ft_bold
		exec 'hi perlSpecialString' . s:fg_olive . s:ft_bold

		" Pascal Highlighting
		exec 'hi pascalType' . s:fg_pink . s:ft_bold
		exec 'hi pascalStatement' . s:fg_blue . s:ft_bold
		exec 'hi pascalPredefined' . s:fg_pink
		exec 'hi pascalFunction' . s:fg_foreground
		exec 'hi pascalStruct' . s:fg_navy . s:ft_bold
		exec 'hi pascalOperator' . s:fg_aqua . s:ft_bold
		exec 'hi pascalPreProc' . s:fg_green
		exec 'hi pascalAcces' . s:fg_navy . s:ft_bold

		" Lua Highlighting
		exec 'hi luaFunc' . s:fg_foreground
		exec 'hi luaIn' . s:fg_blue . s:ft_bold
		exec 'hi luaFunction' . s:fg_pink
		exec 'hi luaStatement' . s:fg_blue
		exec 'hi luaRepeat' . s:fg_blue . s:ft_bold
		exec 'hi luaCondStart' . s:fg_purple . s:ft_bold
		exec 'hi luaTable' . s:fg_aqua . s:ft_bold
		exec 'hi luaConstant' . s:fg_green . s:ft_bold
		exec 'hi luaElse' . s:fg_purple . s:ft_bold
		exec 'hi luaCondElseif' . s:fg_purple . s:ft_bold
		exec 'hi luaCond' . s:fg_purple . s:ft_bold
		exec 'hi luaCondEnd' . s:fg_purple

		" Clojure highlighting:
		exec 'hi clojureConstant' . s:fg_blue
		exec 'hi clojureBoolean' . s:fg_orange
		exec 'hi clojureCharacter' . s:fg_olive
		exec 'hi clojureKeyword' . s:fg_pink
		exec 'hi clojureNumber' . s:fg_orange
		exec 'hi clojureString' . s:fg_olive
		exec 'hi clojureRegexp' . s:fg_purple
		exec 'hi clojureRegexpEscape' . s:fg_pink
		exec 'hi clojureParen' . s:fg_aqua
		exec 'hi clojureVariable' . s:fg_olive
		exec 'hi clojureCond' . s:fg_blue
		exec 'hi clojureDefine' . s:fg_blue . s:ft_bold
		exec 'hi clojureException' . s:fg_red
		exec 'hi clojureFunc' . s:fg_navy
		exec 'hi clojureMacro' . s:fg_blue
		exec 'hi clojureRepeat' . s:fg_blue
		exec 'hi clojureSpecial' . s:fg_blue . s:ft_bold
		exec 'hi clojureQuote' . s:fg_blue
		exec 'hi clojureUnquote' . s:fg_blue
		exec 'hi clojureMeta' . s:fg_blue
		exec 'hi clojureDeref' . s:fg_blue
		exec 'hi clojureAnonArg' . s:fg_blue
		exec 'hi clojureRepeat' . s:fg_blue
		exec 'hi clojureDispatch' . s:fg_aqua

		" Dockerfile Highlighting
		" @target https://github.com/docker/docker/tree/master/contrib/syntax/vim
		exec 'hi dockerfileKeyword' . s:fg_blue
		exec 'hi shDerefVar' . s:fg_purple . s:ft_bold
		exec 'hi shOperator' . s:fg_aqua
		exec 'hi shOption' . s:fg_navy
		exec 'hi shLine' . s:fg_foreground
		exec 'hi shWrapLineOperator' . s:fg_pink

		" NGINX Highlighting
		" @target https://github.com/evanmiller/nginx-vim-syntax
		exec 'hi ngxDirectiveBlock' . s:fg_pink . s:ft_bold
		exec 'hi ngxDirective' . s:fg_blue . s:ft_none
		exec 'hi ngxDirectiveImportant' . s:fg_blue . s:ft_bold
		exec 'hi ngxString' . s:fg_olive
		exec 'hi ngxVariableString' . s:fg_purple
		exec 'hi ngxVariable' . s:fg_purple . s:ft_none

		" Yaml Highlighting
		exec 'hi yamlBlockMappingKey' . s:fg_blue
		exec 'hi yamlKeyValueDelimiter' . s:fg_pink
		exec 'hi yamlBlockCollectionItemStart' . s:fg_pink

		" Qt QML Highlighting
		exec 'hi qmlObjectLiteralType' . s:fg_pink
		exec 'hi qmlReserved' . s:fg_purple
		exec 'hi qmlBindingProperty' . s:fg_navy
		exec 'hi qmlType' . s:fg_navy

		" Dosini Highlighting
		exec 'hi dosiniHeader' . s:fg_pink
		exec 'hi dosiniLabel' . s:fg_blue

		" Mail highlighting
		exec 'hi mailHeaderKey' . s:fg_blue
		exec 'hi mailHeaderEmail' . s:fg_purple
		exec 'hi mailSubject' . s:fg_pink
		exec 'hi mailHeader' . s:fg_comment
		exec 'hi mailURL' . s:fg_aqua
		exec 'hi mailEmail' . s:fg_purple
		exec 'hi mailQuoted1' . s:fg_olive
		exec 'hi mailQuoted2' . s:fg_navy

		" XML Highlighting
		exec 'hi xmlProcessingDelim' . s:fg_pink
		exec 'hi xmlString' . s:fg_olive
		exec 'hi xmlEqual' . s:fg_orange
		exec 'hi xmlAttrib' . s:fg_navy
		exec 'hi xmlAttribPunct' . s:fg_pink
		exec 'hi xmlTag' . s:fg_blue
		exec 'hi xmlTagName' . s:fg_blue
		exec 'hi xmlEndTag' . s:fg_blue
		exec 'hi xmlNamespace' . s:fg_orange

		" Elixir Highlighting
		" @target https://github.com/elixir-lang/vim-elixir
		exec 'hi elixirAlias' . s:fg_blue . s:ft_bold
		exec 'hi elixirAtom' . s:fg_navy
		exec 'hi elixirVariable' . s:fg_navy
		exec 'hi elixirUnusedVariable' . s:fg_foreground . s:ft_bold
		exec 'hi elixirInclude' . s:fg_purple
		exec 'hi elixirStringDelimiter' . s:fg_olive
		exec 'hi elixirKeyword' . s:fg_purple . s:ft_bold
		exec 'hi elixirFunctionDeclaration' . s:fg_aqua . s:ft_bold
		exec 'hi elixirBlockDefinition' . s:fg_pink
		exec 'hi elixirDefine' . s:fg_pink
		exec 'hi elixirStructDefine' . s:fg_pink
		exec 'hi elixirPrivateDefine' . s:fg_pink
		exec 'hi elixirModuleDefine' . s:fg_pink
		exec 'hi elixirProtocolDefine' . s:fg_pink
		exec 'hi elixirImplDefine' . s:fg_pink
		exec 'hi elixirModuleDeclaration' . s:fg_aqua . s:ft_bold
		exec 'hi elixirDocString' . s:fg_olive
		exec 'hi elixirDocTest' . s:fg_green . s:ft_bold

		" Erlang Highlighting
		exec 'hi erlangBIF' . s:fg_purple . s:ft_bold
		exec 'hi erlangBracket' . s:fg_pink
		exec 'hi erlangLocalFuncCall' . s:fg_foreground
		exec 'hi erlangVariable' . s:fg_foreground
		exec 'hi erlangAtom' . s:fg_navy
		exec 'hi erlangAttribute' . s:fg_blue . s:ft_bold
		exec 'hi erlangRecordDef' . s:fg_blue . s:ft_bold
		exec 'hi erlangRecord' . s:fg_blue
		exec 'hi erlangRightArrow' . s:fg_blue . s:ft_bold
		exec 'hi erlangStringModifier' . s:fg_olive . s:ft_bold
		exec 'hi erlangInclude' . s:fg_blue . s:ft_bold
		exec 'hi erlangKeyword' . s:fg_pink
		exec 'hi erlangGlobalFuncCall' . s:fg_foreground

		" Cucumber Highlighting
		exec 'hi cucumberFeature' . s:fg_blue . s:ft_bold
		exec 'hi cucumberBackground' . s:fg_pink . s:ft_bold
		exec 'hi cucumberScenario' . s:fg_pink . s:ft_bold
		exec 'hi cucumberGiven' . s:fg_orange
		exec 'hi cucumberGivenAnd' . s:fg_blue
		exec 'hi cucumberThen' . s:fg_orange
		exec 'hi cucumberThenAnd' . s:fg_blue
		exec 'hi cucumberWhen' . s:fg_purple . s:ft_bold
		exec 'hi cucumberScenarioOutline' . s:fg_pink . s:ft_bold
		exec 'hi cucumberExamples' . s:fg_aqua
		exec 'hi cucumberTags' . s:fg_aqua
		exec 'hi cucumberPlaceholder' . s:fg_aqua

		" Ada Highlighting
		exec 'hi adaInc' . s:fg_aqua . s:ft_bold
		exec 'hi adaSpecial' . s:fg_aqua . s:ft_bold
		exec 'hi adaKeyword' . s:fg_pink
		exec 'hi adaBegin' . s:fg_pink
		exec 'hi adaEnd' . s:fg_pink
		exec 'hi adaTypedef' . s:fg_navy . s:ft_bold
		exec 'hi adaAssignment' . s:fg_aqua . s:ft_bold
		exec 'hi adaAttribute' . s:fg_green

		" COBOL Highlighting
		exec 'hi cobolMarker' . s:fg_comment . s:bg_cursorline
		exec 'hi cobolLine' . s:fg_foreground
		exec 'hi cobolReserved' . s:fg_blue
		exec 'hi cobolDivision' . s:fg_pink . s:ft_bold
		exec 'hi cobolDivisionName' . s:fg_pink . s:ft_bold
		exec 'hi cobolSection' . s:fg_navy . s:ft_bold
		exec 'hi cobolSectionName' . s:fg_navy . s:ft_bold
		exec 'hi cobolParagraph' . s:fg_purple
		exec 'hi cobolParagraphName' . s:fg_purple
		exec 'hi cobolDeclA' . s:fg_purple
		exec 'hi cobolDecl' . s:fg_green
		exec 'hi cobolCALLs' . s:fg_aqua . s:ft_bold
		exec 'hi cobolEXECs' . s:fg_aqua . s:ft_bold

		" GNU sed highlighting
		exec 'hi sedST' . s:fg_purple . s:ft_bold
		exec 'hi sedFlag' . s:fg_purple . s:ft_bold
		exec 'hi sedRegexp47' . s:fg_pink
		exec 'hi sedRegexpMeta' . s:fg_blue . s:ft_bold
		exec 'hi sedReplacement47' . s:fg_olive
		exec 'hi sedReplaceMeta' . s:fg_orange . s:ft_bold
		exec 'hi sedAddress' . s:fg_pink
		exec 'hi sedFunction' . s:fg_aqua . s:ft_bold
		exec 'hi sedBranch' . s:fg_green . s:ft_bold
		exec 'hi sedLabel' . s:fg_green . s:ft_bold

		" GNU awk highlighting
		exec 'hi awkPatterns' . s:fg_pink . s:ft_bold
		exec 'hi awkSearch' . s:fg_pink
		exec 'hi awkRegExp' . s:fg_blue . s:ft_bold
		exec 'hi awkCharClass' . s:fg_blue . s:ft_bold
		exec 'hi awkFieldVars' . s:fg_green . s:ft_bold
		exec 'hi awkStatement' . s:fg_blue . s:ft_bold
		exec 'hi awkFunction' . s:fg_blue
		exec 'hi awkVariables' . s:fg_green . s:ft_bold
		exec 'hi awkArrayElement' . s:fg_orange
		exec 'hi awkOperator' . s:fg_foreground
		exec 'hi awkBoolLogic' . s:fg_foreground
		exec 'hi awkExpression' . s:fg_foreground
		exec 'hi awkSpecialPrintf' . s:fg_olive . s:ft_bold

		" Elm highlighting
		exec 'hi elmImport' . s:fg_navy
		exec 'hi elmAlias' . s:fg_aqua
		exec 'hi elmType' . s:fg_pink
		exec 'hi elmOperator' . s:fg_aqua . s:ft_bold
		exec 'hi elmBraces' . s:fg_aqua . s:ft_bold
		exec 'hi elmTypedef' . s:fg_blue .  s:ft_bold
		exec 'hi elmTopLevelDecl' . s:fg_green . s:ft_bold

		" Purescript highlighting
		exec 'hi purescriptModuleKeyword' . s:fg_navy
		exec 'hi purescriptImportKeyword' . s:fg_navy
		exec 'hi purescriptModuleName' . s:fg_pink
		exec 'hi purescriptOperator' . s:fg_aqua . s:ft_bold
		exec 'hi purescriptType' . s:fg_pink
		exec 'hi purescriptTypeVar' . s:fg_navy
		exec 'hi purescriptStructure' . s:fg_blue . s:ft_bold
		exec 'hi purescriptLet' . s:fg_blue . s:ft_bold
		exec 'hi purescriptFunction' . s:fg_green . s:ft_bold
		exec 'hi purescriptDelimiter' . s:fg_aqua . s:ft_bold
		exec 'hi purescriptStatement' . s:fg_purple . s:ft_bold
		exec 'hi purescriptConstructor' . s:fg_pink
		exec 'hi purescriptWhere' . s:fg_purple . s:ft_bold

		" F# highlighting
		exec 'hi fsharpTypeName' . s:fg_pink
		exec 'hi fsharpCoreClass' . s:fg_pink
		exec 'hi fsharpType' . s:fg_pink
		exec 'hi fsharpKeyword' . s:fg_blue . s:ft_bold
		exec 'hi fsharpOperator' . s:fg_aqua . s:ft_bold
		exec 'hi fsharpBoolean' . s:fg_green . s:ft_bold
		exec 'hi fsharpFormat' . s:fg_foreground
		exec 'hi fsharpLinq' . s:fg_blue
		exec 'hi fsharpKeyChar' . s:fg_aqua . s:ft_bold
		exec 'hi fsharpOption' . s:fg_orange
		exec 'hi fsharpCoreMethod' . s:fg_purple
		exec 'hi fsharpAttrib' . s:fg_orange
		exec 'hi fsharpModifier' . s:fg_aqua
		exec 'hi fsharpOpen' . s:fg_red

		" ASN.1 highlighting
		exec 'hi asnExternal' . s:fg_green . s:ft_bold
		exec 'hi asnTagModifier' . s:fg_purple
		exec 'hi asnBraces' . s:fg_aqua . s:ft_bold
		exec 'hi asnDefinition' . s:fg_foreground
		exec 'hi asnStructure' . s:fg_blue
		exec 'hi asnType' . s:fg_pink
		exec 'hi asnTypeInfo' . s:fg_aqua . s:ft_bold
		exec 'hi asnFieldOption' . s:fg_purple

		" Plugin: Netrw
		exec 'hi netrwVersion' . s:fg_red
		exec 'hi netrwList' . s:fg_pink
		exec 'hi netrwHidePat' . s:fg_olive
		exec 'hi netrwQuickHelp' . s:fg_blue
		exec 'hi netrwHelpCmd' . s:fg_blue
		exec 'hi netrwDir' . s:fg_aqua . s:ft_bold
		exec 'hi netrwClassify' . s:fg_pink
		exec 'hi netrwExe' . s:fg_green
		exec 'hi netrwSuffixes' . s:fg_comment
		exec 'hi netrwTreeBar' . s:fg_linenumber_fg

		" Plugin: NERDTree
		exec 'hi NERDTreeUp' . s:fg_comment
		exec 'hi NERDTreeHelpCommand' . s:fg_pink
		exec 'hi NERDTreeHelpTitle' . s:fg_blue . s:ft_bold
		exec 'hi NERDTreeHelpKey' . s:fg_pink
		exec 'hi NERDTreeHelp' . s:fg_foreground
		exec 'hi NERDTreeToggleOff' . s:fg_red
		exec 'hi NERDTreeToggleOn' . s:fg_green
		exec 'hi NERDTreeDir' . s:fg_blue . s:ft_bold
		exec 'hi NERDTreeDirSlash' . s:fg_pink
		exec 'hi NERDTreeFile' . s:fg_foreground
		exec 'hi NERDTreeExecFile' . s:fg_green
		exec 'hi NERDTreeOpenable' . s:fg_aqua . s:ft_bold
		exec 'hi NERDTreeClosable' . s:fg_pink

		" Plugin: Tagbar
		exec 'hi TagbarHelpTitle' . s:fg_blue . s:ft_bold
		exec 'hi TagbarHelp' . s:fg_foreground
		exec 'hi TagbarKind' . s:fg_pink
		exec 'hi TagbarSignature' . s:fg_aqua

		" Plugin: Vimdiff
		exec 'hi DiffAdd' . s:fg_diffadd_fg . s:bg_diffadd_bg . s:ft_none
		exec 'hi DiffChange' . s:fg_diffchange_fg . s:bg_diffchange_bg . s:ft_none
		exec 'hi DiffDelete' . s:fg_diffdelete_fg . s:bg_diffdelete_bg . s:ft_none
		exec 'hi DiffText' . s:fg_difftext_fg . s:bg_difftext_bg . s:ft_none

		" Plugin: vim-gitgutter
		exec 'hi GitGutterAdd' . s:fg_diffadd_fg
		exec 'hi GitGutterChange' . s:fg_diffchange_fg
		exec 'hi GitGutterDelete' . s:fg_diffdelete_fg
		exec 'hi GitGutterAddLine' . s:fg_diffadd_fg . s:bg_diffadd_bg . s:ft_none
		exec 'hi GitGutterChangeLine' . s:fg_diffchange_fg . s:bg_diffchange_bg . s:ft_none
		exec 'hi GitGutterDeleteLine' . s:fg_diffdelete_fg . s:bg_diffdelete_bg . s:ft_none

		" Plugin: Spell Checking
		exec 'hi SpellBad' . s:fg_foreground . s:bg_spellbad
		exec 'hi SpellCap' . s:fg_foreground . s:bg_spellcap
		exec 'hi SpellRare' . s:fg_foreground . s:bg_spellrare
		exec 'hi SpellLocal' . s:fg_foreground . s:bg_spelllocal

		" Plugin: Indent Guides
		exec 'hi IndentGuidesOdd'  . s:bg_background
		exec 'hi IndentGuidesEven'  . s:bg_cursorline

		" Plugin: Startify
		exec 'hi StartifyFile' . s:fg_blue . s:ft_bold
		exec 'hi StartifyNumber' . s:fg_orange
		exec 'hi StartifyHeader' . s:fg_comment
		exec 'hi StartifySection' . s:fg_pink
		exec 'hi StartifyPath' . s:fg_foreground
		exec 'hi StartifySlash' . s:fg_navy
		exec 'hi StartifyBracket' . s:fg_aqua
		exec 'hi StartifySpecial' . s:fg_aqua

		" Git commit message
		exec 'hi gitcommitSummary' . s:fg_blue
		exec 'hi gitcommitHeader' . s:fg_green . s:ft_bold
		exec 'hi gitcommitSelectedType' . s:fg_blue
		exec 'hi gitcommitSelectedFile' . s:fg_pink
		exec 'hi gitcommitUntrackedFile' . s:fg_diffdelete_fg
		exec 'hi gitcommitBranch' . s:fg_aqua . s:ft_bold
		exec 'hi gitcommitDiscardedType' . s:fg_diffdelete_fg
		exec 'hi gitcommitDiff' . s:fg_comment

		exec 'hi diffFile' . s:fg_blue
		exec 'hi diffSubname' . s:fg_comment
		exec 'hi diffIndexLine' . s:fg_comment
		exec 'hi diffAdded' . s:fg_diffadd_fg
		exec 'hi diffRemoved' . s:fg_diffdelete_fg
		exec 'hi diffLine' . s:fg_orange
		exec 'hi diffBDiffer' . s:fg_orange
		exec 'hi diffNewFile' . s:fg_comment

		" Pluging: CoC
		exec 'hi CocFloating' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none
		exec 'hi CocErrorFloat' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none
		exec 'hi CocWarningFloat' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none
		exec 'hi CocInfoFloat' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none
		exec 'hi CocHintFloat' . s:fg_popupmenu_fg . s:bg_popupmenu_bg . s:ft_none

		exec 'hi CocErrorHighlight' . s:fg_foreground . s:bg_spellbad
		exec 'hi CocWarningHighlight' . s:fg_foreground . s:bg_spellcap
		exec 'hi CocInfoHighlight' . s:fg_foreground . s:bg_spellcap
		exec 'hi CocHintHighlight' . s:fg_foreground . s:bg_spellcap

		exec 'hi CocErrorSign' . s:fg_error_fg . s:bg_error_bg
		exec 'hi CocWarningSign' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold
		exec 'hi CocInfoSign' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold
		exec 'hi CocHintSign' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold

		if has('nvim')
			" Neovim (LSP) diagnostics
			exec 'hi LspDiagnosticsDefaultError' . s:fg_error_fg . s:bg_error_bg
			exec 'hi LspDiagnosticsDefaultWarning' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold
			exec 'hi LspDiagnosticsDefaultInformation' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold
			exec 'hi LspDiagnosticsDefaultHint' . s:fg_todo_fg . s:bg_todo_bg . s:ft_bold

			exec 'hi LspDiagnosticsUnderlineError cterm=undercurl gui=undercurl' . s:sp_error_fg
			exec 'hi LspDiagnosticsUnderlineWarning cterm=undercurl gui=undercurl' . s:sp_todo_fg
			exec 'hi LspDiagnosticsUnderlineInformation cterm=undercurl gui=undercurl' . s:sp_todo_fg
			exec 'hi LspDiagnosticsUnderlineHint cterm=undercurl gui=undercurl' . s:sp_todo_fg

			hi! link DiagnosticError LspDiagnosticsDefaultError
			hi! link DiagnosticWarn LspDiagnosticsDefaultWarning
			hi! link DiagnosticInfo LspDiagnosticsDefaultInformation
			hi! link DiagnosticHint LspDiagnosticsDefaultHint

			hi! link DiagnosticUnderlineError LspDiagnosticsUnderlineError
			hi! link DiagnosticUnderlineWarn LspDiagnosticsUnderlineWarning
			hi! link DiagnosticUnderlineInfo LspDiagnosticsUnderlineInformation
			hi! link DiagnosticUnderlineHint LspDiagnosticsUnderlineHint

			" Debug Adapter Protocol (DAP) - Plugin: rcarriga/nvim-dap-ui
			exec 'hi DapUIDecoration' . s:fg_blue
			" DAP Scopes window
			hi! link DapUIType Type
			hi! link DapUIVariable Identifier
			exec 'hi DapUIScope' . s:fg_red . s:ft_bold
			hi! link DapUIValue Number
			exec 'hi DapUIModifiedValue' . s:fg_orange . s:ft_bold . s:bg_error_bg
			" DAP Breakpoints window
			hi! link DapUILineNumber LineNr
			hi! link DapUIBreakpointsDisabledLine LineNr
			exec 'hi DapUIBreakpointsCurrentLine' . s:fg_linenumber_fg . s:ft_bold . s:bg_error_bg
			exec 'hi DapUIBreakpointsInfo' . s:fg_green
			exec 'hi DapUIBreakpointsPath' . s:fg_olive . s:ft_bold
			" DAP Stacks window
			exec 'hi DapUIFrameName' . s:fg_blue
			exec 'hi DapUIThread' . s:fg_pink . s:ft_bold
			exec 'hi DapUIStoppedThread' . s:fg_pink
			" DAP Watches window
			exec 'hi DapUIWatchesEmpty' . s:fg_pink . s:ft_bold
			hi! link DapUIWatchesError DapUIWatchesEmpty
			hi! link DapUIWatchesValue Number
			" DAP Breakpoints window
			exec 'hi DapUISource' . s:fg_olive
			" DAP Floating window
			exec 'hi DapUIFloatBorder' . s:fg_blue

			" Plugin: hrsh7th/nvim-cmp
			hi! link CmpItemKindValue Number
			hi! link CmpItemKindVariable Identifier
			hi! link CmpItemKindKeyword Keyword
			hi! link CmpItemKindField CmpItemKindVariable
			exec 'hi CmpItemKindFunction' . s:fg_blue
			hi! link CmpItemKindMethod CmpItemKindFunction
			hi! link CmpItemKindConstructor CmpItemKindFunction
			hi! link CmpItemKindClass Structure
			hi! link CmpItemKindInterface Structure
			exec 'hi CmpItemKindSnippet' . s:fg_orange
			exec 'hi CmpItemKindFile' . s:fg_orange
			hi! link CmpItemKindFolder CmpItemKindFile
			exec 'hi CmpItemAbbrMatch' . s:fg_blue . s:ft_bold
			exec 'hi CmpItemAbbrMatchFuzzy' . s:fg_blue . s:ft_bold
			exec 'hi CmpItemAbbrDeprecated' . s:fg_foreground . ' gui=strikethrough'
		endif

	endfun

hi clear
syntax reset
" let g:colors_name = "PaperColor"

call s:identify_color_mode()
call s:set_color_variables()
call s:apply_syntax_highlightings()

" Port/Minification of buftabline.vim
" Source: https://github.com/ap/vim-buftabline/blob/master/plugin/buftabline.vim
" Under MIT License
	if v:version < 700
		echoerr printf('Vim 7 is required for buftabline (this is only %d.%d)',v:version/100,v:version%100)
	else
		hi default link BufTabLineCurrent         TabLineSel
		hi default link BufTabLineActive          PmenuSel
		hi default link BufTabLineHidden          TabLine
		hi default link BufTabLineFill            TabLineFill
		hi default link BufTabLineModifiedCurrent BufTabLineCurrent
		hi default link BufTabLineModifiedActive  BufTabLineActive
		hi default link BufTabLineModifiedHidden  BufTabLineHidden

		let g:buftabline_numbers    = 1
		let g:buftabline_indicators = 1
		let g:buftabline_separators = 0
		let g:buftabline_show       = 2
		let g:buftabline_plug_max   = 10

		fun! s:user_buffers() " help buffers are always unlisted, but quickfix buffers are not
			return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
		endfun

		fun! s:switch_buffer(bufnum, clicks, button, mod)
			execute 'buffer' a:bufnum
		endfun

		let s:dirsep = fnamemodify(getcwd(),':p')[-1:]
		let s:centerbuf = winbufnr(0)
		let s:tablineat = has('tablineat')
		" let s:sid_tab = s:SID() | delfun s:SID
		fun! RenderTabline()
			let show_num = g:buftabline_numbers == 1
			let show_ord = g:buftabline_numbers == 2
			let show_mod = g:buftabline_indicators
			let lpad     = g:buftabline_separators ? nr2char(0x23B8) : ' '

			let bufnums = s:user_buffers()
			let centerbuf = s:centerbuf " prevent tabline jumping around when non-user buffer current (e.g. help)\

			" pick up data on all the buffers
			let tabs = []
			let path_tabs = []
			let tabs_per_tail = {}
			let currentbuf = winbufnr(0)
			let screen_num = 0
			for bufnum in bufnums
				let screen_num = show_num ? bufnum : show_ord ? screen_num + 1 : ''
				let tab = { 'num': bufnum, 'pre': '' }
				let tab.hilite = currentbuf == bufnum ? 'Current' : bufwinnr(bufnum) > 0 ? 'Active' : 'Hidden'
				if currentbuf == bufnum | let [centerbuf, s:centerbuf] = [bufnum, bufnum] | endif
				let bufpath = bufname(bufnum)
				if strlen(bufpath)
					let tab.path = fnamemodify(bufpath, ':p:~:.')
					let tab.sep = strridx(tab.path, s:dirsep, strlen(tab.path) - 2) " keep trailing dirsep
					let tab.label = tab.path[tab.sep + 1:]
					let pre = screen_num
					if getbufvar(bufnum, '&mod')
						let tab.hilite = 'Modified' . tab.hilite
						if show_mod | let pre = '+' . pre | endif
					endif
					if strlen(pre) | let tab.pre = pre . ' ' | endif
					let tabs_per_tail[tab.label] = get(tabs_per_tail, tab.label, 0) + 1
					let path_tabs += [tab]
				elseif -1 < index(['nofile','acwrite'], getbufvar(bufnum, '&buftype')) " scratch buffer
					let tab.label = ( show_mod ? '!' . screen_num : screen_num ? screen_num . ' !' : '!' )
				else " unnamed file
					let tab.label = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' )
					\             . ( screen_num ? screen_num : '*' )
				endif
				let tabs += [tab]
			endfor

			" disambiguate same-basename files by adding trailing path segments
			while len(filter(tabs_per_tail, 'v:val > 1'))
				let [ambiguous, tabs_per_tail] = [tabs_per_tail, {}]
				for tab in path_tabs
					if -1 < tab.sep && has_key(ambiguous, tab.label)
						let tab.sep = strridx(tab.path, s:dirsep, tab.sep - 1)
						let tab.label = tab.path[tab.sep + 1:]
					endif
					let tabs_per_tail[tab.label] = get(tabs_per_tail, tab.label, 0) + 1
				endfor
			endwhile

			" now keep the current buffer center-screen as much as possible:

			" 1. setup
			let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
			let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }

			" 2. sum the string lengths for the left and right halves
			let currentside = lft
			let lpad_width = strwidth(lpad)
			for tab in tabs
				let tab.width = lpad_width + strwidth(tab.pre) + strwidth(tab.label) + 1
				let tab.label = lpad . tab.pre . substitute(strtrans(tab.label), '%', '%%', 'g') . ' '
				if centerbuf == tab.num
					let halfwidth = tab.width / 2
					let lft.width += halfwidth
					let rgt.width += tab.width - halfwidth
					let currentside = rgt
					continue
				endif
				let currentside.width += tab.width
			endfor
			if currentside is lft " centered buffer not seen?
				" then blame any overflow on the right side, to protect the left
				let [lft.width, rgt.width] = [0, lft.width]
			endif

			" 3. toss away tabs and pieces until all fits:
			if ( lft.width + rgt.width ) > &columns
				let oversized
				\ = lft.width < lft.half ? [ [ rgt, &columns - lft.width ] ]
				\ : rgt.width < rgt.half ? [ [ lft, &columns - rgt.width ] ]
				\ :                        [ [ lft, lft.half ], [ rgt, rgt.half ] ]
				for [side, budget] in oversized
					let delta = side.width - budget
					" toss entire tabs to close the distance
					while delta >= tabs[side.lasttab].width
						let delta -= remove(tabs, side.lasttab).width
					endwhile
					" then snip at the last one to make it fit
					let endtab = tabs[side.lasttab]
					while delta > ( endtab.width - strwidth(strtrans(endtab.label)) )
						let endtab.label = substitute(endtab.label, side.cut, '', '')
					endwhile
					let endtab.label = substitute(endtab.label, side.cut, side.indicator, '')
				endfor
			endif

			if len(tabs) | let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '') | endif

			let swallowclicks = '%'.(1 + tabpagenr('$')).'X'
			return swallowclicks . join(map(tabs,'"%#BufTabLine".v:val.hilite."#" . strtrans(v:val.label)'),'') . '%#BufTabLineFill#'
		endfun

		fun! s:update_tabline(zombie)
			set tabline=
			if tabpagenr('$') > 1 | set guioptions+=e showtabline=2 | return | endif
			set guioptions-=e
			if 0 == g:buftabline_show
				set showtabline=1
				return
			elseif 1 == g:buftabline_show
				" account for BufDelete triggering before buffer is actually deleted
				let bufnums = filter(buftabline#user_buffers(), 'v:val != a:zombie')
				let &g:showtabline = 1 + ( len(bufnums) > 1 )
			elseif 2 == g:buftabline_show
				set showtabline=2
			endif
			set tabline=%!RenderTabline()
		endfun

		augroup BufTabLine
		autocmd!
		autocmd VimEnter  * call s:update_tabline(0)
		autocmd TabEnter  * call s:update_tabline(0)
		autocmd BufAdd    * call s:update_tabline(0)
		autocmd FileType qf call s:update_tabline(0)
		autocmd BufDelete * call s:update_tabline(str2nr(expand('<abuf>')))
		augroup END

		for s:n in range(1, g:buftabline_plug_max) + ( g:buftabline_plug_max > 0 ? [-1] : [] )
			let s:b = s:n == -1 ? -1 : s:n - 1
			execute printf("noremap <silent> <Plug>BufTabLine.Go(%d) :<C-U>exe 'b'.get(s:user_buffers(),%d,'')<cr>", s:n, s:b)
		endfor
		unlet! s:n s:b

		nnoremap <C-N> :bnext<CR>
		nnoremap <C-P> :bprev<CR>

	endif

" Port/Minification of commentary.vim
" Source: https://github.com/tpope/vim-commentary/tree/master/plugin
" Under Vim Licensing (Charityware, Donate to iccf)
	if v:version >= 703
		function! s:surroundings() abort
		  return split(get(b:, 'commentary_format', substitute(substitute(substitute(
				\ &commentstring, '^$', '%s', ''), '\S\zs%s',' %s', '') ,'%s\ze\S', '%s ', '')), '%s', 1)
		endfunction

		function! s:strip_white_space(l,r,line) abort
			let [l, r] = [a:l, a:r]
			if l[-1:] ==# ' ' && stridx(a:line . ' ', l) == -1 && stridx(a:line, l[0:-2]) == 0
				let l = l[:-2]
			endif
			if r[0] ==# ' ' && (' ' . a:line)[-strlen(r)-1:] != r && a:line[-strlen(r):] == r[1:]
				let r = r[1:]
			endif
			return [l, r]
		endfunction

		function! s:go(...) abort
			if !a:0
				let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
				return 'g@'
			elseif a:0 > 1
				let [lnum1, lnum2] = [a:1, a:2]
			else
				let [lnum1, lnum2] = [line("'["), line("']")]
			endif

			let [l, r] = s:surroundings()
			let uncomment = 2
			let force_uncomment = a:0 > 2 && a:3
			for lnum in range(lnum1,lnum2)
				let line = matchstr(getline(lnum),'\S.*\s\@<!')
				let [l, r] = s:strip_white_space(l,r,line)
				if len(line) && (stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)
					let uncomment = 0
				endif
			endfor

			if get(b:, 'commentary_startofline')
				let indent = '^'
			else
				let indent = '^\s*'
			endif

			let lines = []
			for lnum in range(lnum1,lnum2)
				let line = getline(lnum)
				if strlen(r) > 2 && l.r !~# '\\'
					let line = substitute(line,
						\'\M' . substitute(l, '\ze\S\s*$', '\\zs\\d\\*\\ze', '') . '\|' . substitute(r, '\S\zs', '\\zs\\d\\*\\ze', ''),
						\'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$","","")','g')
				endif
				if force_uncomment
					if line =~ '^\s*' . l
						let line = substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','')
					endif
				elseif uncomment
					let line = substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','')
				else
					let line = substitute(line,'^\%('.matchstr(getline(lnum1),indent).'\|\s*\)\zs.*\S\@<=','\=l.submatch(0).r','')
				endif
				call add(lines, line)
			endfor
			call setline(lnum1, lines)
			let modelines = &modelines
			try
				set modelines=0
				silent doautocmd User CommentaryPost
			finally
				let &modelines = modelines
			endtry
			return ''
		endfunction

		function! s:textobject(inner) abort
			let [l, r] = s:surroundings()
			let lnums = [line('.')+1, line('.')-2]
			for [index, dir, bound, line] in [[0, -1, 1, ''], [1, 1, line('$'), '']]
				while lnums[index] != bound && line ==# '' || !(stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)
					let lnums[index] += dir
					let line = matchstr(getline(lnums[index]+dir),'\S.*\s\@<!')
					let [l, r] = s:strip_white_space(l,r,line)
				endwhile
			endfor
			while (a:inner || lnums[1] != line('$')) && empty(getline(lnums[0]))
				let lnums[0] += 1
			endwhile
			while a:inner && empty(getline(lnums[1]))
				let lnums[1] -= 1
			endwhile
			if lnums[0] <= lnums[1]
				execute 'normal! 'lnums[0].'GV'.lnums[1].'G'
			endif
		endfunction

		command! -range -bar -bang Commentary call s:go(<line1>,<line2>,<bang>0)
		xnoremap <expr>   <Plug>Commentary     <SID>go()
		nnoremap <expr>   <Plug>Commentary     <SID>go()
		nnoremap <expr>   <Plug>CommentaryLine <SID>go() . '_'
		onoremap <silent> <Plug>Commentary        :<C-U>call <SID>textobject(get(v:, 'operator', '') ==# 'c')<CR>
		nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call <SID>textobject(1)<CR>

		if !hasmapto('<Plug>Commentary') || maparg('gc','n') ==# ''
			xmap gc  <Plug>Commentary
			nmap gc  <Plug>Commentary
			omap gc  <Plug>Commentary
			nmap gcc <Plug>CommentaryLine
			nmap gcu <Plug>Commentary<Plug>Commentary
		endif
	endif
