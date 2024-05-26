local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  ensure_installed = { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "java", "yaml", "markdown", "markdown_inline", "vim", "regex", "toml" }, -- one of "all" or a list of languages
  sync_install = false,
	ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
})
