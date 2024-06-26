return {
    {
        --[[
        Comment/uncomment editor lines with keymaps.
        Repo: https://github.com/numToStr/Comment.nvim
        Docs: `h: comment-nvim`
        ]]
        "numToStr/Comment.nvim",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            local comment = require("Comment")
            local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

            -- Configure and enable
            --- @diagnostic disable: missing-fields
            comment.setup({
                -- for commenting tsx and jsx files
                pre_hook = ts_context_commentstring.create_pre_hook(),
                ---Lines to be ignored while (un)comment
                ignore = "^$", -- Ignore empty lines in all filetypes
                ---LHS of toggle mappings in NORMAL mode
                toggler = {
                    --Line-comment toggle keymap
                    line = "<leader>cl",
                },
                -- LHS of operator-pending mappings in NORMAL and VISUAL mode
                opleader = {
                    -- Line-comment keymap
                    line = "<leader>cl",
                    -- Block-comment keymap
                    block = "<leader>cb",
                },
            })
        end,
    },
}
