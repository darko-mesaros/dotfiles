local status_ok, codecast = pcall(require, "codecast")
if not status_ok then
  return
end

codecast.setup {
  snippets_dir = vim.fn.stdpath('config') .. '/codecast/snippets',
  typewriter_speed = 50,
  default_insert_mode = 'typewriter',
  keybindings = {
    show_snippets = '<leader>cc'
  }
}
