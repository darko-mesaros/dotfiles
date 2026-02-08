local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
  return
end

vim.o.foldcolumn = '0' -- No fold column
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', ufo.openAllFolds, {desc = "Open all folds"})
vim.keymap.set('n', 'zM', ufo.closeAllFolds, {desc = "Close all folds"})
vim.keymap.set('n', 'zK', function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, {desc = "Peek fold"})

ufo.setup {
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
}

