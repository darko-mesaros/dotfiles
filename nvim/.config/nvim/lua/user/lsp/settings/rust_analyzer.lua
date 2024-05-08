return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy";
      },
      diagnostics = {
        enable = true;
      },
      -- Other Settings ...
      procMacro = {
        ignored = {
            leptos_macro = {
                -- optional: --
                -- "component",
                "server",
            },
        },
      },
    },
  }
}

