# microHelp

A [micro](https://micro-editor.github.io/) plugin that gives you instant access to your personal docs and system man pages without leaving the editor.

## Why

When you're deep in a coding session the last thing you want is to switch windows just to check a note or look up a command flag. microHelp lets you:

- Keep personal notes, cheatsheets, and how-to guides as plain `.txt` files in `~/microDocs/` and pull them up in a side pane in one command.
- Open them **read-only** so you can't accidentally edit your notes, or **editable** when you actually want to make changes.
- Look up any **man page** the same way, rendered clean without escape codes, right inside micro.

## Requirements

- micro >= 2.0.0
- `man` available in your `$PATH` (standard on Linux/macOS)

## Installation

Clone or download this repository, then run:

```sh
make install
```

This will:
1. Create `~/.config/micro/plug/microHelp/` and copy the plugin files there.
2. Create `~/microDocs/` and copy the bundled sample docs into it.

Then restart micro.

## Adding your own docs

Drop any `.txt` file into `~/microDocs/`. Subdirectories are supported:

```
~/microDocs/
    git.txt
    go.txt
    notes/
        setup.txt
        shortcuts.txt
```

## Commands

### `docs <topic>`

Opens `~/microDocs/<topic>.txt` in a **read-only** right-side pane. The `.txt` extension is added automatically.

```
docs go
docs notes/setup
docs go.txt        # extension is optional
```

### `docs -e <topic>`

Opens the same file **editable** — useful when you want to update your notes on the fly.

```
docs -e go
```

### `docs -list`

Lists all `.txt` files currently installed in `~/microDocs/` in a read-only side pane.

```
docs -list
```

### `man <command>`

Renders the system man page for any command in a read-only right-side pane.

```
man ls
man git
man 3 printf
```

## Pane behaviour

All panes opened by microHelp:
- Appear on the **right side** of the current pane.
- Are **scratch buffers** — micro will not prompt you to save them when you close them.
- Show the doc name or `man <command>` on the left statusline and `readonly` / `editable` on the right.

## Project structure

```
help.lua        plugin source
repo.json       plugin metadata
Makefile        install helper
docs/           bundled sample docs copied to ~/microDocs on install
```
