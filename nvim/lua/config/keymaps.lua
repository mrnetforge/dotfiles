-- Keymaps Configuration

-- Yank All Text
vim.keymap.set("n", "<leader>y", "<cmd>%y+<cr>", { desc = "Yank All Text", silent = true })

-- Delete All Text
vim.keymap.set("n", "<leader>bR", "<cmd>%d+<cr>", { desc = "Remove All Text", silent = true })

-- Switch between windows using arrow keys
vim.keymap.set("n", "<Left>", "<C-w>h", { desc = "Go to left window", silent = true })
vim.keymap.set("n", "<Right>", "<C-w>l", { desc = "Go to right window", silent = true })
vim.keymap.set("n", "<Up>", "<C-w>k", { desc = "Go to upper window", silent = true })
vim.keymap.set("n", "<Down>", "<C-w>j", { desc = "Go to lower window", silent = true })

-- Lazy plugin manager
vim.keymap.set("n", "<leader>lh", "<cmd>Lazy<cr>", { desc = "Lazy Home" })
vim.keymap.set("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" })
vim.keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })
vim.keymap.set("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Lazy Profile" })

-- Smart move with tmux integration
local function smart_move(direction, tmux_cmd)
  local curwin = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  if curwin == vim.api.nvim_get_current_win() then
    vim.fn.system("tmux select-pane " .. tmux_cmd)
  end
end

vim.keymap.set("n", "<C-h>", function() smart_move("h", "-L") end, { silent = true })
vim.keymap.set("n", "<C-j>", function() smart_move("j", "-D") end, { silent = true })
vim.keymap.set("n", "<C-k>", function() smart_move("k", "-U") end, { silent = true })
vim.keymap.set("n", "<C-l>", function() smart_move("l", "-R") end, { silent = true })

-- Terminal mode: Esc to exit
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Switch to buffer 1-9 with <leader>1-9
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if i <= #bufs then
      vim.api.nvim_set_current_buf(bufs[i].bufnr)
    end
  end, { desc = "Go to buffer " .. i })
end
