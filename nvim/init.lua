-- Ilaris Super Config Deluxe Special Edition 2025
-- Fully self-contained single-file Neovim config

-- =======================================================
-- BOOTSTRAP lazy.nvim
-- =======================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- =======================================================
-- BASIC OPTIONS
-- =======================================================
vim.g.mapleader = " "

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true

-- System clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Enable filetype detection + plugins + indentation
vim.cmd("filetype plugin indent on")

-- =======================================================
-- KEYMAPS
-- =======================================================

-- Go to end of line using Swedish keyboard (ö)
vim.keymap.set("n", "ö", "$")

-- Close windows
vim.keymap.set("n", "<leader>q", ":cclose<CR>")
vim.keymap.set("n", "<leader>l", ":lclose<CR>")

-- =======================================================
-- PLUGINS
-- =======================================================

require("lazy").setup({

	--------------------------------------------------------
	-- Colorscheme: Catppuccin
	--------------------------------------------------------
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end
	},

	--------------------------------------------------------
	-- Lualine (statusline)
	--------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
				}
			})
		end
	},

	--------------------------------------------------------
	-- Neo-tree (file explorer)
	--------------------------------------------------------
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false, -- load immediately
 		config = function()
            vim.keymap.set("n", "<C-n>", ":Neotree toggle right<CR>", {})
		end
	},

	--------------------------------------------------------
	-- Telescope (fuzzy finder)
	--------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		end
	},

	-- Telescope UI Select
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({})
				}
			})
			require("telescope").load_extension("ui-select")
		end
	},

	--------------------------------------------------------
	-- Treesitter (syntax + highlighting)
	--------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "javascript" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},

    --------------------------------------------------------
    -- LSP + Mason (Lua + C + Python via Ruff + Pyright)
    --------------------------------------------------------
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "pyright",  -- Full Python LSP
                },
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            --------------------------------------------------
            -- Lua
            --------------------------------------------------
            lspconfig.lua_ls.setup({})
            --------------------------------------------------
            -- C (clangd)
            --------------------------------------------------
            lspconfig.clangd.setup({})
            --------------------------------------------------
            -- Python: Pyright (full language features)
            --------------------------------------------------
            lspconfig.pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })
            --------------------------------------------------
            -- LSP Keymaps
            --------------------------------------------------
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({"n","v"}, "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "gl", vim.diagnostic.open_float, {})
        end
    },
})
