--[[
Base keymappings for Neovim itself without plugins.

Plugins keymapping see in corresponding plugin file in lua/plugins/.

How to set new mapping:
    `vim.keymap.set({mode}, {lhs}, {rhs}, {opts})`

Where:
    {mode} (string or table) mode short-name
        "": Normal, Visual, Select, Operator-pending mode
        "n": Normal mode
        "v": Visual and Select mode
        "s": Select mode
        "x": Visual mode
        "o": Operator-pending mode
        "i": Insert mode
        "t": Terminal mode
        "!": Insert Insert and Command-line mode

    {lhs}: (string) left-hand side of the mapping, the keys we want to map
    {rhs}: (string or function) right-hand side of the mapping, the keys or function we want to execute after pressing {lhs}

    {opts}: (table) optional parameters
        silent: define a mapping that will not be echoed on the command line
        noremap: disable recursive mapping

--]]

-- Define the leader key for vim commands
vim.g.mapleader = " " -- <space>

local keymap = vim.keymap

local function opts(desc)
	return { desc = desc, noremap = true, silent = true }
end

-- Disable arrow keys
keymap.set("", "<up>", "<nop>")
keymap.set("", "<down>", "<nop>")
keymap.set("", "<left>", "<nop>")
keymap.set("", "<right>", "<nop>")

-- Exit modes to normal
keymap.set("i", "jf", "<ESC>", opts("Exit insert mode to normal"))
keymap.set("v", "jf", "<ESC>", opts("Exit visual/select mode to normal"))

-- Movements
keymap.set("n", "l", "<Down>", opts("Move down"))
keymap.set("v", "l", "<Down>", opts("Move down"))

keymap.set("n", "k", "<Up>", opts("Move up"))
keymap.set("v", "k", "<Up>", opts("Move up"))

keymap.set("n", "j", "<Left>", opts("Move left"))
keymap.set("v", "j", "<Left>", opts("Move left"))

keymap.set("n", ";", "<Right>", opts("Move right"))
keymap.set("v", ";", "<Right>", opts("Move right"))

-- Close all windows and exit
keymap.set("n", "<leader>q", ":q<CR>", opts("Close all and exit as `:q`")) -- <leader-key> + <q>

-- Switch between opened splitted windows
keymap.set("n", "<leader>j", "<C-w>h", opts("Switch to right window")) -- Right
keymap.set("n", "<leader>;", "<C-w>l", opts("Switch to left window")) -- Left
keymap.set("n", "<leader>l", "<C-w>j", opts("Switch to down window")) -- Down
keymap.set("n", "<leader>k", "<C-w>k", opts("Switch to up window")) -- Up
