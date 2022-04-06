let &packpath = &runtimepath

" Common Vim Settings
set termguicolors
set foldmethod=indent
set encoding=utf-8
set splitright
set switchbuf=vsplit
set showcmd
set timeoutlen=200
set runtimepath^=~/.devenv/nvim
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set number

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
	Plug 'flazz/vim-colorschemes'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'lewis6991/gitsigns.nvim'		
	Plug 'feline-nvim/feline.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'nathom/filetype.nvim'
	Plug 'glepnir/dashboard-nvim'
	Plug 'folke/which-key.nvim'
	Plug 'akinsho/bufferline.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
	Plug 'williamboman/nvim-lsp-installer'
	Plug 'LinArcX/telescope-command-palette.nvim'
	Plug 'LinArcX/telescope-env.nvim'
	Plug 'dstein64/vim-startuptime'
	Plug 'nvim-lua/popup.nvim'
	Plug 'RishabhRD/lspactions'
	Plug 'onsails/lspkind-nvim'
	Plug 'kosayoda/nvim-lightbulb'
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'SmiteshP/nvim-gps'
	Plug 'folke/todo-comments.nvim'
	Plug 'anuvyklack/pretty-fold.nvim'
	Plug 'echasnovski/mini.nvim'

	Plug 'alec-gibson/nvim-tetris'
	Plug 'seandewar/killersheep.nvim'

call plug#end()


" Colorschemeing
colorscheme sexy-railscasts

" Telescope Keybinds
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <C-p> <cmd>Telescope command_palette<cr>

" NERDTree Config
nnoremap <C-t> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
	\let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endf

" LUA stuff
lua << EOF
require('nvim-treesitter.configs').setup{
	ensure_installed = 'maintained',
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	}
}

require('which-key').setup{
	plugins = {
		marks = true, 
		registers = true, 
		spelling = {
			enabled = false 
		},
	presets = {
		operators = true, 
		motions = true,
		text_objects = true,
		windows = true,
		nav = true,
		z = true,
		g = true
		}
	},
	operators = { gc = 'Comments' },
	icons = {
		breadcrumb = '»',
		separator = '➜',
		group = '+'
	},
	popup_mappings = {
		scroll_down = '<c-d>',
		scroll_up = '<c-u>'
	},
	window = {
		border = 'double',
		position = 'bottom',
		margin = { 1, 50, 1, 50 },
		padding = { 2, 2, 2, 2 },
		winblend = 0
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 3,
		align = 'left'
	},
	ignore_missing = false,
	hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '},
	show_help = true,
	triggers = 'auto',
}

require('mini.bufremove').setup{}
require('mini.comment').setup{}
--require('mini.completion').setup{}
require('mini.cursorword').setup{}
require('mini.indentscope').setup{}
require('mini.jump').setup{}
require('mini.pairs').setup{}
require('mini.surround').setup{}
require('mini.trailspace').setup{}

--vim.api.nvim_set_keymap('i', [[<Tab>]],   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
--vim.api.nvim_set_keymap('i', [[<S-Tab>]], [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })



vim.lsp.handlers["textDocument/codeAction"] = require'lspactions'.codeaction
vim.cmd [[ nnoremap <leader>af :lua require'lspactions'.code_action()<CR> ]]
--vim.cmd [[ nnoremap <leader>af :lua require'lspactions'.range_code_action()<CR> ]]

vim.lsp.handlers["textDocument/references"] = require'lspactions'.references
--vim.cmd [[ nnoremap <leader>af :lua vim.lsp.buf.references()<CR> ]]

vim.lsp.handlers["textDocument/definition"] = require'lspactions'.definition
vim.cmd [[ nnoremap <F12> :lua vim.lsp.buf.definition()<CR> ]]

vim.lsp.handlers["textDocument/declaration"] = require'lspactions'.declaration
--vim.cmd [[ nnoremap <F12> :lua vim.lsp.buf.declaration()<CR> ]]

vim.lsp.handlers["textDocument/implementation"] = require'lspactions'.implementation
--vim.cmd [[ nnoremap <leader>af :lua vim.lsp.buf.implementation()<CR> ]]


require('bufferline').setup{
	options = {
		mode = 'buffers',
		numbers = 'buffer_id',
		close_command = 'bdelete! %d',
		left_mouse_command = 'buffer %d',
		indicator_icon = '▎',
		modified_icon = '●',
		left_trunc_marker = '',
		right_trunc_marker = '',
		max_name_length = 18,
		max_prefix_length = 15,
		tab_size = 20,
		color_icons = true, 
		show_buffer_icons = true, 
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = false,
		persist_buffer_sort = false,
		separator_style = 'slant', 
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		sort_by = 'id'
	}
}
require('gitsigns').setup {
	signs = {
		add          = {hl = 'GitSignsAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn'},
		change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	},
	signcolumn = true,
	numhl      = false,
	linehl     = false,
	word_diff  = false,
	watch_gitdir = {
		interval = 1000,
		follow_files = true
	},
	attach_to_untracked = true,
	current_line_blame = false,
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	}
}

