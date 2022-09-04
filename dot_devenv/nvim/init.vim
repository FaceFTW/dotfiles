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
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4
set completeopt=menu,menuone,noselect

let g:mapleader='\'

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
	"----------------------Core Features----------------------"
	Plug 'nathom/filetype.nvim'
	Plug 'folke/which-key.nvim'
	Plug 'echasnovski/mini.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'tpope/vim-fugitive'
	"-----------------------Telescope------------------------"
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'LinArcX/telescope-command-palette.nvim'
	Plug 'LinArcX/telescope-env.nvim'
	"-----------------------UI Plugins------------------------"
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'flazz/vim-colorschemes'
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'nvim-lua/popup.nvim'
	Plug 'noib3/nvim-cokeline'
	Plug 'rcarriga/nvim-notify'
	Plug 'folke/trouble.nvim'
	Plug 'goolord/alpha-nvim'
	Plug 'MunifTanjim/nui.nvim'
	Plug 'xiyaowong/nvim-transparent'
	"--------------------Editor Features---------------------"
	Plug 'folke/todo-comments.nvim'
	Plug 'anuvyklack/pretty-fold.nvim'
	Plug 'lewis6991/gitsigns.nvim'
	Plug 'chentoast/marks.nvim'
	"--------------------Language Features-------------------"
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdateSync'}
	Plug 'b0o/schemastore.nvim'
	Plug 'milisims/nvim-luaref'
	"----------------------LSP Plugins-----------------------"
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/nvim-lsp-installer'
	Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
	Plug 'RishabhRD/lspactions'
	Plug 'onsails/lspkind-nvim'
	Plug 'kosayoda/nvim-lightbulb'
	"--------------------Miscellaneous---------------------"
	Plug 'dstein64/vim-startuptime'
	Plug 'SmiteshP/nvim-gps'
	Plug 'nvim-neo-tree/neo-tree.nvim'
	Plug 'akinsho/toggleterm.nvim'
	Plug 'rktjmp/lush.nvim'
	Plug 'alec-gibson/nvim-tetris'
	"Plug 'seandewar/killersheep.nvim'
call plug#end()

" Colorschemeing
colorscheme sexy-railscasts

