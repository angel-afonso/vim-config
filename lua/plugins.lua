local M = {}

_G.dump = function(...)
    print(vim.inspect(...))
end

function M.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        profile = {
            enable = true,
            threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
        },

        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            }
            vim.cmd [[packadd packer.nvim]]
        end
        vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    end

    -- Plugins
    local function plugins(use)
        use { "wbthomason/packer.nvim" }

        -- Load only when require
        use { "nvim-lua/plenary.nvim", module = "plenary" }

        -- Colorscheme
        use {
            "folke/tokyonight.nvim",
            config = function()
                vim.cmd "colorscheme tokyonight"
            end
        }

        -- Startup screen
        use {
            "goolord/alpha-nvim",
            config = function()
                require("config.alpha").setup()
            end,
        }

        -- Git
        use {
            "TimUntersberger/neogit",
            cmd = "Neogit",
            config = function()
                require("config.neogit").setup()
            end,
        }

        -- Copilot
        use 'github/copilot.vim'

        -- WhichKey
        use {
            "folke/which-key.nvim",
            event = "VimEnter",
            config = function()
                require("config.whichkey").setup()
            end,
        }

        -- IndentLine
        use {
            "lukas-reineke/indent-blankline.nvim",
            event = "BufReadPre",
            config = function()
                require("config.indentblankline").setup()
            end,
        }

        -- Better icons
        use {
            "kyazdani42/nvim-web-devicons",
            module = "nvim-web-devicons",
            config = function()
                require("nvim-web-devicons").setup { default = true }
            end,
        }

        -- Better Comment
        use {
            "numToStr/Comment.nvim",
            keys = { "gc", "gcc", "gbc" },
            config = function()
                require("Comment").setup {}
            end,
        }

        -- Status line
        use {
            "nvim-lualine/lualine.nvim",
            event = "VimEnter",
            config = function()
                require("config.lualine").setup()
            end,
            requires = { "nvim-web-devicons" },
        }

        -- Treesitter
        use {
           "nvim-treesitter/nvim-treesitter",
           run = ":TSUpdate",
           config = function()
               require("config.treesitter").setup()
           end,
        }

        use {
            "SmiteshP/nvim-gps",
            requires = "nvim-treesitter/nvim-treesitter",
            module = "nvim-gps",
            config = function()
                require("nvim-gps").setup()
            end,
        }

        -- Telescope
        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.0',
            config = function()
                require("config.telescope").setup()
            end,
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        use { "williamboman/mason.nvim" }
        use { "williamboman/mason-lspconfig.nvim" }
        use { "glepnir/lspsaga.nvim" }

        use {
          "hrsh7th/nvim-cmp",
          event = "InsertEnter",
          opt = true,
          config = function()
            require("config.cmp").setup()
          end,
          wants = { "LuaSnip" },
          requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "ray-x/cmp-treesitter",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-calc",
            "f3fora/cmp-spell",
            "hrsh7th/cmp-emoji",
            {
              "L3MON4D3/LuaSnip",
              wants = "friendly-snippets",
              config = function()
                require("config.luasnip").setup()
              end,
            },
            "rafamadriz/friendly-snippets",
            disable = false,
          },
        }
        
        -- LSP
        use {
            "neovim/nvim-lspconfig",
            opt = true,
            event = "BufReadPre",
            config = function()
                require("config.lsp").setup()
            end,
            requires = {
                'glepnir/lspsaga.nvim',
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            }
        }

        -- File explorer
        use {
            'kyazdani42/nvim-tree.lua',
            config = function()
                require('config.nvimtree').setup()
            end,
            requires = {
                'kyazdani42/nvim-web-devicons'
            },
        }

        -- Bootstrap Neovim
        if packer_bootstrap then
            print "Restart Neovim required after installation!"
            require("packer").sync()
        end
    end

    packer_init()

    local packer = require "packer"
    packer.init(conf)
    packer.startup(plugins)
end

return M
