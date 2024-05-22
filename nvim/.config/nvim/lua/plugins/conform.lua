return {
    {
        --[[
        Setup formatting diffrent sources with conform plugin.

        Repo: https://github.com/stevearc/conform.nvim
        --]]
        "stevearc/conform.nvim",
        lazy = true,
        dependencies = { "mason.nvim" },
        event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
        config = function()
            local conform = require("conform")

            -- TODO: Find and setup formatter for toml file. Maybe taplo?
            conform.setup({
                formatters_by_ft = {
                    -- All formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
                    -- Use a sub-list to run only the first available formatter
                    ["json"] = { "prettier" },
                    ["jsonc"] = { { "prettierd", "prettier" } },
                    ["yaml"] = { { "prettierd", "prettier" } },
                    markdown = { { "prettierd", "prettier" } },
                    lua = { "stylua" },
                    sql = {
                        {
                            "sql_formatter", -- Repo: https://github.com/sql-formatter-org/sql-formatter
                            -- "sqlfluff", -- Repo: https://github.com/sqlfluff/sqlfluff
                        },
                    },
                    sh = { "shfmt" },
                    -- Use the "_" filetype to run formatters on filetypes that don't
                    -- have other formatters configured.
                    ["_"] = { "trim_whitespace" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
                -- Add extra options for formatters
                formatters = {
                    shfmt = {
                        prepend_args = { "-i", "2" },
                    },
                    sql_formatter = {
                        -- TODO: Replace hardcoded path with getting env variable value
                        -- Maybe like that: os.getenv 'HOME' .. '/.config/sql_formatter/sql_formatter.json'
                        prepend_args = {
                            "--config",
                            "/Users/leonidgrisenkov/Code/configs/sql-formatter/.config/sql-formatter/config.json",
                        },
                    },
                    prettier = {
                        prepend_args = { "--tab-width", "4", "--use-tabs", "true" },
                    },
                },
                -- Conform will notify you when a formatter errors
                notify_on_error = true,
            })
        end,
    },
}
