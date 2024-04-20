return {
    {
        --[[
        Configurations for LSP.

        Repo: https://github.com/neovim/nvim-lspconfig
        Wiki: https://github.com/neovim/nvim-lspconfig/wiki

        :LspInfo
        ]]
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")

            -- Setup required language servers
            local servers = { "pyright", "lua_ls", "yamlls", "jsonls", "taplo" }
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    capabilities = capabilities,
                })
            end

            -- Setup Diagnostic signs and highlight
            -- Docs: https://neovim.io/doc/user/diagnostic.html
            -- :help vim.diagnostic.config
            vim.diagnostic.config({
                virtual_text = { prefix = "●" },
                signs = true, -- Show symbols in sign column (gutter)
                underline = false, -- Underline problem line
                update_in_insert = false,
                severity_sort = false,
            })

            -- Setup symbols in the sign column (gutter)
            local signs = {
                Error = "",
                Warn = "",
                Hint = "",
                Info = "",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Setup keymaps
            local function opts(desc)
                return { desc = desc, noremap = true, silent = true }
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Show definition preview hover"))
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Show code actions"))
        end,
    },
    {

        --[[
        :h mason-commands

        :Mason - opens a graphical status window
        :MasonUpdate - updates all managed registries
        :MasonInstall <package> ... - installs/re-installs the provided packages
        :MasonUninstall <package> ... - uninstalls the provided packages
        :MasonUninstallAll - uninstalls all packages
        :MasonLog - opens the mason.nvim log file in a new tab window

        --]]
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        dependencies = {
            "williamboman/mason-lspconfig.nvim", -- https://github.com/williamboman/mason-lspconfig.nvim
            "WhoIsSethDaniel/mason-tool-installer.nvim", -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
        },
        -- :h mason-settings
        config = function()
            -- import mason
            local mason = require("mason")

            -- import mason-lspconfig
            local mason_lspconfig = require("mason-lspconfig")

            local mason_tool_installer = require("mason-tool-installer")

            -- enable mason and configure icons
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            mason_lspconfig.setup({
                -- list of servers for mason to install
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "yamlls",
                    "jsonls",
                    "taplo", -- LSP for toml files
                },
                -- auto-install configured servers (with lspconfig)
                automatic_installation = true, -- not the same as ensure_installed
            })

            mason_tool_installer.setup({
                ensure_installed = {
                    "stylua", -- lua formatter
                    "ruff", -- python formatter and linter
                    "prettierd",
                    "prettier",
                    "sql-formatter",
                    "sqlfluff",
                    "stylua",
                    "shfmt",
                },
                auto_update = true,
                run_on_start = true,
            })
        end,
    },
}
