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

	Plug 'SmiteshP/nvim-gps'
	Plug 'folke/todo-comments.nvim'
	Plug 'anuvyklack/pretty-fold.nvim'
	Plug 'echasnovski/mini.nvim'
	Plug 'noib3/nvim-cokeline'

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



local get_hex = require('cokeline/utils').get_hex
local mappings = require('cokeline/mappings')

local comments_fg = get_hex('Comment', 'fg')
local errors_fg = get_hex('DiagnosticError', 'fg')
local warnings_fg = get_hex('DiagnosticWarn', 'fg')

local red = vim.g.terminal_color_1
local yellow = vim.g.terminal_color_3

local components = {
	space = {
    		text = ' ',
    		truncation = { priority = 1 }
  	},

  	two_spaces = {
    		text = '  ',
    		truncation = { priority = 1 }
  	},

  	separator = {
    		text = function(buffer)
      			return buffer.index ~= 1 and '▏' or ''
    		end,
    		truncation = { priority = 1 }
 	},

	devicon = {
    		text = function(buffer)
      			return (mappings.is_picking_focus() or mappings.is_picking_close())
          			and buffer.pick_letter .. ' '
           			or buffer.devicon.icon
    		end,
    		fg = function(buffer)
      			return (mappings.is_picking_focus() and yellow)
        			or (mappings.is_picking_close() and red)
        			or buffer.devicon.color
    		end,
    		style = function(_)
      			return (mappings.is_picking_focus() or mappings.is_picking_close())
        			and 'italic,bold'
         			or nil
    			end,
    		truncation = { priority = 1 }
  	},

  	index = {
    		text = function(buffer)
      			return buffer.index .. ': '
    		end,
    		truncation = { priority = 1 }
  	},

  	unique_prefix = {
    		text = function(buffer)
      			return buffer.unique_prefix
    		end,
    		fg = comments_fg,
    		style = 'italic',
    		truncation = {
      			priority = 3,
      			direction = 'left'
    		}
  	},

  	filename = {
    		text = function(buffer)
      			return buffer.filename
    		end,
    		style = function(buffer)
      			return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and 'bold,underline')
        			or (buffer.is_focused and 'bold')
        			or (buffer.diagnostics.errors ~= 0 and 'underline')
        			or nil
    		end,
    		truncation = {
			priority = 2,
      			direction = 'left'
    		}
	},

  	diagnostics = {
    		text = function(buffer)
      			return (buffer.diagnostics.errors ~= 0 and '  ' .. buffer.diagnostics.errors)
        			or (buffer.diagnostics.warnings ~= 0 and '  ' .. buffer.diagnostics.warnings)
        			or ''
    		end,
    		fg = function(buffer)
      			return (buffer.diagnostics.errors ~= 0 and errors_fg)
				or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
        			or nil
    		end,
    		truncation = { priority = 1 }
  	},

  	close_or_unsaved = {
    		text = function(buffer)
      			return buffer.is_modified and '●' or ''
    		end,
    		fg = function(buffer)
      			return buffer.is_modified and green or nil
    		end,
    		delete_buffer_on_left_click = true,
    		truncation = { priority = 1 }
  	}
}

require('cokeline').setup({
  	show_if_buffers_are_at_least = 2,

  	buffers = {
    		-- filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
    		-- filter_visible = function(buffer) return buffer.type ~= 'terminal' end,
    		new_buffers_position = 'next',
  	},

  	rendering = {
    		max_buffer_width = 30,
  	},

  	default_hl = {
    		fg = function(buffer)
      			return buffer.is_focused 
				and get_hex('Normal', 'fg')
				or get_hex('Comment', 'fg')
    		end,
    		bg = get_hex('ColorColumn', 'bg'),
  	},

  	components = {
    		components.space,
    		components.separator,
    		components.space,
    		components.devicon,
    		components.space,
    		components.index,
    		components.unique_prefix,
    		components.filename,
    		components.diagnostics,
    		components.two_spaces,
    		components.close_or_unsaved,
    		components.space,
  	}
})

--map('n', '<S-Tab>',   '<Plug>(cokeline-focus-prev)',  { silent = true })
--map('n', '<Tab>',     '<Plug>(cokeline-focus-next)',  { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>p', '<Plug>(cokeline-switch-prev)', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>n', '<Plug>(cokeline-switch-next)', { silent = true })

for i = 1,9 do
  vim.api.nvim_set_keymap('n', ('<F%s>'):format(i),      ('<Plug>(cokeline-focus-%s)'):format(i),  { silent = true })
  vim.api.nvim_set_keymap('n', ('<Leader>%s'):format(i), ('<Plug>(cokeline-switch-%s)'):format(i), { silent = true })
end


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


