return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy";
      },
      cargo = {
        allFeatures = true,
      },
      diagnostics = {
        enable = true;
      },
      hoverActions = {
        enable = true,
      },
      lens = {
        enable = true,
      },
      -- Other Settings ...
      procMacro = {
        enable = true,
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

