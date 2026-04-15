local servers = {
  -- they are nvim lsp servers: 
  -- more info here: 
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	"lua_ls",
	"cssls",
	"html",
  --"tsserver",
  "vtsls",
  --"pylsp",
  "bashls",
	"jsonls",
	"yamlls",
  "marksman",
  "clangd",
  "terraformls",
  "rust_analyzer",
  "asm_lsp",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local base_opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

for _, server in pairs(servers) do
	server = vim.split(server, "@")[1]

	local opts = vim.deepcopy(base_opts)
	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
end
