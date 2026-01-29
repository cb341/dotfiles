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

vim.opt.runtimepath:append("/opt/homebrew/opt/fzf")

vim.lsp.config["lua_ls"] = {
	filetypes = { 'lua' },
  cmd = { 'lua-language-server' },
    -- on_attach = on_attach,
    -- flags = lsp_flags,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
vim.lsp.config['ruby_lsp'] = {
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
}
vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.lsp.enable("lua_ls", "ruby_lsp")
vim.g.mapleader = " "

vim.keymap.set({ "n", "v", "x" }, "<leader>s", "<Cmd>source $MYVIMRC<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>e", "<Cmd>vs $MYVIMRC<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>f", "<Cmd>FZF<CR>")

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
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/tpope/vim-surround",
	"https://github.com/tpope/vim-repeat",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/lewis6991/gitsigns.nvim"
})

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	callback = function()
		vim.cmd("startinsert")
	end,
})
vim.keymap.set("n", "<leader>c", "<CMD>Git commit -v<CR>")
