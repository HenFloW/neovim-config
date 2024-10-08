return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "dark",
        transparent = false,
        ending_tildes = false,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme onedark]])
    end,
  },
}
