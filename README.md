# browse_nvim
![image](./browse.gif)
-- using lazy plugin manager

```lua
return {
  "thekbbohara/browse_nvim",
  config = function()
	require("browse").setup()
  end,
  vim.keymap.set({ "v" }, "gq", ":QueryGoogle<CR>", { noremap = true, silent = true }),
  vim.keymap.set({ "n", "v" }, "gx", ":GoToLink<CR>", { noremap = true, silent = true })
}

```
