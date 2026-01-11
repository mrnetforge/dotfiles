-- Colorscheme: Cyberdream
return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("cyberdream")
    end,
  },

  -- Fallback: TokyoNight
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },
}
