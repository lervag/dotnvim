vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- Det som kommer under er konfigurering av nvim-jdtls; eg følger beskrivelsen
-- til README relativt slavisk. Det ser litt "stygt" ut, men det fungerer og er
-- ganske robust!
-- https://github.com/mfussenegger/nvim-jdtls

local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" })
if root_dir == nil then
  vim.notify(
    "Advarsel: Finner ikke rot-mappe, jdtls ikke startet",
    vim.log.levels.WARN
  )
  return
end

local jarfile =
  vim.fn.glob "/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
local project_dir = vim.fn.stdpath "cache"
  .. "/jdtls/"
  .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local configdir = project_dir .. "/config"
local datadir = project_dir .. "/workspace"

-- Sørg for at jdtls config er definert - kopier default config
if vim.fn.filereadable(configdir .. "/config.ini") == 0 then
  vim.fn.mkdir(configdir, "p")
  vim.fn.system {
    "cp",
    "/usr/share/java/jdtls/config_linux/config.ini",
    configdir .. "/config.ini",
  }
end

local jdtls = require "jdtls"
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local init_bundles = {}
local java_debug_jars = vim.fn.glob(
  "~/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/*/com.microsoft.java.debug.plugin-*.jar",
  true,
  true
)
if #java_debug_jars > 0 then
  table.insert(init_bundles, java_debug_jars[1])
else
  vim.notify(
    [[Advarsel: Finner ikke java-debug!
    git clone https://github.com/microsoft/java-debug ~/workdir/java-debug
    cd ~/workdir/java-debug
    mise shell java@temurin-22.0.1+8
    ./mvnw clean install
  ]],
    vim.log.levels.WARN
  )
end

local vscode_java_test =
  vim.fn.glob("~/.local/share/vscode-java-test/server/*.jar", true, true)
if #vscode_java_test > 0 then
  vim.list_extend(init_bundles, vscode_java_test)
else
  vim.notify(
    [[Advarsel: Finner ikke vscode-java-test! Installer slik:
    git clone https://github.com/microsoft/vscode-java-test ~/.local/share/vscode-java-test
    cd ~/.local/share/vscode-java-test
    mise shell java@temurin-22.0.1+8
    npm install
    npm run build-plugin
  ]],
    vim.log.levels.WARN
  )
end

local config = {
  --stylua: ignore start
  cmd = {
    "/home/lervag/.local/share/mise/installs/java/temurin-22.0.1+8/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", jarfile,
    "-configuration", configdir,
    "-data", datadir
  },
  --stylua: ignore end
  root_dir = root_dir,

  -- Configure jdtls specific settings
  -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      implementationsCodeLens = {
        enabled = false,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
    },
  },

  on_attach = function(_, bufnr)
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>lo", jdtls.organize_imports, opts)

    vim.keymap.set("n", "<leader>lev", jdtls.extract_variable, opts)
    vim.keymap.set(
      "v",
      "<leader>lev",
      [[<esc><cmd>lua require("jdtls").extract_variable(true)<cr>]],
      opts
    )
    vim.keymap.set(
      "v",
      "<leader>lem",
      [[<esc><cmd>lua require('jdtls').extract_method(true)<cr>]],
      opts
    )
    vim.keymap.set("n", "<leader>lec", jdtls.extract_constant, opts)

    vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
    vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
    vim.keymap.set("n", "<leader>dp", jdtls.pick_test, opts)
  end,

  init_options = {
    bundles = init_bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
}

if vim.fn.executable(config.cmd[1]) == 0 then
  vim.notify(
    [[Java-installasjonen mangler! Kan ikke starte jdtls!
    Installer slik:
    * mise install java@temurin-22.0.1+8
    * mise x java@temurin-22.0.1+8 -- which java
  ]],
    vim.log.levels.ERROR
  )
  return
end

jdtls.start_or_attach(config)
