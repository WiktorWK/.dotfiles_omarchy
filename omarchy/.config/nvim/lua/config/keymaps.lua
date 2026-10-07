-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+hjkl: move between splits; at the edge hand off to tmux/Hyprland via focus-move
local function nav(k)
  return function()
    if vim.fn.mode() == "t" then
      vim.cmd("stopinsert")
    end
    local before = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. k)
    if vim.api.nvim_get_current_win() == before then
      vim.fn.jobstart({ "focus-move", k, "--outer" }, { detach = true })
    end
  end
end

for _, k in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set({ "n", "t" }, "<C-" .. k .. ">", nav(k), { desc = "Focus " .. k .. " (nvim/tmux/window)" })
end

-- snacks/LazyVim set buffer-local <C-hjkl> in terminal buffers (e.g. Claude); override them
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("focus_move_term", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "terminal" then
      return
    end
    for _, k in ipairs({ "h", "j", "k", "l" }) do
      vim.keymap.set({ "n", "t" }, "<C-" .. k .. ">", nav(k), { buffer = ev.buf, desc = "Focus " .. k })
    end
  end,
})
