let &packpath = &runtimepath

" Common Vim Settings
set termguicolors
set foldmethod=indent
set encoding=utf-8
set splitright
set switchbuf=vsplit
set showcmd
set runtimepath^=~/.devenv/nvim	

let g:mapleader="\\"

" Vim Plug Init
let s:data_dir = stdpath('config') 
if empty(glob(s:data_dir . '/autoload/plug.vim'))
	execute '!curl -fLo '.s:data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| PlugInstall --sync | source $MYVIMRC
	\| endif

call plug#begin(s:data_dir. '/extplugs')
	Plug 'preservim/nerdtree'
	Plug 'tpope/vim-fugitive'
	Plug 'yuttie/comfortable-motion.vim'
	Plug 'myusuf3/numbers.vim'
	Plug 'flazz/vim-colorschemes'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'lewis6991/gitsigns.nvim'		
	Plug 'raimondi/delimitMate'
	Plug 'terrortylor/nvim-comment'
	Plug 'feline-nvim/feline.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'nathom/filetype.nvim'
	Plug 'andymass/vim-matchup'
	Plug 'glepnir/dashboard-nvim'
	Plug 'folke/which-key.nvim'
	Plug 'akinsho/bufferline.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'editorconfig/editorconfig-vim'
	Plug 'Shougo/ddc.vim'
	Plug 'vim-denops/denops.vim'
	Plug 'delphinus/ddc-treesitter'
	Plug 'tani/ddc-fuzzy'
	Plug 'Shougo/neco-vim'
	Plug 'Shougo/ddc-around'
call plug#end()


" Colorschemeing
colorscheme deus

" Denops config
if has('win32')|| has('win64')
	let g:denops#deno = $VIMRUNTIME.'\..\..\..\..\deno.exe' 
else 
	let g:denops#deno = $VIMRUNTIME.'/../../../../deno' 
endif
" DDC Config
" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['around', 'treesitter'])
call ddc#custom#patch_global('sourceOptions', {
	\'_': {
	\'matchers': ['matcher_fuzzy'],
	\'sorters': ['sorter_fuzzy'],
	\'converters':['converter_fuzzy']   
	\},
	\'around': {'mark': 'A', 'maxSize': 500},
	\'treesitter': {'mark': 'T'},
	\'necovim': {'mark': 'vim'},
\})

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'],
											\'sourceOptions', {'clangd': {'mark': 'C'},
\})
call ddc#custom#patch_filetype('markdown', 'sourceParams', {
	\'around': {'maxSize': 100},
\})
call ddc#custom#patch_filetype(['vim', 'toml'], 'sources', ['necovim'])
call ddc#custom#patch_global('sourceOptions', {
	\'necovim': {'mark': 'vim'},
\})

" Mappings
inoremap <silent><expr><TAB> ddc#map#pum_visible() ? '<C-n>' : (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ? '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'
call ddc#enable()


" Telescope Keybinds
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" NERDTree Config
nnoremap <C-t> :NERDTreeToggle<CR>

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endf

" UndoTree Config
nnoremap <F5> :UndotreeToggle<CR>

" Editorconfig Config
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
au FileType gitcommit let b:EditorConfig_disable = 1

" LUA stuff
lua << EOF

require('nvim-treesitter.configs').setup{
	ensure_installed = "maintained",
	ignore_install = { "javascript" },
	highlight = {
    		enable = true,
    		additional_vim_regex_highlighting = false
  	}
}

--which-key Setup
require("which-key").setup{
  	plugins = {
    		marks = true, 
    		registers = true, 
    		spelling = {
      			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      			suggestions = 20, -- how many suggestions should be shown in the list?
    		},
    		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
    		-- No actual key bindings are created
    		presets = {
      			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      			motions = true, -- adds help for motions
     			text_objects = true, -- help for text objects triggered after entering an operator
      			windows = true, -- default bindings on <c-w>
      			nav = true, -- misc bindings to work with windows
      			z = true, -- bindings for folds, spelling and others prefixed with z
      			g = true, -- bindings for prefixed with g
    		},
  	},
  	-- add operators that will trigger motion and text object completion
  	-- to enable all native operators, set the preset / operators plugin above
  	operators = { gc = "Comments" },
  	icons = {
    		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    		separator = "➜", -- symbol used between a key and it's label
    		group = "+", -- symbol prepended to a group
  	},
  	popup_mappings = {
    		scroll_down = '<c-d>', -- binding to scroll down inside the popup
    		scroll_up = '<c-u>', -- binding to scroll up inside the popup
  	},
  	window = {
    		border = "none", -- none, single, double, shadow
    		position = "bottom", -- bottom, top
    		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    		winblend = 0
  	},
  	layout = {
    		height = { min = 4, max = 25 }, -- min and max height of the columns
    		width = { min = 20, max = 50 }, -- min and max width of the columns
    		spacing = 3, -- spacing between columns
    		align = "left", -- align columns left, center or right
  	},
  	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
  	show_help = true, -- show help message on the command line when the popup is visible
  	triggers = "auto", -- automatically setup triggers
  	triggers_blacklist = {
    		i = { "j", "k" },
    		v = { "j", "k" },
  	},
}

--Bufferline Setup
require"bufferline".setup{
	options = {
		mode = "buffers",
		numbers = "buffer_id",
    		close_command = "bdelete! %d",
    		right_mouse_command = "bdelete! %d", 
    		left_mouse_command = "buffer %d",
    		middle_mouse_command = nil,
    		indicator_icon = '▎',
    		buffer_close_icon = '',
    		modified_icon = '●',
    		close_icon = '',
    		left_trunc_marker = '',
    		right_trunc_marker = '',
    		max_name_length = 18,
    		max_prefix_length = 15,
    		tab_size = 18,
    		color_icons = true, 
    		show_buffer_icons = true, 
    		show_buffer_close_icons = false,
    		show_close_icon = false,
    		show_tab_indicators = false,
    		persist_buffer_sort = false,
    		separator_style = "slant", 
    		enforce_regular_tabs = true,
    		always_show_bufferline = true,
    		sort_by = 'id'
	}
}

require('gitsigns').setup{}
require('nvim_comment').setup{}

--Feline Setup
require('feline').setup{}


EOF


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

let g:dashboard_custom_header =<< trim END
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'                        N E O V I M                         \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ``'
END


" Dashboard Setup
let g:dashboard_default_executive ='telescope'
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

" nvim-comment setup

