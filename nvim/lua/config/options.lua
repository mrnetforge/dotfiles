-- Neovim Options Configuration

-- Show a global statusline instead of one per window
vim.o.laststatus = 3

-- Disable creation of backup files
vim.o.backup = false

-- Show all text, even concealed syntax (e.g., Markdown links)
vim.o.conceallevel = 0

-- Default file encoding
vim.o.fileencoding = "utf-8"

-- Allow hidden buffers
vim.o.hidden = true

-- Ignore case when searching (use smartcase for sensitivity)
vim.o.ignorecase = true

-- Enable mouse support in all modes
vim.o.mouse = "a"

-- Set popup menu height
vim.o.pumheight = 8
vim.o.pumblend = 0

-- Hide mode text since statusline shows it
vim.o.showmode = false

-- Case-insensitive search unless uppercase letters are used
vim.o.smartcase = true

-- Enable smart indentation
vim.o.smartindent = true

-- Open splits below and to the right
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "screen"

-- Enable swap files for recovery
vim.o.swapfile = true

-- Reduce mapped key timeout
vim.o.timeoutlen = 500

-- Save undo history to disk
vim.o.undofile = true

-- Faster CursorHold and LSP feedback
vim.o.updatetime = 100

-- Prevent overwriting a file being edited by another process
vim.o.writebackup = false

-- Convert tabs to spaces (2 spaces)
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Highlight the line under the cursor
vim.o.cursorline = true

-- Show line numbers (absolute + relative)
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5

-- Always show the sign column
vim.o.signcolumn = "yes"

-- Disable line wrapping
vim.o.wrap = false

-- Enable 24-bit color support
vim.o.termguicolors = true

-- Disable the old ruler
vim.o.ruler = false

-- Set command line height (0 = auto-hide)
vim.o.cmdheight = 0

-- Set help window height
vim.o.helpheight = 10

-- Session options
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Customize fill characters
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
  lastline = " ",
}

-- Reduce command line noise
vim.opt.shortmess:append("Ac")

-- Allow cursor to move freely between lines
vim.opt.whichwrap:append("<>[]hl")

-- Treat hyphenated words as single word
vim.opt.iskeyword:append("-")

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
