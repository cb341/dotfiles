return {
  {
    "RRethy/nvim-treesitter-endwise",
    lazy = false,
  },
  {
    "tpope/vim-rails",
    lazy = false,
    ft = { "ruby", "eruby" },
    config = function()
      vim.g.rails_projections = {
        ["app/models/*.rb"] = {
          alternate = {
            "spec/factories/{plural}.rb",
            "spec/models/{singular}_spec.rb",
          },
          test = "spec/models/{singular}_spec.rb",
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
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          cmd = { "mise", "exec", "--", "ruby-lsp" },
          init_options = {
            enabledFeatures = {
              "codeActions",
              "codeLens",
              "completion",
              "definition",
              "diagnostics",
              "documentHighlights",
              "documentLink",
              "documentSymbols",
              "foldingRanges",
              "formatting",
              "hover",
              "inlayHint",
              "onTypeFormatting",
              "selectionRanges",
              "semanticHighlighting",
              "signatureHelp",
              "typeHierarchy",
              "workspaceSymbol",
            },
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        },
        solargraph = {
          -- commandPath = "/Users/dani/.local/share/mise/installs/ruby/3.4.7/bin/solargraph",
          cmd = { "mise", "exec", "--", "solargraph", "stdio" },
        },
        rubocop = { cmd = { "mise", "exec", "--", "rubocop", "--lsp" } },
        standardrb = { cmd = { "mise", "exec", "--", "standardrb", "--lsp" } },
        herb_ls = { cmd = { "mise", "exec", "--", "herb-language-server", "--stdio" } },
        stimulus_ls = {
          cmd = { "mise", "exec", "--", "stimulus-language-server", "--stdio" },
          filetypes = { "html", "ruby", "eruby", "blade", "php" },
        },
        stylelint_lsp = {
          cmd = { "mise", "exec", "--", "stylelint-lsp", "--stdio" },
          filetypes = { "css", "scss", "less", "sass", "vue", "html" },
          settings = {
            stylelintplus = {
              autoFixOnSave = true,
              autoFixOnFormat = true,
            },
          },
        },
      },
    },
  },
}
