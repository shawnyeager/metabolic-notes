# metabolic-notes

A note-taking system that forces you to think, not just collect.

Based on Joan Westenberg's [A Metabolic Workspace](https://joanwestenberg.com/a-metabolic-workspace/).

**Requirements:** [LazyVim](https://www.lazyvim.org/) (includes Telescope). Vanilla Neovim users: install [Telescope](https://github.com/nvim-telescope/telescope.nvim) first.

## The Problem

You've tried this before: Notion, Obsidian, Roam. You set up folders, tags, bidirectional links. You clip articles. You build an elaborate archive.

And then you never look at any of it.

The system grows. Your thinking doesn't. Saving something feels like engaging with it, but it's not—it's just moving text from one place to another.

## The Metabolic Alternative

Treat information like food, not possessions. Food has to be digested to provide value. If you don't process it, it rots. Same with ideas.

This system has one job: **force you to think about what you encounter, not just collect it.**

Nothing enters the system unless you process it first. No clipping. No copy-paste. You read something, close it, and write down what you remember in your own words.

## The Six Practices

### 1. Single Daily Note
Everything goes in one file per day. Thoughts, tasks, quotes, observations—all of it. No categorization, no folders, no deciding where something belongs.

### 2. Echo-Only Capture
You cannot copy-paste anything into the system. To add an idea from something you read, you must close the source and write from memory.

### 3. The WHAT Anchor
One file sits at the center with three sections:
- **What I am becoming** — the person you're trying to grow into
- **What I am building** — your current primary project or focus
- **What I am learning** — the skill or subject you're actively studying

### 4. Weekly Extraction
Every week, review your daily notes. Pull out the 1-2 sentences that actually shifted your thinking. Everything else served its purpose and can fade.

### 5. Action Tags
Tags that demand something from you:
- `#To-Argue` — a position to defend or attack
- `#To-Test` — a hypothesis to try
- `#To-Teach` — something to explain
- `#To-Build` — a thing to create
- `#To-Question` — an assumption to examine

### 6. Context Capture
Add a brief note about when and how a thought arrived: "3am, couldn't sleep" or "right after the frustrating client call."

## Installation

```bash
git clone https://github.com/shawnyeager/metabolic-notes.git
cd metabolic-notes
make
```

This installs everything:
- `note` CLI to `~/.local/bin/`
- Neovim plugin to `~/.local/share/nvim/site/` (auto-loads)
- Shell aliases to `~/.local/share/metabolic-notes/aliases` (sourced from `~/.bashrc`)

### Partial Installation

| Command | What it does |
|---------|--------------|
| `make cli` | CLI script + notes directory structure |
| `make nvim` | Neovim plugin only |
| `make aliases` | Add shell aliases to config |

### Make Options

```bash
make SHELL_RC=~/.zshrc         # for zsh users (default: ~/.bashrc)
make NOTES_DIR=~/notes         # custom notes location (default: ~/Work/notes)
```

## Usage

### Shell Commands

| Command | Action |
|---------|--------|
| `nn` | Open today's daily note |
| `nw` | Open WHAT anchor |
| `nx` | Open extracted directory |
| `nk` | Weekly extraction view |
| `nt` | List action tags with counts |
| `nn add <text>` | Quick append to today |

### Neovim Keybindings

| Key | Action |
|-----|--------|
| `<leader>nn` | Daily note |
| `<leader>nw` | WHAT anchor |
| `<leader>ne` | Browse extracted (Telescope) |
| `<leader>nb` | Browse daily notes (Telescope) |
| `<leader>ng` | Grep all notes |
| `<leader>nt` | Search action tags |
| `<leader>nx` | Split WHAT for extraction |
| `<leader>nk` | Weekly extraction view |

## Daily Workflow

1. `nn` — open today's note
2. Dump everything: thoughts, tasks, observations, questions
3. When you read something interesting, close it and write what stuck (echo-only)
4. Add context when relevant: "after the board call, finally saw the problem"
5. Tag actionable thoughts: `#To-Test`, `#To-Argue`, etc.

## Weekly Extraction (Sunday)

1. `nk` — opens the week's notes alongside WHAT.md
2. Scan each day looking for sentences that shifted your thinking
3. Ask: does this connect to what I'm becoming/building/learning?
4. Yank what survives → paste into WHAT.md or create an extracted note
5. `nt` — review your action tags, decide what to act on this week

## Configuration

### Notes Directory

Set `NOTES_DIR` to change where notes are stored (both CLI and Neovim use this):

```bash
# Add to ~/.bashrc or ~/.zshrc
export NOTES_DIR="$HOME/notes"  # default: ~/Work/notes
```

If using a custom location, set this **before** running `make` so the directory is created in the right place.

### CLI

```bash
export EDITOR="nvim"  # default: nvim
```

### Neovim

Add to your Neovim config (e.g., `~/.config/nvim/init.lua`):

```lua
require("metabolic").setup({
  notes_dir = "~/notes",    -- overrides NOTES_DIR env var
  leader = "<leader>m",     -- default: <leader>n
})
```

## Directory Structure

```
~/Work/notes/
├── WHAT.md           # Your anchor file
├── daily/            # 2025-01-15.md, 2025-01-16.md, etc.
└── extracted/        # Notes that survived weekly extraction
```

## Credits

Concept: Joan Westenberg's [A Metabolic Workspace](https://joanwestenberg.com/a-metabolic-workspace/)

Implementation: [Shawn Yeager](https://shawnyeager.com)

## License

MIT
