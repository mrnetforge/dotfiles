-- Autocommands Configuration

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

-- Terminal: disable line numbers and auto-enter insert mode
autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd("startinsert!")
  end,
  group = general,
  desc = "Configure terminal window options",
})

-- Disable auto-comment on new line
autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  group = general,
  desc = "Disable automatic comment continuation",
})

-- Automatically disable readonly mode
autocmd("FileChangedRO", {
  callback = function()
    vim.bo.readonly = false
  end,
  group = general,
  desc = "Automatically disable readonly mode on change",
})

-- Auto-save on focus lost or buffer leave
autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
  callback = function()
    if vim.bo.filetype ~= "" and vim.bo.buftype == "" and vim.bo.modified then
      vim.cmd("silent! w")
    end
  end,
  group = general,
  desc = "Auto-save modified buffers",
})

-- Notify when file is reloaded
autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File reloaded automatically", vim.log.levels.INFO, { title = "nvim" })
  end,
  group = general,
  desc = "Notify user when file is reloaded",
})

-- Equalize split sizes on resize
autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
  group = general,
  desc = "Equalize window splits on resize",
})

-- Dynamic search highlighting
autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    if mode:match("i") then
      vim.opt.hlsearch = false
    else
      vim.opt.hlsearch = true
    end
  end,
  group = general,
  desc = "Toggle search highlight by mode",
})

-- Enable wrap and spellcheck for text files
autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text", "log" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = general,
  desc = "Enable wrap and spellcheck for writing filetypes",
})

-- Quickfix list: dd to delete item
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", function()
      local qf_list = vim.fn.getqflist()
      local current_line = vim.fn.line(".")
      if qf_list[current_line] then
        table.remove(qf_list, current_line)
        vim.fn.setqflist(qf_list, "r")
        vim.fn.cursor(math.min(current_line, #qf_list), 1)
      end
    end, { buffer = true, noremap = true, silent = true, desc = "Remove quickfix item" })
  end,
  group = general,
  desc = "Quickfix keymaps",
})
