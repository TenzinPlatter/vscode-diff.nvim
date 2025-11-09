-- vscode-diff main API
local M = {}

-- Load VERSION once globally at module load time
-- Navigate from lua/vscode-diff/init.lua -> lua/vscode-diff/ -> lua/ -> plugin root
do
  local source = debug.getinfo(1).source:sub(2)
  local plugin_root = vim.fn.fnamemodify(source, ":h:h:h")
  local version_file = plugin_root .. "/VERSION"
  local f = io.open(version_file, "r")
  if f then
    -- Read only the first line and trim whitespace
    local line = f:read("*line")
    f:close()
    if line then
      M.VERSION = line:match("^%s*(.-)%s*$")
    end
  end
end

-- Configuration setup
function M.setup(opts)
  local config = require("vscode-diff.config")
  config.setup(opts)
  
  -- Setup highlights (this also initializes lifecycle management)
  local render = require("vscode-diff.render")
  render.setup_highlights()
end

-- Lazy-load modules to avoid circular dependencies
local function get_diff()
  return require("vscode-diff.diff")
end

local function get_render()
  return require("vscode-diff.render")
end

local function get_git()
  return require("vscode-diff.git")
end

-- Re-export diff module
function M.compute_diff(...)
  return get_diff().compute_diff(...)
end

function M.get_version(...)
  return get_diff().get_version(...)
end

-- Re-export render module
function M.setup_highlights(...)
  return get_render().setup_highlights(...)
end

function M.render_diff(...)
  return get_render().render_diff(...)
end

function M.create_diff_view(...)
  return get_render().create_diff_view(...)
end

-- Re-export git module
function M.is_in_git_repo(...)
  return get_git().is_in_git_repo(...)
end

function M.get_file_at_revision(...)
  return get_git().get_file_at_revision(...)
end

return M
