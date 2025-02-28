return {
  {
    opts = function()
      return {
        servers = {
          glsl_analyzer = {
            filetypes = { "gl", "vert", "frag" },
          },
        },
      }
    end,

    config = function(_, opts)
      require("lspconfig").glsl_analyzer.setup(opts.servers.glsl_analyzer)
    end,
  },
}
