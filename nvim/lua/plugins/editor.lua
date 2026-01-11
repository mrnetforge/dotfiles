-- Editor plugins
return {
  -- Oil.nvim: Buffer file explorer
  {
    "stevearc/oil.nvim",
    opts = {
      show_hidden = true,
    },
    keys = {
      {
        "<leader>O",
        function()
          if vim.bo.filetype == "oil" then
            vim.cmd("bd")
          else
            vim.cmd("Oil")
          end
        end,
        desc = "Toggle Oil",
      },
    },
  },

  -- Which-key: Keymap helper
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Treesitter: Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Telescope: Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
    },
  },

  -- Gitsigns: Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Mini.pairs: Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- Mini.surround: Surround text objects
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment.nvim: Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
