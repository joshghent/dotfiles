return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = require("configs.conform"),
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufWritePre" },
		build = false, -- Don't auto-build/install parsers
		config = function()
			require("nvim-treesitter.configs").setup(require("configs.treesitter"))
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
	{
		"kaymmm/bullets.nvim",
		lazy = false,
		opts = {
			colon_indent = true,
			delete_last_bullet = true,
			empty_buffers = true,
			file_types = { "markdown", "text", "gitcommit" },
			line_spacing = 1,
			mappings = true,
			outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std*", "std-", "std+" },
			renumber = true,
			alpha = {
				len = 2,
			},
			checkbox = {
				nest = true,
				markers = " .oOx",
				toggle_partials = true,
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 10000,
		},
	},
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/orgfiles/**/*",
				org_default_notes_file = "~/orgfiles/refile.org",
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	-- Image support for terminal
	-- Works with Kitty terminal (best support)
	-- Limited support in iTerm2 (only with imgcat, may not display inline)
	{
		"3rd/image.nvim",
		enabled = vim.fn.has("mac") == 1, -- Only enable on macOS
		event = "VeryLazy",
		build = false,
		opts = function()
			-- Auto-detect terminal and set backend
			local backend = "kitty"
			if vim.env.TERM_PROGRAM == "iTerm.app" then
				backend = "kitty" -- Use kitty protocol, iTerm2 has limited support
			end

			return {
				backend = backend,
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "markdown", "vimwiki" },
					},
				},
				max_width = nil,
				max_height = nil,
				max_width_window_percentage = nil,
				max_height_window_percentage = 50,
				window_overlap_clear_enabled = false,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
				editor_only_render_when_focused = false,
				tmux_show_only_in_active_window = false,
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
			}
		end,
	},
	-- Telekasten for note-taking
	{
		"renerocksai/telekasten.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telekasten").setup({
				home = vim.fn.expand("~/Projects/notes"),
				dailies = vim.fn.expand("~/Projects/notes/daily"),
				weeklies = vim.fn.expand("~/Projects/notes/weekly"),
				templates = vim.fn.expand("~/Projects/notes/templates"),
				template_new_note = vim.fn.expand("~/Projects/notes/templates/note.md"),
				template_new_daily = vim.fn.expand("~/Projects/notes/templates/daily.md"),
				template_new_weekly = vim.fn.expand("~/Projects/notes/templates/weekly.md"),
				extension = ".md",
				follow_creates_nonexisting = true,
				dailies_create_nonexisting = true,
				weeklies_create_nonexisting = true,
				journal_auto_open = false,
				template_handling = "smart",
				new_note_filename = "title-uuid",
				uuid_type = "%Y%m%d%H%M",
				uuid_sep = "-",
				take_over_my_home = false,
			})
		end,
	},
	-- Blink.cmp for better completion
	{
		import = "nvchad.blink.lazyspec",
	},
	-- Override nvim-tree config
	{
		"nvim-tree/nvim-tree.lua",
		opts = require("configs.nvimtree"),
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},
}
