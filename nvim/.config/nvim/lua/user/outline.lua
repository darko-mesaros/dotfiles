local status_ok, outline = pcall(require, "outline")
if not status_ok then
  return
end

outline.setup({
  symbol_folding = {
    autofold_depth = false
  },
})

