return {
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        -- add = "S", -- Add surrounding in Normal and Visual modes
      },
    },
  },
  {
    "folke/flash.nvim",
    keys = { { "S", mode = { "n", "x", "o" }, false } },
  },
}
