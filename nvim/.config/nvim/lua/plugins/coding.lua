return {
    {
        --[[
        Treesitter plugin confiraguraion.

        Repo: https://github.com/nvim-treesitter/nvim-treesitter
        Wiki: https://github.com/nvim-treesitter/nvim-treesitter/wiki

        `:TSConfigInfo`
        ]]
        "nvim-treesitter/nvim-treesitter",
        -- When updates also update all included parsers
        build = ":TSUpdate",
        -- On which event plugin should be loaded
        event = {
            "BufReadPre", -- When open buffer for existing file
            "BufNewFile", -- When open a new file
        },
        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                -- A list of parser names that should be installed
                -- Supported langs: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
                ensure_installed = {
                    "lua",
                    "luadoc",
                    "python",
                    "bash",
                    "json",
                    "regex",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                    "gitignore",
                    "vim",
                    "vimdoc",
                    "dockerfile",
                    "gpg",
                    "sql",
                    "ssh_config",
                    "toml",
                    "make",
                    "tmux",
                },
                -- Install parsers synchronously (only applied to `ensure_installed`).
                -- false = install async
                sync_install = false,
                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,
                -- Enable syntax highlight
                highlight = {
                    enable = true, -- `false` will disable the whole plugin
                    additional_vim_regex_highlighting = false,
                    -- Disable treesitter highlight for large files when it will be too slow. Took from - https://github.com/nvim-treesitter/nvim-treesitter#modules
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },
                -- Enable indentation guides
                indent = {
                    enable = true,
                },
            })
        end,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = {
            "saadparwaiz1/cmp_luasnip", -- For lua autocompletion
            "rafamadriz/friendly-snippets", -- Usefull snippets
        },
    },
    {
        --[[
        Autocompletion plugin.

        Repo: https://github.com/hrsh7th/nvim-cmp
        Wiki: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

        Doc:
            - All docs: `:h nvim-cmp`
            - About configuration (in cmp.setup({})): `:h cmp-config`
            - All command: `:h cmp-command` or `:Cmp` + <tab>
            - `CmpStatus`
        --]]
        "hrsh7th/nvim-cmp",
        version = false, -- Last release is way too old. Took from here: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
        event = {
            "InsertEnter", -- Load plugin when switch to insert mode
        },
        dependencies = {
            -- Other sources are listed here: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
            -- Buffer and path
            "hrsh7th/cmp-buffer", -- Source for text in current buffer. Repo: https://github.com/hrsh7th/cmp-buffer
            "hrsh7th/cmp-path", -- Source for file system paths. Repo: https://github.com/hrsh7th/cmp-path
            -- LSP
            "hrsh7th/cmp-cmdline", -- ?
            "onsails/lspkind.nvim", -- vs-code like pictograms
            -- Other
            "SergioRibera/cmp-dotenv", -- Cmp for env variables and dotenv file. Repo: https://github.com/SergioRibera/cmp-dotenv
        },
        config = function()
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Configure plugin
            cmp.setup({
                enabled = true,
                completion = {
                    -- Behavior of the cmp plugin
                    completeopt = "menu,preview,noinsert",
                    -- The number of characters needed to trigger auto-completion.
                    keyword_length = 2,
                },
                -- Configure how nvim-cmp interacts with snippet engine
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- Keymapping
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-l>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-k>"] = cmp.mapping.scroll_docs(4),
                    ["<C-a>"] = cmp.mapping.complete(), -- Invoke cmp
                    -- Close completion window
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    -- Accept currently selected item. If none selected, `select` first item.
                    ["<CR>"] = cmp.mapping.confirm({
                        select = false, -- Set to `false` to only confirm explicitly selected items.
                        behavior = cmp.ConfirmBehavior.Replace, -- Replace current position word with suggestion
                    }),
                    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping to accept suggestion.
                    ["<C-y>"] = cmp.config.disable,

                    -- With this enabled <Tab> doesn't work in vim command line mode ( when use `:` ) for autocompletion
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- Sources for autocompletion.
                -- Docs: :h cmp-contig.matching
                -- WARN: Order in this list will be used to prioritize
                -- cmp results.
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "buffer", keyword_length = 3 },
                    { name = "path" },
                    { name = "cmdline" },
                    { name = "dotenv" },
                }),
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    -- configure lspkind for vs-code like pictograms in completion menu
                    format = lspkind.cmp_format({
                        mode = "symbol", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                        -- Icons preset. Can be either 'default' (requires nerd-fonts font)
                        -- or 'codicons' for codicon preset (requires vscode-codicons font)
                        -- preset = "default",
                        -- Override preset symbols. Default: {} (Use from preset)
                        symbol_map = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        },
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        show_labelDetails = false, -- show labelDetails in menu. Disabled by default
                        --     menu = {
                        --         buffer = "[Buffer]",
                        --         nvim_lsp = "[LSP]",
                        --         -- nvim_lua = "[Lua]",
                        --         luasnip = "[LuaSnip]",
                        --         path = "[Path]",
                        --         },
                    }),
                },
                -- `:h cmp-contig.window`
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                    scrollbar = true,
                },
                -- `:h cmp-contig.matching`
                matching = defaults.matching,
                sorting = defaults.sorting,
                experimental = {
                    ghost_text = true,
                },
            })

            -- Completions for text inside vim command lines.
            -- Setup for `/` vim cmdline.
            cmp.setup.cmdline("/", {
                -- mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            -- Setup for `:` vim cmdline.
            cmp.setup.cmdline(":", {
                -- mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { { name = "path" } },
                    {
                        {
                            name = "cmdline",
                            option = { ignore_cmds = { "Man", "!" } },
                        },
                    },
                }),
            })
        end,
    },
    {
        --[[
        Autopair plugin.

        Repo: https://github.com/windwp/nvim-autopairs
        Wiki: https://github.com/windwp/nvim-autopairs/wiki
        --]]
        "windwp/nvim-autopairs",
        event = {
            "InsertEnter", -- Load plugins only on `InsertEnter`
        },
        -- Example: https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/nvim-autopairs.lua
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            -- Import plugin
            local autopairs = require("nvim-autopairs")
            -- Configure plugin
            autopairs.setup({
                check_ts = true, -- enable treesitter
                ts_config = {
                    lua = { "string" }, -- don't add pairs in lua string treesitter nodes
                },
            })

            -- import nvim-autopairs completion functionality
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            -- import nvim-cmp plugin (completions plugin)
            local cmp = require("cmp")

            -- make autopairs and completion work together
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        --[[
        Indent guides plugin.

        Repo: https://github.com/lukas-reineke/indent-blankline.nvim

        `:h ibl.commands`
        ]]
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            local ibl = require("ibl")

            ibl.setup({
                -- Configures the indentation
                -- `:help ibl.config.indent`
                indent = {
                    char = "│",
                    tab_char = "│", -- Indentation for <Tab>. If not set `char` value will be used
                },
                -- `:h ibl.config.scope`
                scope = {
                    -- Scope is desibled because to highlight scopes
                    -- I use `mini.indentscope` plugin defined next.
                    enabled = false, -- Enable scope in indentation guides
                },
                exclude = {
                    -- Where plugin should be desibled
                    filetypes = {
                        "help",
                        "lazy",
                        "mason",
                        "gitcommit",
                        "lspinfo",
                        "NvimTree",
                        "checkhealth",
                        "man",
                        "TelescopePrompt",
                        "TelescopeResults",
                    },
                    -- List of buftypes for which indent-blankline is disabled
                    buftypes = {
                        "terminal",
                        "nofile",
                        "quickfix",
                        "prompt",
                    },
                },
            })
        end,
    },
    {
        --[[
        Highlights the current level of indentation, and animates the highlighting.
        Repo: https://github.com/echasnovski/mini.indentscope
        `:h mini.indentscope`
        ]]
        "echasnovski/mini.indentscope",
        version = false, -- see docs on github
        -- event = "LazyFile", -- TODO: why it doesn't work?
        config = function()
            local indentscope = require("mini.indentscope")

            indentscope.setup({
                -- Draw options
                draw = {
                    -- Delay (in ms) between event and start of drawing scope indicator
                    delay = 100,
                    -- Animation rule for scope's first drawing. A function which, given
                    -- next and total step numbers, returns wait time (in ms). See
                    -- |MiniIndentscope.gen_animation| for builtin options. To disable
                    -- animation, use `require('mini.indentscope').gen_animation.none()`.
                    animation = indentscope.gen_animation.none(), -- animations are disabled now
                    -- Symbol priority. Increase to display on top of more symbols.
                    priority = 2,
                },
                -- Which character to use for drawing scope indicator
                symbol = "│",
                options = {
                    -- Whether to first check input line to be a border of adjacent scope.
                    -- Use it if you want to place cursor on function header to get scope of
                    -- its body.
                    try_as_border = true,

                    -- Whether to use cursor column when computing reference indent.
                    -- Useful to see incremental scopes with horizontal cursor movements.
                    indent_at_cursor = true,

                    -- Type of scope's border: which line(s) with smaller indent to
                    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
                    border = "top",
                },
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    -- Textobjects
                    object_scope = "",
                    object_scope_with_border = "",

                    -- Motions (jump to respective border line; if not present - body line)
                    goto_top = "[i",
                    goto_bottom = "]i",
                },
            })

            vim.api.nvim_create_autocmd("FileType", {
                -- Where plugin should be desibled same as in exclude section of above plugin
                pattern = {
                    "help",
                    "lazy",
                    "mason",
                    "gitcommit",
                    "lspinfo",
                    "NvimTree",
                    "checkhealth",
                    "man",
                    "TelescopePrompt",
                    "TelescopeResults",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },
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
            comment.setup({
                -- for commenting tsx and jsx files
                pre_hook = ts_context_commentstring.create_pre_hook(),
                ---Lines to be ignored while (un)comment
                ignore = "^$", -- Ignore empty lines in all filetypes
                ---LHS of toggle mappings in NORMAL mode
                toggler = {
                    --Line-comment toggle keymap
                    line = "<leader>/",
                },
                -- LHS of operator-pending mappings in NORMAL and VISUAL mode
                opleader = {
                    -- Line-comment keymap
                    line = "<leader>/",
                    -- Block-comment keymap
                    block = "<leader>//",
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        --[[
        Adds highlights for markdown.
        Repo: https://github.com/lukas-reineke/headlines.nvim
        --]]
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            local headlines = require("headlines")
            headlines.setup({})
        end,
    },
}