require('todo-comments').setup {}

require('pretty-fold').setup{
	keep_indentation = true,
	fill_char = '━',
	sections = {
		left = {'━ ', function() return string.rep('*', vim.v.foldlevel) end, ' ━┫', 'content', '┣'},
      		right = {'┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━'}
   }
}

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append('space:⋅')
vim.opt.listchars:append('eol:↴')

require('indent_blankline').setup {
	space_char_blankline = ' ',
	char_highlight_list = {
		'IndentBlanklineIndent1',
		'IndentBlanklineIndent2',
		'IndentBlanklineIndent3',
		'IndentBlanklineIndent4',
		'IndentBlanklineIndent5',
		'IndentBlanklineIndent6',
	},
}



local function on_attach(client,bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end


local enhance_server_opts = {
	['eslintls'] = function(opts)
		opts.settings = {
			format = {enable = true}
		}
	end,
	['vimls'] = function(opts)
		opts.settings = {
			initializationOptions = {
				isNeovim = true,
				vimruntime = vim.env.VIMRUNTIME,
				runtimepath = vim.opt.runtimepath
			},
			diagnostic = {
				enable = true
			},
			suggest = {
				fromVimruntime = true,
				fromRuntimepath = true
			}
		}
	end
}


require('nvim-lsp-installer').on_server_ready(function(server)
	local opts = {on_attach = on_attach}
	if enhance_server_opts[server.name] then
		enhance_server_opts[server.name](opts)
	end
	server:setup(opts)
end)

require('lspkind').init({
	mode = 'symbol_text'
})




--Feline Setup
require('feline').setup{}

require('telescope').setup{
	defaults = {
		path_display = {'smart'},
		file_ignore_patterns = {'Mobilesync/%w*'}
	},
	extensions = {
		command_palette = {
			{'File',
				{ 'entire selection (C-a)', ':call feedkeys("GVgg")' },
				{ 'save current file (C-s)', ':w' },
				{ 'save all files (C-A-s)', ':wa' },
				{ 'quit (C-q)', ':qa' },
			},
			{'Help',
				{ 'tips', ':help tips' },
				{ 'cheatsheet', ':help index' },
				{ 'tutorial', ':help tutor' },
				{ 'summary', ':help summary' },
				{ 'quick reference', ':help quickref' },
			},
			{'Vim',
				{ 'reload vimrc', ':source $MYVIMRC' },
				{ 'check health', ':checkhealth' },
				{ 'paste mode', ':set paste!' },
				{ 'cursor line', ':set cursorline!' },
				{ 'cursor column', ':set cursorcolumn!' },
				{ 'spell checker', ':set spell!' },
				{ 'relative number', ':set relativenumber!' },
				{ 'search highlighting (F12)', ':set hlsearch!' },
			},
			{'Telescope',
				{'Find Files (\\ff)', ':Telescope find_files'},
				{'Find Git Files (\\fg)', ':Telescope git_files'},
				{'Grep String', ':Telescope grep_string'},
				{'Live Grep String', ':Telescope live_grep'},
				{'Buffers', ':Telescope buffers'},
				{'Old Files', ':Telescope oldfiles'},
				{'Commands', ':Telescope commands'},
				{'Tags', ':Telescope tags'},
				{'Command History', ':Telescope command_history'},
				{'Search History', ':Telescope search_history'},
				{'Help Tags', ':Telescope help_tags'},
				{'Man Pages', ':Telescope man_pages'},
				{'LSP - References', ':Telescope lsp_references'},
				{'LSP - Symbols (Workspace)', ':Telescope lsp_workspace_symbols'},
				{'LSP - Type Definitions', ':Telescope lsp_type_definitions'},
				{'Registers', ':Telescope registers'},
				{'Marks', ':Telescope marks'},
				{ 'jumps (Alt-j)', ':Telescope jumplist' },
				{ 'colorshceme', ':Telescope colorscheme', 1 },
				{ 'vim options', ':Telescope vim_options' },
			}},
		lsp_handlers = {
			code_action = {
				telescope = require('telescope.themes').get_dropdown({})
			}
		}
	}
}

require('telescope').load_extension('lsp_handlers');
require('telescope').load_extension('env');
require('telescope').load_extension('command_palette');
EOF

nnoremap <leader>ar :lua require'lspactions'.rename()<CR>



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
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
