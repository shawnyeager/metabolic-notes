-- metabolic-notes: A note-taking system that forces you to think
-- https://github.com/shawnyeager/metabolic-notes

local M = {}

M.config = {
  notes_dir = os.getenv("NOTES_DIR") or (os.getenv("HOME") .. "/Work/notes"),
  leader = "<leader>n",
}

local function daily_note()
  local path = M.config.notes_dir .. "/daily/" .. os.date("%Y-%m-%d") .. ".md"
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(M.config.notes_dir .. "/daily", "p")
    vim.fn.writefile({ "# " .. os.date("%Y-%m-%d") }, path)
  end
  vim.cmd("e " .. path)
end

local function what_anchor()
  vim.cmd("e " .. M.config.notes_dir .. "/WHAT.md")
end

local function extracted_notes()
  require("telescope.builtin").find_files({
    cwd = M.config.notes_dir .. "/extracted",
  })
end

local function browse_daily()
  require("telescope.builtin").find_files({
    cwd = M.config.notes_dir .. "/daily",
  })
end

local function grep_notes()
  require("telescope.builtin").live_grep({
    cwd = M.config.notes_dir,
  })
end

local function action_tags()
  require("telescope.builtin").live_grep({
    cwd = M.config.notes_dir,
    default_text = "#To-",
  })
end

local function split_what()
  vim.cmd("vsplit " .. M.config.notes_dir .. "/WHAT.md")
end

local function weekly_extraction()
  local tmp = vim.fn.tempname() .. ".md"
  local f = io.open(tmp, "w")
  if not f then
    vim.notify("Failed to create temp file", vim.log.levels.ERROR)
    return
  end

  for i = 6, 0, -1 do
    local day = os.date("%Y-%m-%d", os.time() - i * 86400)
    local path = M.config.notes_dir .. "/daily/" .. day .. ".md"
    local file = io.open(path, "r")
    if file then
      f:write(file:read("*a") .. "\n---\n\n")
      file:close()
    end
  end
  f:close()

  vim.cmd("e " .. tmp)
  vim.cmd("vsplit " .. M.config.notes_dir .. "/WHAT.md")
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  local leader = M.config.leader

  -- Register keymaps
  vim.keymap.set("n", leader .. "n", daily_note, { desc = "Daily note" })
  vim.keymap.set("n", leader .. "w", what_anchor, { desc = "WHAT anchor" })
  vim.keymap.set("n", leader .. "e", extracted_notes, { desc = "Extracted notes" })
  vim.keymap.set("n", leader .. "b", browse_daily, { desc = "Browse daily notes" })
  vim.keymap.set("n", leader .. "g", grep_notes, { desc = "Grep all notes" })
  vim.keymap.set("n", leader .. "t", action_tags, { desc = "Action tags" })
  vim.keymap.set("n", leader .. "x", split_what, { desc = "Split WHAT (for extraction)" })
  vim.keymap.set("n", leader .. "k", weekly_extraction, { desc = "Weekly extraction" })

  -- Register which-key group if available
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({ { leader, group = "notes" } })
  end
end

return M