""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""LUA Stuff"""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF

----------------------------------------------------
------------------BASE CONFIG-----------------------
----------------------------------------------------
--Mini.nvim Modules
	require('mini.bufremove').setup{}
	require('mini.comment').setup{}
	require('mini.cursorword').setup{}
	require('mini.indentscope').setup{}
	require('mini.jump').setup{}
	require('mini.pairs').setup{}
	require('mini.surround').setup{}
	require('mini.trailspace').setup{only_in_normal_buffers = true}
	require('mini.completion').setup{}
	vim.api.nvim_set_keymap('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
	vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
	local keys = {
    	['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
    	['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
		['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
	}
	_G.cr_action = function()
		if vim.fn.pumvisible() ~= 0 then
    	  	-- If popup is visible, confirm selected item or add new line otherwise
      	local item_selected = vim.fn.complete_info()['selected'] ~= -1
    		return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    	else
      		-- If popup is not visible, use plain `<CR>`. You might want to customize
      		-- according to other plugins. For example, to use 'mini.pairs', replace
      		-- next line with `return require('mini.pairs').cr()`
    		return keys['cr']
    	end
	end
	vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._G.cr_action()', { noremap = true, expr = true })
--Todo Comments
	require('todo-comments').setup {}
--Pretty Folds
	require('pretty-fold').setup{
		keep_indentation = true,
		fill_char = '━',
		sections = {
		left = {'━ ', function() return string.rep('*', vim.v.foldlevel) end, ' ━┫', 'content', '┣'},
		right = {'┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━'}
		}
	}
--Treesitter
	require('nvim-treesitter.configs').setup{
		highlight = {enable = true, additional_vim_regex_highlighting = false}
	}
--Telescope
	require('telescope').setup{
		defaults = {
			path_display = {'smart'},
			file_ignore_patterns = {'Mobilesync/%w*'}
		},
		extensions = {
			command_palette = {
			{'File',
				{'entire selection (C-a)',				':call feedkeys("GVgg")'},
				{'save current file (C-s)',				':w'},
				{'save all files (C-A-s)',				':wa'},
				{'quit (C-q)',							':qa'},
			},
			{'Dashboard',
				{'Create New File (\\dn)',				':DashboardNewFile'},
				{'Find Word (\\df)',					':DashboardFindWord'},
				{'Show Dashboard',						':Dashboard'},
			},
			{'LSP',
				{'List Installed LSPs', 				':LspInstallInfo'},
				{'Show Current LSP Info',				':LspInfo'}
			},
			{'Neotree',
				{'Show Buffer List (\\fb)',				':Neotree toggle show buffers right'},
				{'Show Filesystem (\\fs)',				':Neotree toggle'},
				{'Show Git Status (\\fg)',				':Neotree float git_status'},
			},
			{'Telescope',
				{'Buffers (\\tb)', 						':Telescope buffers'},
				{'Colorschemes', 						':Telescope colorscheme', 1},
				{'Commands (\\tc)', 					':Telescope commands'},
				{'Command History',						':Telescope command_history'},
				{'Files (\\tf)', 						':Telescope find_files'},
				{'Git Files (\\tv)',					':Telescope git_files'},
				{'Grep String',							':Telescope grep_string'},
				{'Help Tags',							':Telescope help_tags'},
				{'Jumps (\\tj)',						':Telescope jumplist'},
				{'Live Grep String (\\tg)', 			':Telescope live_grep'},
				{'LSP - References (\\tlr)', 			':Telescope lsp_references'},
				{'LSP - Symbols (Workspace) (\\tls)',	':Telescope lsp_workspace_symbols'},
				{'LSP - Type Definitions (\\tlt)', 		':Telescope lsp_type_definitions'},
				{'Man Pages', 							':Telescope man_pages'},
				{'Marks (\\tm)', 						':Telescope marks'},
				{'Old Files (\\th)', 					':Telescope oldfiles'},
				{'Registers (\\tr)', 					':Telescope registers'},
				{'Search History (\\ts)',				':Telescope search_history'},
				{'Tags (\\tt)', 						':Telescope tags'},
				{'Vim Options (\\to)', 					':Telescope vim_options'},
			},
			{'Trouble',
				{'Document Diagnostics (\\xd)',			':TroubleToggle document_diagnostics'},
				{'Location List (\\xl)',				':TroubleToggle loclist'},
				{'Quickfix (\\xq)',						':TroubleToggle quickfix'},
				{'Toggle Window (\\xx)',				':TroubleToggle'},
				{'Workspace Diagnostics (\\xw)',		':TroubleToggle workspace_diagnostics'},
			},
			{'Vim',
				{'reload vimrc',						':source $MYVIMRC'},
				{'check health', 						':checkhealth'},
				{'paste mode', 							':set paste!'},
				{'cursor line', 						':set cursorline!'},
				{'cursor column', 						':set cursorcolumn!'},
				{'spell checker', 						':set spell!'},
				{'relative number', 					':set relativenumber!'},
				{'search highlighting (F12)',			':set hlsearch!'},
			},
			{'Quickref',
				{'List of Help Files',					':help Q_ct'},
				{'Abbreviations',						':help Q_ab'},
				{'Automatic Commands',					':help Q_ac'},
				{'Buffer List Commands',				':help Q_bu'},
				{'Change: Changing Text',				':help Q_ch'},
				{'Change: Complex',						':help Q_co'},
				{'Change: Copying and Moving',			':help Q_cm'},
				{'Change: Deleting Text',				':help Q_de'},
				{'Editing a File',						':help Q_ed'},
				{'Ex: Command-line Editing',			':help Q_ce'},
				{'Ex: Ranges',							':help Q_ra'},
				{'Ex: Special Characters',				':help Q_ex'},
				{'External Commands',					':help Q_et'},
				{'Folding',								':help Q_fo'},
				{'GUI Commands',						':help Q_gu'},
				{'Insert: Digraphs',					':help Q_di'},
				{'Insert: Inserting Text',				':help Q_in'},
				{'Insert: Keys',						':help Q_ai'},
				{'Insert: Special Inserts',				':help Q_si'},
				{'Insert: Special Keys',				':help Q_ss'},
				{'Key Mapping',							':help Q_km'},
				{'Motion: Left-Right',					':help Q_lr'},
				{'Motion: Marks',						':help Q_ma'},
				{'Motion: Pattern Searches',			':help Q_pa'},
				{'Motion: Text Object',					':help Q_tm'},
				{'Motion: Up-Down',						':help Q_ud'},
				{'Motion: Using Tags',					':help Q_ta'},
				{'Motion: Various',						':help Q_vm'},
				{'Multi-Window Commands',				':help Q_wi'},
				{'Options',								':help Q_op'},
				{'Quickfix Commands',					':help Q_qf'},
				{'Repeating Commands',					':help Q_re'},
				{'Scrolling',							':help Q_sc'},
				{'Starting Vim',						':help Q_st'},
				{'Syntax Highlighting',					':help Q_sy'},
				{'Text Objects',						':help Q_to'},
				{'Undo/Redo Commands',					':help Q_ur'},
				{'Using the Argument List',				':help Q_fl'},
				{'Various Commands',					':help Q_vc'},
				{'Visual Mode',							':help Q_vi'},
				{'Writing and Quitting',				':help Q_wq'},
			},
			{'Help',
				{ 'tips', 								':help tips'},
				{ 'cheatsheet', 						':help index'},
				{ 'tutorial',							':help tutor'},
				{ 'summary',							':help summary'},
				{ 'quick reference',					':help quickref'},
			}},
			lsp_handlers = {
				disable = {},
				location = {
					telescope = {},
					no_results_message = 'No references found',
				},
				symbol = {
					telescope = {},
					no_results_message = 'No symbols found',
				},
				call_hierarchy = {
					telescope = {},
					no_results_message = 'No calls found',
				},
				code_action = {
					telescope = require('telescope.themes').get_dropdown({}),
					no_results_message = 'No code actions available',
					prefix = '',
				},
			}
		}
	}
--Marks
	require'marks'.setup {
		default_mappings = true,
		builtin_marks = { ".", "<", ">", "^" },
		cyclic = true,
		force_write_shada = false,
  		refresh_interval = 250,
  		-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  		-- marks, and bookmarks.
  		-- can be either a table with all/none of the keys, or a single number, in which case
  		-- the priority applies to all marks.
  		-- default 10.
  		sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
		excluded_filetypes = {'terminal', 'dashboard'},
		-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
		-- sign/virttext. Bookmarks can be used to group together positions and quickly move
		-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
		-- default virt_text is "".
		bookmark_0 = {
    		sign = "⚑",
    		virt_text = "hello world"
		},
		mappings = {}
	}

----------------------------------------------------
--------------------UI CONFIG-----------------------
----------------------------------------------------
--lualine
	require('lualine').setup {
		options = {
			icons_enabled = true,
			theme = 'auto',
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
			disabled_filetypes = {},
			always_divide_middle = true,
			globalstatus = false,
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch', 'diff', 'diagnostics'},
			lualine_c = {'filename'},
			lualine_x = {'encoding', 'fileformat', 'filetype'},
			lualine_y = {'progress'},
			lualine_z = {'location'}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {'filename'},
			lualine_x = {'location'},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		extensions = {}
	}
--Cokeline
	local get_hex = require('cokeline/utils').get_hex
	local mappings = require('cokeline/mappings')
	local components = {
			space = {
    			text = ' ',
    			truncation = { priority = 1 }
  		},
  		separator = {
    			text = function(buffer)	return buffer.index ~= 1 and '▏' or '' end,
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
    		text = function(buffer) return buffer.index .. ': ' end,
    		truncation = { priority = 1 }
  		},
  		unique_prefix = {
    		text = function(buffer) return buffer.unique_prefix end,
    		fg = get_hex('Comment', 'fg'),
    		style = 'italic',
    		truncation = {priority = 3, direction = 'left'}
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
    		truncation = {priority = 2, direction = 'left'}
		},
  		diagnostics = {
    		text = function(buffer)
      			return (buffer.diagnostics.errors ~= 0 and '  ' .. buffer.diagnostics.errors)
        			or (buffer.diagnostics.warnings ~= 0 and '  ' .. buffer.diagnostics.warnings)
        			or ' '
    		end,
    		fg = function(buffer)
      			return (buffer.diagnostics.errors ~= 0 and get_hex('DiagnosticError', 'fg'))
				or (buffer.diagnostics.warnings ~= 0 and get_hex('DiagnosticWarn', 'fg'))
        			or nil
    		end,
    		truncation = { priority = 1 }
  		},
  		close_or_unsaved = {
    		text = function(buffer) return buffer.is_modified and '●' or ' ' end,
    		fg = function(buffer) return buffer.is_modified and green or nil end,
    		truncation = { priority = 1 }
  		}
	}
	require('cokeline').setup({
  		buffers = {
    		filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
    		filter_visible = function(buffer) return buffer.type ~= 'terminal' end,
    		new_buffers_position = 'next',
  		},
  		rendering = {max_buffer_width = 50},
  		default_hl = {
    		fg = function(buffer)
    			return buffer.is_focused
				and get_hex('Normal', 'fg')
				or get_hex('LineNr', 'fg')
    		end,
    		bg = get_hex('LineNr', 'bg'),
  		},
  		components = {
    		components.separator,
    		components.space,
    		components.devicon,
    		components.space,
    		components.index,
    		components.unique_prefix,
    		components.filename,
    		components.diagnostics,
			components.close_or_unsaved,
    		components.space,
  		}
	})
--Notify
	require("notify").setup({
  		stages = "fade_in_slide_out",
  		on_open = nil,
  		on_close = nil,
  		render = "default",
  		timeout = 5000,
  		max_width = nil,
  		max_height = nil,
  		background_colour = "Normal",
  		minimum_width = 50,
  		icons = {ERROR = "", WARN = "", INFO = "", DEBUG = "", TRACE = "✎",},
	})
	vim.notify = require("notify")
--WhichKey
	require('which-key').setup{
		plugins = {
			marks = true,
			registers = true,
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
		triggers = 'auto',
	}
--Trouble
	require('trouble').setup{
    	position = "bottom", -- position of the list can be: bottom, top, left, right
    	height = 10, -- height of the trouble list when position is top or bottom
    	width = 50, -- width of the list when position is left or right
    	icons = true, -- use devicons for filenames
    	mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    	fold_open = "", -- icon used for open folds
    	fold_closed = "", -- icon used for closed folds
    	group = true, -- group results by file
    	padding = true, -- add an extra new line on top of the list
    	action_keys = { -- key mappings for actions in the trouble list
        	close = "q", -- close the list
        	cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        	refresh = "r", -- manually refresh
        	jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        	open_split = { "<c-x>" }, -- open buffer in new split
        	open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        	open_tab = { "<c-t>" }, -- open buffer in new tab
        	jump_close = {"o"}, -- jump to the diagnostic and close the list
        	toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        	toggle_preview = "P", -- toggle auto_preview
        	hover = "K", -- opens a small popup with the full multiline message
        	preview = "p", -- preview the diagnostic location
        	close_folds = {"zM", "zm"}, -- close all folds
        	open_folds = {"zR", "zr"}, -- open all folds
        	toggle_fold = {"zA", "za"}, -- toggle fold of current file
        	previous = "k", -- preview item
        	next = "j" -- next item
    	},
    	indent_lines = true, -- add an indent guide below the fold icons
    	auto_open = false, -- automatically open the list when you have diagnostics
    	auto_close = false, -- automatically close the list when you have no diagnostics
    	auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    	auto_fold = false, -- automatically fold a file trouble list at creation
    	auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
    	signs = {error = '', warning = '', hint = '', information = '', other = '﫠'},	
    	use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
	}
--GitSigns
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
		watch_gitdir = {interval = 1000, follow_files = true},
		attach_to_untracked = true,
		current_line_blame = false,
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000,
		preview_config = {border = 'single', style = 'minimal', relative = 'cursor', row = 0, col = 1}
	}
--NeoTree
	local config = {
		close_if_last_window = true,
		close_floats_on_escape_key = true,
		default_source = "filesystem",
		enable_diagnostics = true,
		enable_git_status = true,
		git_status_async = true,
		open_files_in_last_window = true, -- false = open files in top left window
		popup_border_style = "NC", -- "double", "none", "rounded", "shadow", "single" or "solid"
		resize_timer_interval = 50, -- in ms, needed for containers to redraw right aligned and faded content
		sort_case_insensitive = false, -- used when sorting files and directories in the tree
		use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
		default_component_configs = {
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {folder_closed = "", folder_open = "", folder_empty = "ﰊ", default = "*",},
			modified = {symbol = "[+]", highlight = "NeoTreeModified",},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
			},
			git_status = {
				symbols = {
					-- Change type
					added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
					deleted   = "✖",
					modified  = "",
					renamed   = "",
					-- Status type
					untracked = "",
					ignored   = "",
					unstaged  = "",
					staged    = "",
					conflict  = "",
				},
				align = "right",
			},
		},
		renderers = {
			directory = {
				{ "indent" },
				{ "icon" },
				{ "current_filter" },
				{ "container", width = "100%", right_padding = 1,
					content = {
						{ "name", zindex = 10 },
						{ "clipboard", zindex = 10 },
						{ "diagnostics", errors_only = true, zindex = 20, align = "right" },
					},
				},
			},
			file = {
				{ "indent" },
				{ "icon" },
				{ "container", width = "100%", right_padding = 1,
					content = {
						{"name", use_git_status_colors = true, zindex = 10},
						{ "clipboard", zindex = 10 },
						{ "bufnr", zindex = 10 },
						{ "modified", zindex = 20, align = "right" },
						{ "diagnostics",  zindex = 20, align = "right" },
						{ "git_status", zindex = 20, align = "right" },
					},
				},
			},
		},
		nesting_rules = {},
		window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
			-- possible options. These can also be functions that return these options.
			position = "left", -- left, right, float, current
			width = 40, -- applies to left and right positions
			popup = { -- settings that apply to float position only
				size = { height = "80%", width = "50%",},
				position = "50%", -- 50% means center it
			},
			-- Mappings for tree window. See `:h nep-tree-mappings` for a list of built-in commands.
			-- You can also create your own commands by providing a function instead of a string.
			mappings = {
				["<space>"] = "toggle_node",
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				["t"] = "open_tabnew",
				["C"] = "close_node",
				["z"] = "close_all_nodes",
				["R"] = "refresh",
				["a"] = "add",
				["A"] = "add_directory",
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy", -- takes text input for destination
				["m"] = "move", -- takes text input for destination
				["q"] = "close_window",
			},
		},
		filesystem = {
			window = {
				mappings = {
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",
					["f"] = "filter_on_submit",
					["<C-x>"] = "clear_filter",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
				}
			},
			async_directory_scan = true,
			bind_to_cwd = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_by_name = {
					".DS_Store",
					"thumbs.db",
					"node_modules"
				},
				never_show = {
					".DS_Store",
					"thumbs.db"
				},
			},
			find_by_full_path_words = false,
			search_limit = 50,
			follow_current_file = false,
			use_libuv_file_watcher = false,
		},
		buffers = {
			bind_to_cwd = true,
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["bd"] = "buffer_delete",
				},
			},
		},
		git_status = {
			window = {
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
		},
	}
--Alpha
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	dashboard.section.header.val = {
    	"                                ",
    	"                                ",
    	"                                ",
    	"                                ",
		[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
		[[⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀]],
		[[⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀]],
		[[⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀]],
		[[⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀]],
		[[⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀]],
		[[⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀]],
		[[⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿ ]],
		[[⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿ ]],
		[[⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿⠇⠀]],
		[[⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿⡟⠀⠀]],
		[[⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀]],
		[[⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀]],
		[[⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀]],
		[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
		[[          N E O V I M         ]],
    	"                                ",
    	"                                ",
    	"                                ",
    	"                                ",
	}

	dashboard.section.buttons.val = {
		dashboard.button("e", "  New File    ", ":enew<CR>"),
  		dashboard.button("f", "  Find File   ", ":Telescope find_files<CR>"),
  		dashboard.button("t", "  Find Text   ", ":Telescope live_grep<CR>"),
  		dashboard.button("c", "  NVIM Config ", ":Telescope dotfiles<CR>"),
  		dashboard.button("q", "  Quit        ", ":qa<CR>"),
	}

	dashboard.section.footer.val = {
  		"                       ",
  		"      my name jeff     ",
  		"          🚀           ",
  		"                       ",
	}
	alpha.setup(dashboard.opts)
--Transparent
	require("transparent").setup({
		enable = true,
	})
----------------------------------------------------
---------------------LSP CONFIG---------------------
----------------------------------------------------
	--vim.lsp.handlers["textDocument/codeAction"] = require'lspactions'.codeaction
	--vim.cmd [[ nnoremap <leader>af :lua require'lspactions'.code_action()<CR> ]]
	--vim.cmd [[ nnoremap <leader>af :lua require'lspactions'.range_code_action()<CR> ]]
	
	--vim.lsp.handlers["textDocument/references"] = require'lspactions'.references
	--vim.cmd [[ nnoremap <leader>af :lua vim.lsp.buf.references()<CR> ]]
	
	--vim.lsp.handlers["textDocument/definition"] = require'lspactions'.definition
	--vim.cmd [[ nnoremap <F12> :lua vim.lsp.buf.definition()<CR> ]]
	--vim.lsp.handlers["textDocument/declaration"] = require'lspactions'.declaration
	--vim.cmd [[ nnoremap <F12> :lua vim.lsp.buf.declaration()<CR> ]]
	
	-- vim.lsp.handlers["textDocument/implementation"] = require'lspactions'.implementation
	--vim.cmd [[ nnoremap <leader>af :lua vim.lsp.buf.implementation()<CR> ]]

	require('lspkind').init({mode = 'symbol_text'})


	vim.ui.select = require('lspactions').select
	vim.ui.input = require('lspactions').input
	local client_notifs = {}
	local function get_notif_data(client_id, token)
		if not client_notifs[client_id] then
			client_notifs[client_id] = {}
		end
		if not client_notifs[client_id][token] then
			client_notifs[client_id][token] = {}
		end
		return client_notifs[client_id][token]
	end

	local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

	local function update_spinner(client_id, token)
		local notif_data = get_notif_data(client_id, token)
		if notif_data.spinner then
			local new_spinner = (notif_data.spinner + 1) % #spinner_frames
			notif_data.spinner = new_spinner
			notif_data.notification = vim.notify(nil, nil, {
				hide_from_history = true,
				icon = spinner_frames[new_spinner],
				replace = notif_data.notification,
			})
			vim.defer_fn(function() update_spinner(client_id, token) end, 100)
		end 
	end

	local function format_title(title, client_name)
		return client_name .. (#title > 0 and ": " .. title or "")
	end

	local function format_message(message, percentage)
		return (percentage and percentage .. "%\t" or "") .. (message or "")
	end

-- LSP integration
-- Make sure to also have the snippet with the common helper functions in your config!

	local lspconfig = require('lspconfig')
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local function on_attach(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		local opts = { noremap=true, silent=true }
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
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>',opts)
	end

	lspconfig.util.default_config = vim.tbl_extend(
    	"force",
    	lspconfig.util.default_config,
		{
        	autostart = false,
        	on_attach = on_attach,
			capabilities = capabilities,
			handlers = {
				["$/progress"] = function(_, result, ctx)
					local client_id = ctx.client_id
					local val = result.value

					if not val.kind then return end

					local notif_data = get_notif_data(client_id, result.token)
 					if val.kind == "begin" then
						local message = format_message(val.message, val.percentage)

						notif_data.notification = vim.notify(message, "info", {
							title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
		 						icon = spinner_frames[1],
								timeout = false,
								hide_from_history = false,
						})
						notif_data.spinner = 1
						update_spinner(client_id, result.token)
					elseif val.kind == "report" and notif_data then
						notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
							replace = notif_data.notification,
    						hide_from_history = false,
						})
 					elseif val.kind == "end" and notif_data then
   						notif_data.notification =
    	 				vim.notify(val.message and format_message(val.message) or "Complete", "info", {
							icon = "",
							replace = notif_data.notification,
							timeout = 3000,
     					})
						notif_data.spinner = nil
					end
				end,
				['textDocument/codeAction'] = require('lspactions').codeaction
			}
    	}
	)

--Server Specific Init
	lspconfig.clangd.setup({autostart = true})
	lspconfig.jsonls.setup({
		autostart = true,
		schemas = require('schemastore').json.schemas()
	})
	lspconfig.vimls.setup({
		autostart = true,
		isNeovim = true,
		vimruntime = vim.env.VIMRUNTIME,
		runtimepath = vim.opt.runtimepath,
		diagnostic = {enable = true},
		suggest = {
			fromVimruntime = true,
			fromRuntimepath = true
		}
	})

require('telescope').load_extension('lsp_handlers');
require('telescope').load_extension('env');
require('telescope').load_extension('command_palette');

---------------------------------------------------
-------------------POST-INIT CFG-------------------
---------------------------------------------------
	require('which-key').register({
		['<leader>t'] = {name = '+Telescope'},
		['<leader>tb'] = {'<cmd>Telescope buffers<cr>', 'Buffers', noremap = true},
		['<leader>tc'] = {'<cmd>Telescope commands<cr>', 'Commands', noremap = true},
		['<leader>tf'] = {'<cmd>Telescope find_files<cr>', 'Find Files', noremap = true},
		['<leader>tg'] = {'<cmd>Telescope live_grep<cr>', 'Live Grep', noremap = true},
		['<leader>th'] = {'<cmd>Telescope oldfiles<cr>', 'Old Files', noremap = true},
		['<leader>tj'] = {'<cmd>Telescope jumplist<cr>', 'Jump List', noremap = true},
		['<leader>tm'] = {'<cmd>Telescope marks<cr>', 'Marks', noremap = true},
		['<leader>to'] = {'<cmd>Telescope vim_options<cr>', 'Vim Options', noremap = true},
		['<leader>tr'] = {'<cmd>Telescope registers<cr>', 'Registers', noremap = true},
		['<leader>tt'] = {'<cmd>Telescope tags<cr>', 'Tags', noremap = true},
		['<leader>tv'] = {'<cmd>Telescope git_files<cr>', 'Git Files', noremap = true},
		['<leader>tl'] = {name = '+TelescopeLSP'},
		['<leader>tlr'] = {'<cmd>Telescope lsp_references<cr>', 'References', noremap = true},
		['<leader>tls'] = {'<cmd>Telescope lsp_workspace_symbols<cr>', 'Symbols (Workspace)', noremap = true},
		['<leader>tlt'] = {'<cmd>Telescope lsp_type_definitions<cr>', 'Type Definitions', noremap = true},
		['<leader>x'] = {name = '+Trouble'},
		['<leader>xd'] = {'<cmd>TroubleToggle document_diagnostics<cr>','Document Diagnostics', noremap = true},
		['<leader>xl'] = {'<cmd>TroubleToggle loclist<cr>','Location List', noremap = true},
		['<leader>xq'] = {'<cmd>TroubleToggle quickfix<cr>','Quickfix', noremap = true},
		['<leader>xx'] = {'<cmd>TroubleToggle<cr>','Reveal Trouble', noremap = true},
		['<leader>xd'] = {'<cmd>TroubleToggle workspace_diagnostics<cr>','Workspace Diagnostics', noremap = true},
		['<leader>f'] = {name = '+Neotree'},
		['<leader>fb'] = {'<cmd> Neotree toggle show buffers right <cr>', 'Buffer List', noremap = true, silent = true},
		['<leader>fg'] = {'<cmd> Neotree float git_status<cr>', 'Git Status', noremap = true, silent = true},
		['<leader>fs'] = {'<cmd> Neotree toggle<cr>', 'File Tree', noremap = true, silent = true},
		['<leader>d'] = {name = '+Dashboard'},
		['<leader>dc'] = {'<cmd>DashboardChangeColorscheme<cr>', 'Change Colorscheme', silent = true},
		['<leader>dd'] = {'<cmd>Dashboard<cr>', 'Show Dashboard', silent = true},
		['<leader>df'] = {'<cmd>DashboardFindWord<cr>', 'Find Word', silent = true},
		['<leader>dl'] = {'<C-u>SessionLoad<cr>', 'Load Session', silent = true},
		['<leader>dn'] = {'<cmd>DashboardNewFile<cr>', 'New File', silent = true},
		['<leader>ds'] = {'<C-u>SessionSave<cr>', 'Save Session', silent = true},
		['<leader>c'] = {name = '+Cokeline'},
		['<leader>cp'] = {'<Plug>(cokeline-focus-prev)', 'Focus Previous Buffer', silent = true},
		['<leader>cn'] = {'<Plug>(cokeline-focus-next)', 'Focus Next Buffer', silent = true},
		['<leader>c1'] = {'<Plug>(cokeline-focus-1)', 'Focus Buffer 1', silent = true},
		['<leader>c2'] = {'<Plug>(cokeline-focus-2)', 'Focus Buffer 2', silent = true},
		['<leader>c3'] = {'<Plug>(cokeline-focus-3)', 'Focus Buffer 3', silent = true},
		['<leader>c4'] = {'<Plug>(cokeline-focus-4)', 'Focus Buffer 4', silent = true},
		['<leader>c5'] = {'<Plug>(cokeline-focus-5)', 'Focus Buffer 5', silent = true},
		['<leader>c6'] = {'<Plug>(cokeline-focus-6)', 'Focus Buffer 6', silent = true},
		['<leader>c7'] = {'<Plug>(cokeline-focus-7)', 'Focus Buffer 7', silent = true},
		['<leader>c8'] = {'<Plug>(cokeline-focus-8)', 'Focus Buffer 8', silent = true},
		['<leader>c9'] = {'<Plug>(cokeline-focus-9)', 'Focus Buffer 9', silent = true},
		['<leader>c0'] = {'<Plug>(cokeline-focus-0)', 'Focus Buffer 0', silent = true},
	})

EOF

nnoremap <leader>ar :lua require'lspactions'.rename()<CR>

" Mini.NVIM Autocmds
augroup dashboardAU
	au Filetype dashboard let b:minicomment_disable = v:true
	au Filetype dashboard let b:minicursorword_disable = v:true
	au Filetype dashboard let b:miniindentscope_disable = v:true
	au Filetype dashboard let b:minijump_disable = v:true
	au Filetype dashboard let b:minipairs_disable = v:true
	au Filetype dashboard let b:minisurround_disable = v:true
	au Filetype dashboard let b:minitrailspace_disable = v:true
augroup END

augroup terminalAU
	au TermOpen * let b:minicomment_disable = v:true
	au TermOpen * let b:minicursorword_disable = v:true
	au TermOpen * let b:miniindentscope_disable = v:true
	au TermOpen * let b:minijump_disable = v:true
	au TermOpen * let b:minipairs_disable = v:true
	au TermOpen * let b:minisurround_disable = v:true
	au TermOpen * let b:minitrailspace_disable = v:true
	au TermOpen  * set nonumber 
augroup END

nnoremap <C-p> <cmd>Telescope command_palette<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

"
" require("toggleterm").setup{
"   -- size can be a number or function which is passed the current terminal
"   size = 20 | function(term)
"     if term.direction == "horizontal" then
"       return 15
"     elseif term.direction == "vertical" then
"       return vim.o.columns * 0.4
"     end
"   end,
"   open_mapping = [[<c-\>]],
"   on_open = fun(t: Terminal), -- function to run when the terminal opens
"   on_close = fun(t: Terminal), -- function to run when the terminal closes
"   on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
"   on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
"   on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
"   hide_numbers = true, -- hide the number column in toggleterm buffers
"   shade_filetypes = {},
"   highlights = {
"     -- highlights which map to a highlight group name and a table of it's values
"     -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
"     Normal = {
"       guibg = <VALUE-HERE>,
"     },
"     NormalFloat = {
"       link = 'Normal'
"     },
"     FloatBorder = {
"       guifg = <VALUE-HERE>,
"       guibg = <VALUE-HERE>,
"     },
"   },
"   shade_terminals = true,
"   shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
"   start_in_insert = true,
"   insert_mappings = true, -- whether or not the open mapping applies in insert mode
"   terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
"   persist_size = true,
"   direction = 'vertical' | 'horizontal' | 'window' | 'float',
"   close_on_exit = true, -- close the terminal window when the process exits
"   shell = vim.o.shell, -- change the default shell
"   -- This field is only relevant if direction is set to 'float'
"   float_opts = {
"     -- The border key is *almost* the same as 'nvim_open_win'
"     -- see :h nvim_open_win for details on borders however
"     -- the 'curved' border is a custom border type
"     -- not natively supported but implemented in this plugin.
"     border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
"     width = <value>,
"     height = <value>,
"     winblend = 3,
"   }
" }
