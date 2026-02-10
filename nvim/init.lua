vim.cmd([[set noswapfile]])
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
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
vim.opt.scrolloff = 6
vim.opt.list = true
vim.o.clipboard = "unnamedplus"

vim.cmd [[set completeopt+=menuone,noinsert,popup]]
vim.opt.runtimepath:append("/opt/homebrew/opt/fzf")

vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })
vim.lsp.config("lua_ls", {
  filetypes = { "lua" },
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
vim.lsp.enable("lua_ls")

vim.lsp.config("emmet-ls", {
  cmd = { 'emmet-ls', '--stdio' },
  filetypes = { 'astro', 'css', 'eruby', 'html', 'htmlangular', 'htmldjango',
    'javascriptreact', 'less', 'pug', 'sass', 'scss', 'svelte', 'templ',
    'typescriptreact', 'vue',
  },
  root_markers = { '.git' },
})
vim.lsp.enable("emmet-ls")

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
  "https://github.com/karb94/neoscroll.nvim",
  "https://github.com/ruifm/gitlinker.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/vim-ruby/vim-ruby",
  "https://github.com/tpope/vim-rails",
  "https://github.com/RRethy/nvim-treesitter-endwise",
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-repeat",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/jremmen/vim-ripgrep",
  "https://github.com/junegunn/fzf.vim",
  -- "https://github.com/ThePrimeagen/refactoring.nvim"
  "https://github.com/sainnhe/gruvbox-material",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/lucerion/vim-i18n-rails"
}, { load = true })

-- vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_better_performance = 1
vim.cmd("colorscheme gruvbox-material")

vim.g.rails_projections = {
  ["app/models/*.rb"] = {
    alternate = {
      "spec/factories/{plural}.rb",
      "spec/models/{singular}_spec.rb",
    },
  },
  ["app/controllers/*.rb"] = {
    alternate = {
      "spec/requests/{}_spec.rb",
    },
    test = "spec/requests/{}_spec.rb",
  },
  ["spec/requests/*_spec.rb"] = {
    command = "request",
    affinity = "controller",
    alternate = {
      "app/controllers/{}.rb",
    },
    test = "spec/requests/{}_spec.rb",
  },
  ["spec/factories/*.rb"] = {
    command = "factory",
    affinity = "model",
    alternate = {
      "app/models/{singular}.rb",
      "spec/models/{singular}_spec.rb",
    },
    test = "spec/models/{singular}_spec.rb",
  },
}

-- https://raw.githubusercontent.com/neovim/nvim-lspconfig/refs/heads/master/lsp/ruby_lsp.lua
-- gem install ruby-lsp
-- gem install ruby-lsp-rails
-- gem install ruby-lsp-rails-factory-bot
-- gem install ruby-lsp-rspec
vim.lsp.config('ruby_lsp', {
  cmd = {'mise', 'exec', 'ruby@3.4.8', '--', 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
})
vim.lsp.enable("ruby_lsp")

-- https://raw.githubusercontent.com/neovim/nvim-lspconfig/refs/heads/master/lsp/rubocop.lua
vim.lsp.config("rubocop", {
  cmd = { "rubocop", "--lsp" },
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
})
vim.lsp.enable("rubocop")

vim.lsp.config('solargraph', {
  cmd = { 'solargraph', 'stdio' },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
  init_options = { formatting = true },
  filetypes = { 'ruby' },
  root_markers = { 'Gemfile', '.git' },
})
vim.lsp.enable("solargraph")

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

vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1 * vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
end)
vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR, float = true })
end)

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 * vim.v.count1, severity = nil, float = true })
end)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = vim.v.count1, severity = nil, float = true })
end)

vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end)
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd("startinsert")
  end,
})
vim.keymap.set("n", "<leader>C", "<CMD>Git commit -v<CR>")
