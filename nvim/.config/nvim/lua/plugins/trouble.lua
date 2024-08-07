return {
    {
        -- https://github.com/folke/trouble.nvim
        "folke/trouble.nvim",
        -- cmd = { "TroubleToggle", "Trouble" },
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
        opts = {
            -- WARN: Sings defined in lsp config
            use_diagnostic_signs = true,
            defaults = {
                focus = false, -- Focus the window when opened
            },
        },
        -- Keys for v2
        -- keys = {
        --     { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
        --     {
        --         "<leader>xw",
        --         "<cmd>TroubleToggle workspace_diagnostics<CR>",
        --         desc = "Open trouble workspace diagnostics",
        --     },
        --     { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
        --     { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
        --     { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
        -- },
        -- Keys for v3
        keys = {
            {
                "<leader>xw",
                ":Trouble diagnostics toggle<cr>",
                desc = "Toggle workspace diagnostics",
            },
            {
                "<leader>xb",
                ":Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Toggle buffer diagnostics",
            },
            -- {
            --     "<leader>cs",
            --     "<cmd>Trouble symbols toggle focus=false<cr>",
            --     desc = "Symbols (Trouble)",
            -- },
            -- {
            --     "<leader>cl",
            --     "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            --     desc = "LSP Definitions / references / ... (Trouble)",
            -- },
            {
                "<leader>xL",
                ":Trouble loclist toggle<cr>",
                desc = "Location List",
            },
            {
                "<leader>xQ",
                ":Trouble qflist toggle<cr>",
                desc = "Quickfix List",
            },
            {
                "<leader>xt",
                ":TodoTrouble<CR>",
                desc = "Open TODOs",
            },
        },
    },
}
