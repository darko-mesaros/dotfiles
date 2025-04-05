local fn = vim.fn
-- Automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

require("lazy").setup({
   "wbthomason/packer.nvim", -- Have packer manage itself
   "nvim-lua/plenary.nvim",  -- Useful lua functions used by lots of plugins
   "windwp/nvim-autopairs",  -- Autopairs, integrates with both cmp and treesitter
   "numToStr/Comment.nvim",  -- comment toggling with gcc and gbc
   "JoosepAlviste/nvim-ts-context-commentstring",
   "kyazdani42/nvim-web-devicons",
   "kyazdani42/nvim-tree.lua",  -- replacement for netrw
   "akinsho/bufferline.nvim",  -- adds buffers as tabs
	 "moll/vim-bbye",
   "nvim-lualine/lualine.nvim",  -- flexible status line
   "akinsho/toggleterm.nvim",
   "ahmedkhalf/project.nvim",
   "lewis6991/impatient.nvim",
   { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
   "goolord/alpha-nvim",
	 "folke/which-key.nvim",
   "jinh0/eyeliner.nvim",
   "eandrju/cellular-automaton.nvim", -- make it rain
   "norcalli/nvim-colorizer.lua",     -- convert hex values to colors
   "ojroques/nvim-osc52",             -- support for osc52 clipboard. REMOVE IN VERSION 0.10 when released
   "hedyhli/outline.nvim",
   {
    "nvim-telescope/telescope-cheat.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
        "nvim-telescope/telescope.nvim"
    }
   },
   {
     "folke/todo-comments.nvim",
     dependencies = { "nvim-lua/plenary.nvim" },
   },
   "ron-rs/ron.vim", -- RON Rust file syntax support

  -- generative ai
   "David-Kunz/gen.nvim",
   {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
   },
	-- Colorschemes
   "folke/tokyonight.nvim",
   "lunarvim/darkplus.nvim",
   "bluz71/vim-moonfly-colors",
   "nyoom-engineering/oxocarbon.nvim",
   "ellisonleao/gruvbox.nvim",
   "kepano/flexoki-neovim",
  { 
    "diegoulloao/neofusion.nvim", 
    priority = 1000 , 
    config = true, 
    opts = ... 
  },
  {
  "judaew/ronny.nvim",
  },
  {
    "https://gitlab.com/bartekjaszczak/distinct-nvim",
  },
  {"iagorrr/noctishc.nvim"},



	-- Cmp
   "hrsh7th/nvim-cmp", -- The completion plugin
   "hrsh7th/cmp-buffer", -- buffer completions
   "hrsh7th/cmp-path", -- path completions
	 "saadparwaiz1/cmp_luasnip", -- snippet completions
	 "hrsh7th/cmp-nvim-lsp",
	 "hrsh7th/cmp-nvim-lua",

	-- Snippets
   "L3MON4D3/LuaSnip", --snippet engine
   "rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- LSP
	 "neovim/nvim-lspconfig", -- enable LSP
   "williamboman/mason.nvim", -- simple to use language server installer
   "williamboman/mason-lspconfig.nvim",
	 "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
   "RRethy/vim-illuminate",
   "aznhe21/actions-preview.nvim",

	-- Telescope
	 "nvim-telescope/telescope.nvim",
   "nvim-telescope/telescope-media-files.nvim",

  -- Telescope LuaSnip
  {
  "benfowler/telescope-luasnip.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim"
    }
   },


	-- Treesitter
	"nvim-treesitter/nvim-treesitter",

	-- Git
	 "lewis6991/gitsigns.nvim",

  -- tmux
   "alexghergh/nvim-tmux-navigation",
  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  	{
    "rayliwell/tree-sitter-rstml",
    dependencies = { "nvim-treesitter" },
    build = ":TSUpdate",
    config = function()
      require("tree-sitter-rstml").setup()
    end
	},

  -- commandline and more
  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
      }
  },
  {
    "terrortylor/nvim-comment",
    -- instead of using its own file
    config = function()
      require('nvim_comment').setup()
    end
  },
  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  }
})
