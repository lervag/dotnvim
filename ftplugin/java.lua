local dap = require "dap"

dap.adapters.java = function(callback)
  callback {
    type = "server",
    host = "127.0.0.1",
    port = 5005,
  }
end

dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- Merk at java-versjon er installert med rtx
-- * rtx install java@temurin-17.0.5+8
-- * rtx x java@temurin-17.0.5+8 -- which java
local jdtls = require "jdtls"
local root_dir = require("jdtls.setup").find_root { "mvnw", ".git" }

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = {
    "/home/lervag/.local/share/rtx/installs/java/temurin-17.0.5+8/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=/usr/share/java/jdtls/config_linux",
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob "/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
    "-configuration",
    "/home/lervag/.local/share/eclipse/config",
    "-data",
    "/home/lervag/.local/share/eclipse/"
      .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
  },
  root_dir = root_dir,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.assertj.core.api.Assertions.assertThat",
          "org.assertj.core.api.Assertions.assertThatThrownBy",
          "org.assertj.core.api.Assertions.assertThatExceptionOfType",
          "org.assertj.core.api.Assertions.catchThrowable",
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    jdtls.setup_dap { hotcodereplace = "auto" }
    jdtls.setup.add_commands()
    -- local opts = { silent = true, buffer = bufnr }
    -- vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts)
    -- vim.keymap.set('n', "<leader>df", function()
    --   if vim.bo.modified then
    --     vim.cmd('w')
    --   end
    --   jdtls.test_class()
    -- end, opts)
    -- vim.keymap.set('n', "<leader>dn", function()
    --   if vim.bo.modified then
    --     vim.cmd('w')
    --   end
    --   jdtls.test_nearest_method()
    -- end, opts)

    -- vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
    -- vim.keymap.set('v', "crv", [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], opts)
    -- vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
    -- vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
    -- local create_command = vim.api.nvim_buf_create_user_command
    -- create_command(bufnr, 'W', require('me.lsp').remove_unused_imports, {
    --   nargs = 0,
    -- })
  end,
  init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
  },
  -- mute; having progress reports is enough
  -- handlers['language/status'] = function() end
}

jdtls.start_or_attach(config)
