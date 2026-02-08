local jdtls = require("jdtls")

local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then return end

local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. project

jdtls.start_or_attach({
  cmd = {
    "java",
    "-jar", launcher,
    "-configuration", jdtls_dir .. "/config_mac",
    "-data", workspace,
  },
  root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew" }),
})
