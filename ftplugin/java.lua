local jdtls_dir = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'
local config_dir = jdtls_dir .. '/config_mac'
local plugin_dir = jdtls_dir .. '/plugins'
local path_to_jar = jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar'
local path_to_lombok = jdtls_dir .. '/lombok.jar'

local root_markers = {
  'gradlew',
  '.git',
  'mvnw',
}

local root_dir = vim.fs.root(0, root_markers)

if root_dir == '' then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
-- this is where jdtls stores the cache files
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name

local config = {
  -- The command that starts the language server
  -- See https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. path_to_lombok,
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL_UNNAMED',
    '-jar',
    path_to_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  },

  root_dir = root_dir,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath 'config' .. '/java/eclipse-java-google-style.xml',
        },
      },
    },
  },
}

require('jdtls').start_or_attach(config)
