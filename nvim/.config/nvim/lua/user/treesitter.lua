-- nvim-treesitter (main branch) — compatible with Neovim 0.12
-- setup() and ensure_installed are gone; parsers are installed manually,
-- highlighting/indentation are enabled via FileType autocmd.

local parsers = {
  "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx",
  "css", "rust", "java", "yaml", "markdown", "markdown_inline", "vim",
  "regex", "toml",
}

-- Install any missing parsers
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

local ok2, ts_config = pcall(require, "nvim-treesitter.config")
if ok2 then
  local installed = ts_config.get_installed()
  local missing = vim.iter(parsers)
    :filter(function(p) return not vim.tbl_contains(installed, p) end)
    :totable()
  if #missing > 0 then
    ts.install(missing)
  end
end

-- Enable highlighting and indentation per filetype
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
