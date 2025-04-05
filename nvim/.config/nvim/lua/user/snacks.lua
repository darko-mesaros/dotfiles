local status_ok, snacks = pcall(require, "snacks")
if not status_ok then
  return
end

snacks.setup({
  dim = {
    enabled = true,
  },
  notifier = {
    enable = false,
  },
  notify = {
    enable = true,
  },
  scratch = {
    enabled = true,
  },
  zen = {
    enabled = true,
    toggles = {
      dim = true,
    },
    win = {
      style = 'zen'
    },
    show = {
      statusline = false,
      tabline = false,
    }
  }
})
