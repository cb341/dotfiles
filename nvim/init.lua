vim.cmd([[set noswapfile]])
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.cursorcolumn = true
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("colorscheme sorbet")

vim.opt.runtimepath:append("/opt/homebrew/opt/fzf")
vim.lsp.config("lua_ls",{
	filetypes = { 'lua' },
	cmd = { 'lua-language-server' },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

-- vim.lsp.config['ruby_lsp'] = {
-- 	cmd = { 'ruby-lsp' },
-- 	filetypes = { 'rb', 'ruby', 'eruby' },
-- }
-- vim.lsp.enable({ "lua_ls", "ruby_lsp" })

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.g.mapleader = " "
vim.keymap.set({ "n", "v", "x" }, "<leader>s", "<Cmd>source $MYVIMRC<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>e", "<Cmd>vs $MYVIMRC<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>f", "<Cmd>FZF!<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>/", "<Cmd>RG!<CR>")

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end
})

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/karb94/neoscroll.nvim",
	"https://github.com/ruifm/gitlinker.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/tpope/vim-rails",
	"https://github.com/RRethy/nvim-treesitter-endwise",
	"https://github.com/tpope/vim-surround",
	"https://github.com/tpope/vim-repeat",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/jremmen/vim-ripgrep",
	"https://github.com/junegunn/fzf.vim",
})

vim.lsp.config('ruby_lsp', {})
vim.lsp.config('rust_analyzer', {})

vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ruby_lsp")

-- vim.lsp.config('rust_analyzer', {})

require("neoscroll").setup()
require("oil").setup({
	skip_confirm_for_simple_edits = true,
	prompt_save_on_select_new_entry = true,
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "]c", "<CMD>Gitsigns next_hunk<CR>")
vim.keymap.set("n", "[c", "<CMD>Gitsigns prev_hunk<CR>")
vim.keymap.set("n", "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<leader>hS", "<CMD>Gitsigns stage_buffer<CR>")
vim.keymap.set("n", "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<leader>hu", "<CMD>Gitsigns undo_stage_hunk<CR>")
vim.keymap.set("n", "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>")
vim.keymap.set("n", "<leader>hR", "<CMD>Gitsigns reset_buffer<CR>")
vim.keymap.set("n", "<leader>hd", "<CMD>Gitsigns diffthis<CR>")

vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.cmd("startinsert")
	end,
})
vim.keymap.set("n", "<leader>C", "<CMD>Git commit -v<CR>")
