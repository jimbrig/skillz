This file is a merged representation of a subset of the codebase, containing specifically included files, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: docs/
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
````
docs/
  configuration.md
  editors.md
  ipc.md
  r-resolve.md
````

# Files

## File: docs/configuration.md
````markdown
# Configuration

arf uses a TOML configuration file following the XDG Base Directory specification.

> [!WARNING]
> The configuration file format is not yet stable and may change in future versions.

## Configuration File Location

The configuration file is located at:

- **Linux**: `~/.config/arf/arf.toml`
- **macOS**: `~/Library/Application Support/arf/arf.toml`
- **Windows**: `C:\Users\<user>\AppData\Roaming\arf\arf.toml`

You can also specify a custom config file with the `--config` flag:

```bash
arf --config /path/to/arf.toml
```

## Generating a Default Config

Use the built-in command to generate a default configuration file:

```bash
arf config init
```

To overwrite an existing config:

```bash
arf config init --force
```

## Default Configuration

If no configuration file exists, arf uses these defaults:

```toml
#:schema https://raw.githubusercontent.com/eitsupi/arf/main/artifacts/arf.schema.json

[startup]
r_source = "auto"       # How to locate R: "auto", "rig", or { path = "..." }
show_banner = true      # Show startup banner

reprex = "off"          # "off", "on", or "format"

[ipc.eval]
# Exact direct function/operator targets permitted by `arf ipc eval`; empty by default.
# Examples: ["mean", "stats::median", "+"]
allowed_functions = []

[editor]
mode = "emacs"          # Editing mode: "emacs" or "vi"
auto_match = true       # Auto-close brackets and quotes
highlight_matching_bracket = false  # Highlight matching bracket pair
auto_suggestions = "all" # History suggestions: "none", "all", or "cwd"

# Keyboard shortcuts (crokey format)
[editor.key_map]
"alt-hyphen" = " <- "      # Alt+- inserts assignment operator
"alt-p" = " |> "           # Alt+P inserts pipe operator (P = Pipe)

[prompt]
format = "{status}R {version}> "   # Main prompt (includes status indicator)
continuation = "+  "       # Continuation prompt for multiline input
shell_format = "[{shell}] $ "  # Shell mode prompt
mode_indicator = "prefix"  # Position of mode indicator: "prefix", "suffix", or "none"

[prompt.status]
override_prompt_color = false  # Also change entire prompt color based on status

[prompt.status.symbol]
success = ""               # Status symbol on success (empty = hidden)
error = "✗ "               # Status symbol on error

[prompt.vi.symbol]
insert = "[I] "            # Vi insert mode indicator
normal = "[N] "            # Vi normal mode indicator
non_vi = ""                # Non-vi modes (Emacs, etc.)

[prompt.indicators]
reprex = "[reprex] "       # Indicator text for reprex mode
reprex_format = "[format] " # Indicator text for formatted reprex mode

[completion]
enabled = true             # Enable tab completion
timeout_ms = 50            # Completion timeout in milliseconds
debounce_ms = 100          # Debounce delay for completion
max_height = 10            # Maximum height of completion menu
auto_paren_limit = 50      # Max packages to check for function paren insertion

[history]
menu_max_height = 15       # Maximum height of history search menu (Ctrl+R)
mode = "persistent"        # "persistent" or session-only "volatile"
# mode = { dir = "/custom/path" }  # Custom directory when mode is persistent

[r]
auto_width = true          # Sync R's options(width) with terminal size

[reprex]
comment = "#> "            # Comment prefix for reprex output
formatter = "auto"         # "auto", "air" (>= 0.9.0), or "arity" (>= 0.18.0)

# Syntax highlighting colors
[colors.r]
comment = "DarkGray"
string = "Green"
number = "LightMagenta"
keyword = "LightBlue"
constant = "LightCyan"
operator = "Yellow"
punctuation = "Default"
identifier = "Default"
matching_bracket = "LightYellow"  # Background color for matching bracket highlight

[colors.meta]
command = "Magenta"

[colors.prompt]
main = "LightGreen"
continuation = "LightGreen"
shell = "LightRed"
indicator = "Yellow"

[colors.prompt.status]
success = "LightGreen"     # Color for success (symbol and/or prompt)
error = "LightRed"         # Color for error (symbol and/or prompt)

[colors.prompt.vi]
insert = "LightGreen"     # Color for vi insert mode indicator
normal = "LightYellow"    # Color for vi normal mode indicator
non_vi = "Default"         # Color for non-vi modes (Emacs, etc.)

[experimental]
shell_semicolon_shortcut = false  # `;` at empty prompt switches to shell mode

[experimental.shell_abbreviations]
# Fish-style abbreviations for shell mode (expanded on Space/Enter)
# "gc" = "git commit"

[experimental.history_forget]
enabled = false            # Auto-remove failed commands from history
delay = 2                  # Keep last N failed commands for retry
on_exit_only = false       # Purge on each prompt (false) or only on exit (true)

[experimental.r_completion]
fuzzy = false              # Fuzzy matching for pkg::func and library() completions
package_functions = ["library", "require"]  # Functions that trigger package name completion

[experimental.r_completion.static.formals]
mode = "off"              # "off" or "prefer-static" for pkg::foo( argument completion

[experimental.r_completion.static.formals.exclusions]
packages = []              # Package names that always use R completion
functions = []             # Public names such as "pkg::function" that use R completion

[experimental.prompt_spinner]
frames = ""                # Animation frames (empty = disabled)
color = "Cyan"             # Spinner color

[experimental.prompt_duration]
format = "{value} "        # Duration display format ({value} = time string)
threshold_ms = 2000        # Show duration only for commands slower than this (ms)

```

## Bracket Highlighting

arf can highlight matching bracket pairs (`()`, `[]`, `{}`) when the cursor is on or immediately after a bracket. Both brackets are highlighted with a background color while preserving the syntax foreground color. The matching is syntax-aware via tree-sitter — brackets inside strings and comments are correctly ignored.

```toml
[editor]
highlight_matching_bracket = true

[colors.r]
matching_bracket = "LightYellow"  # Background color for both brackets
```

This feature is disabled by default. Set `matching_bracket` to `"Default"` to disable the background color while keeping bracket detection active.

## Auto Width

When `auto_width` is enabled (default), arf automatically syncs R's `options(width)` with the terminal width at startup and on resize. This ensures output from functions like `str()`, `print()`, and tibble printing uses the full available terminal width instead of R's default of 80 columns.

```toml
[r]
auto_width = true  # default
```

Set to `false` if you prefer to manage `options(width)` manually (e.g., via `.Rprofile`).

## Auto Suggestions

arf supports fish/nushell-style autosuggestions that appear as you type. These grayed-out suggestions can be accepted with the right arrow key.

### Configuration

```toml
[editor]
auto_suggestions = "all"  # "none", "all", or "cwd"
```

| Value | Description |
|-------|-------------|
| `"none"` | Disable suggestions |
| `"all"` | Show suggestions from all history (default) |
| `"cwd"` | Show suggestions only from current directory history |

For backward compatibility, boolean values are also accepted:
- `true` → `"all"`
- `false` → `"none"`

### CWD Mode

The `"cwd"` mode filters suggestions to show only history entries that were recorded in the current working directory. If no matches are found, it falls back to all history.

> [!NOTE]
> The `"cwd"` setting only affects R mode suggestions. Shell mode (`#!` prefix) always searches all history regardless of this setting.

## Shell Mode Completion

In shell mode, tab completion uses `ShellCompleter`.

### Configuration

```toml
[experimental.shell_completion]
command_names = false  # Suggest executable names from PATH at command position
```

`command_names` is disabled by default. When enabled, executable names from `PATH` are suggested only when the cursor is at command position (for example, the first token in a command segment).

### Behavior

- Meta commands (starting with `:`) are delegated to `MetaCommandCompleter`
- File and directory paths are completed at any token position
- Command segments are split by separators like `|` and `;`
- Paths containing spaces are wrapped in double quotes

### Known Limitations

- Quote-aware tokenization is not implemented. Pressing Tab again inside an already-quoted path may produce incorrect span positions.
- Quoting is optimized for common paths and does not fully escape all shell metacharacters. Paths containing uncommon characters (for example `$`, backticks, or embedded quotes) may require manual editing before execution.

## Keyboard Shortcuts

arf supports configurable keyboard shortcuts using the [crokey](https://github.com/Canop/crokey) format.

### Default Shortcuts

| Shortcut | Inserts | Config Key |
|----------|---------|------------|
| `Alt+-` | ` <- ` | `"alt-hyphen"` |
| `Alt+P` | ` \|> ` | `"alt-p"` |

> [!NOTE]
> arf uses `Alt+P` instead of the RStudio-style `Ctrl+Shift+M` because `Ctrl+Shift+M` conflicts with VS Code and Zed's diagnostics panels when running in their integrated terminals. See [Customizing for RStudio compatibility](#customizing-for-rstudio-compatibility) below.

### Key Format

Keys are specified in crokey format:

- Modifiers: `ctrl`, `alt`, `shift`
- Special keys: `hyphen`, `space`, `tab`, `enter`, `backspace`, `delete`, etc.
- Regular keys: `a`-`z`, `0`-`9`, punctuation

### Examples

```toml
[editor.key_map]
# Assignment operator: Alt+- → " <- "
"alt-hyphen" = " <- "

# Native pipe: Alt+P → " |> " (default)
"alt-p" = " |> "

# Magrittr pipe: Alt+M → " %>% "
"alt-m" = " %>% "

# Equality check: Alt+= → " == "
"alt-=" = " == "

# Right arrow: Ctrl+. → " -> "
"ctrl-." = " -> "
```

### Customizing for RStudio Compatibility

If you prefer RStudio-style shortcuts and are using a standalone terminal (not VS Code or Zed integrated terminal), you can use `Ctrl+Shift+M` for the pipe operator:

```toml
[editor.key_map]
"alt-hyphen" = " <- "
"ctrl-shift-m" = " |> "
```

> [!WARNING]
> `Ctrl+Shift+M` opens the Problems/Diagnostics panel in VS Code and Zed, so this shortcut won't reach arf when running in their integrated terminals.

### Disabling Default Shortcuts

To disable all shortcuts, set an empty table:

```toml
[editor.key_map]
```

## Color Configuration

arf supports configurable syntax highlighting colors for R code and meta commands.

### Available Colors

**Named Colors** (case-sensitive):
- Basic: `Black`, `Red`, `Green`, `Yellow`, `Blue`, `Purple`, `Magenta`, `Cyan`, `White`
- Light: `LightRed`, `LightGreen`, `LightYellow`, `LightBlue`, `LightPurple`, `LightMagenta`, `LightCyan`, `LightGray`
- Dark: `DarkGray`
- Special: `Default` (terminal default color)

**256-Color Palette**:
```toml
keyword = { Fixed = 99 }    # Color index 0-255
```

**True Color (RGB)**:
```toml
string = { Rgb = [0, 255, 128] }    # RGB values 0-255
```

### Token Types

| Token | Description | Default |
|-------|-------------|---------|
| `comment` | Lines starting with # | DarkGray |
| `string` | String literals | Green |
| `number` | Numeric literals | LightMagenta |
| `keyword` | if, else, for, while, function, etc. | LightBlue |
| `constant` | TRUE, FALSE, NULL, NA, Inf, NaN | LightCyan |
| `operator` | +, -, <-, \|>, etc. | Yellow |
| `punctuation` | Brackets, commas, semicolons | Default |
| `identifier` | Variable and function names | Default |
| `matching_bracket` | Background color for matching bracket highlight | LightYellow |

### Prompt Colors

| Setting | Description | Default |
|---------|-------------|---------|
| `main` | Main R prompt color | LightGreen |
| `continuation` | Continuation prompt color | LightGreen |
| `shell` | Shell mode prompt color | LightRed |
| `indicator` | Mode indicator text color ([reprex], [format], #!) | Yellow |
| `status.success` | Color for success (symbol and/or prompt when override_prompt_color is true) | LightGreen |
| `status.error` | Color for error (symbol and/or prompt when override_prompt_color is true) | LightRed |
| `duration` | Color for command duration indicator | Yellow |
| `vi.insert` | Color for vi insert mode indicator | Default |
| `vi.normal` | Color for vi normal mode indicator | Default |
| `vi.non_vi` | Color for non-vi modes (Emacs, etc.) | Default |

## Prompt Placeholders

The `prompt.format`, `prompt.continuation`, and `prompt.shell_format` fields support placeholder expansion:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{version}` | R version number | `4.4.0` |
| `{cwd}` | Current working directory (full path) | `/home/user/project` |
| `{cwd_short}` | Current working directory (basename only) | `project` |
| `{shell}` | Shell name from $SHELL (Unix) or "cmd" (Windows) | `bash`, `zsh`, `cmd` |
| `{status}` | Command status indicator (see below) | `✗ ` on error |
| `{duration}` | Command execution time (see [Command Duration](#command-duration-indicator)) | `5s `, `1m30s ` |

### Prompt Examples

```toml
[prompt]
# Show R version in prompt with status indicator (default)
format = "{status}R {version}> "
# Result: "R 4.4.0> " on success, "✗ R 4.4.0> " on error

# Show short directory name
format = "[{cwd_short}] r> "
# Result: "[project] r> "

# Add a blank line before the prompt
# (double-quoted strings interpret \n as a newline)
format = "\n{status}R {version}> "

# Custom shell mode prompt
shell_format = "{shell}:{cwd_short}$ "
# Result: "bash:project$ "
```

## Command Status Indicator

arf can show a visual indicator when the previous command failed. This is similar to fish shell's default behavior.

### Configuration

The `prompt.status.symbol` table configures which symbols are shown via the `{status}` placeholder:

```toml
[prompt]
format = "{status}R {version}> "

[prompt.status]
symbol = { error = "✗ " }      # Show "✗ " on error, nothing on success
override_prompt_color = false  # Also change entire prompt color

[colors.prompt.status]
success = "LightGreen"   # Color for success (symbol and/or prompt)
error = "LightRed"       # Color for error (symbol and/or prompt)
```

### Examples

```toml
# Default: show colored symbol on error only
[prompt.status]
symbol = { error = "✗ " }

# Show checkmark on success, X on error
[prompt.status]
symbol = { success = "✓ ", error = "✗ " }

# No status symbols (disable)
[prompt.status]
symbol = {}

# Change entire prompt color on error (no symbol)
[prompt.status]
override_prompt_color = true

# Symbol + prompt color change
[prompt.status]
symbol = { error = "✗ " }
override_prompt_color = true
```

## Command Duration Indicator

arf can show how long the previous command took to execute via the `{duration}` prompt placeholder. This is an experimental feature.

The time format follows starship's convention: `5s`, `1m30s`, `2h48m30s` (no spaces between units, leading zero units skipped). For sub-second durations, milliseconds are shown (e.g., `800ms`).

> [!NOTE]
> `{duration}` is not included in the default prompt format. To use it, add `{duration}` to your `prompt.format` setting.

### Configuration

```toml
[prompt]
format = "{duration}{status}R {version}> "

[experimental.prompt_duration]
format = "{value} "   # How to display the duration ({value} = time string)
threshold_ms = 2000   # Only show for commands that take longer than 2s (default)

[colors.prompt]
duration = "Yellow"   # Color for duration text (default)
```

### How It Works

- The `format` string uses `{value}` as a sub-placeholder for the time string (e.g., "5s"). If `{value}` is omitted, only the static text in the format string is shown
- When the previous command exceeded `threshold_ms`, `{value}` in the format string is replaced with the time string, and the result replaces `{duration}` in the prompt
- When the command was fast (below threshold) or no command has been run yet, `{duration}` expands to an empty string
- The entire format string is conditional — static text in the format (like "took ") only appears when the duration is shown
- This means you can safely place `{duration}` in your prompt — it will only appear when relevant

### Examples

```toml
# Simple (default format): "5s R 4.4.0> " after slow command
[prompt]
format = "{duration}{status}R {version}> "

# starship-like: "took 5s R 4.4.0> "
[prompt]
format = "{duration}{status}R {version}> "
[experimental.prompt_duration]
format = "took {value} "

# Bracketed: "(5s) R 4.4.0> "
[prompt]
format = "{duration}{status}R {version}> "
[experimental.prompt_duration]
format = "({value}) "

# Lower threshold to 500ms (sub-second shows milliseconds like "800ms")
[experimental.prompt_duration]
threshold_ms = 500

# Custom color
[colors.prompt]
duration = "DarkGray"
```

## Vi Mode Indicator

arf can show a visual indicator for the current vi editing mode. This is useful when using vi keybindings to know whether you're in insert or normal mode.

The vi mode indicator is displayed at the end of the prompt (after the main prompt text), following the same approach as nushell.

### Default Behavior

By default, vi mode shows `[I]` and `[N]` indicators with colors:
- Insert mode: `[I] ` (LightGreen) → prompt appears as `R 4.4.0> [I] `
- Normal mode: `[N] ` (LightYellow) → prompt appears as `R 4.4.0> [N] `

Non-vi modes (Emacs) show no indicator by default.

### Symbol Configuration

| Field | Description | Default |
|-------|-------------|---------|
| `insert` | Symbol shown in vi insert mode | `"[I] "` |
| `normal` | Symbol shown in vi normal mode | `"[N] "` |
| `non_vi` | Symbol shown in non-vi modes (Emacs) | `""` (empty) |

### Color Configuration

| Field | Description | Default |
|-------|-------------|---------|
| `insert` | Color for vi insert mode indicator | LightGreen |
| `normal` | Color for vi normal mode indicator | LightYellow |
| `non_vi` | Color for non-vi modes (Emacs) | Default |

### Examples

```toml
# Nushell-style: mode-aware prompt suffix
[prompt]
format = "R {version} "   # No trailing ">" - the vi indicator provides it
[prompt.vi]
symbol = { insert = "> ", normal = ": ", non_vi = "> " }

# Unicode indicators
[prompt.vi]
symbol = { insert = "● ", normal = "○ " }

# Custom colors
[colors.prompt.vi]
insert = "Green"
normal = "Yellow"

# Disable vi mode indicator (set symbols to empty strings)
[prompt.vi]
symbol = { insert = "", normal = "" }
```

> [!NOTE]
> To disable the vi mode indicator entirely, set the symbols to empty strings as shown above.

## Reprex Modes and Formatting

arf supports three reprex modes: `off`, `on`, and `format`. The `format` mode
formats R code before reprex evaluation using the configured formatter backend.
The default `formatter = "auto"` selector prefers Air and then Arity when both
are available. Explicit `air` and `arity` selections are strict and never
fall back to the other backend.
The supported backends are [Air](https://github.com/posit-dev/air) 0.9.0 or later
and [Arity](https://github.com/jolars/arity) 0.18.0 or later. Air receives code
over stdin with the virtual path `arf-reprex.R` and `--force`, preserving project
configuration discovery from the current working directory and avoiding
temporary files. Arity receives code over stdin with `arity format -` and also
uses the current working directory for configuration discovery. If formatting
fails, arf reports the backend's stderr and does not evaluate the unformatted
code.

### Configuration

```toml
[startup]
reprex = "format"  # "off", "on", or "format"
```

### CLI Option

```bash
# Enable reprex mode with formatting
arf --reprex=format
```

### Runtime Selection

Select the mode during a session using the explicit meta command:

```
:reprex on
:reprex off
:reprex format  # Requires the configured formatter (auto prefers Air, then Arity)
```

## R Source Configuration

arf supports multiple ways to locate the R installation.

### Configuration

```toml
[startup]
# Option 1: Auto-detect (default)
# Uses rig if available, otherwise finds R from PATH
r_source = "auto"

# Option 2: Explicitly use rig
# Requires rig to be installed
r_source = "rig"

# Option 3: Explicit path to R_HOME
r_source = { path = "/opt/R/4.5.2" }
```

### Version Specifications

arf uses the same installed-version matching for `--with-r-version`, `:switch`, and R source overrides. `--with-r-version` and `:switch` additionally accept rig's own selectors, which are tried first — see [rig Integration](#rig-integration). An R version is a plain `major.minor.patch` number: R does not publish prereleases or build metadata, and rig reports installed R versions in that form. For installed-version matching, arf accepts two forms:

- Exact or partial version numbers: `4`, `4.4`, or `4.4.2`. The number of components written determines the precision: `4.4` matches the `4.4.x` series, while `4.4.2` matches only `4.4.2`.
- Ranges using comparison operators such as `^4.4`, `~4.4`, `>=4.3`, `<5.0`, and `*`. Operators can be combined, for example `>=4.3, <5.0`.

The range operators use the syntax popularised by Cargo and npm. This is only range notation for selecting R versions; R version numbers are not SemVer. Because an R version has only three components, numeric specifications with four or more components, such as `4.4.1.0`, cannot match and are rejected. Likewise, prerelease identifiers and build metadata are rejected because installed R versions never carry them. If multiple installed versions match, arf selects the newest one.

### CLI Options

The `--r-home` flag specifies an explicit R_HOME path:

```bash
arf --r-home /opt/R/4.5.2
```

The `--with-r-version` flag temporarily overrides `r_source` and uses rig. It accepts one of the version specifications above or a selector from rig's own metadata:

```bash
arf --with-r-version 4.5
```

These options are mutually exclusive.

To ask arf which R installation it would use without starting R, run `arf r resolve`. It accepts the same `--r-home`, `--with-r-version`, `--no-r-source-overrides`, and `--config` options as the startup path; see [`arf r resolve`](r-resolve.md) for the machine-facing JSON interface.

### rig Integration

When using rig via `r_source = "auto"` with rig installed or `r_source = "rig"`, arf uses rig's default version. The `--with-r-version` flag accepts an explicit specification: `--with-r-version default` selects rig's default, while another specification selects the matching installed version. You can change the default with:

```bash
rig default 4.5
```

Rig selectors are separate from version specifications:

| Selector | Description |
|--------------|-------------|
| `default` | Use rig's default R version |
| Rig alias (e.g. `release` or `devel`) | Use the version associated with that rig alias |
| Rig-assigned name (e.g. `custom-name`) | Use the installed version with that rig name |

`--with-r-version` and `:switch` try these selectors before interpreting the value as a version specification, in the order listed above. R source overrides never consult them and always interpret the value as a version specification. This matters when a rig alias or name looks like a version number: if an installation is named `4.4`, then `--with-r-version 4.4` selects that installation by name, while `4.4` in an override file selects the newest installed `4.4.x` release, which may be a different installation.

### Switching and Restarting

`:switch <version>` and `:restart` both restart arf, but they differ in how they treat the environment:

- `:switch <version>` uses arf's original pre-initialization startup snapshot. It restores the startup values of `R_LIBS_USER`, `R_LIBS_SITE`, `R_LIBS`, `R_DOC_DIR`, `R_SHARE_DIR`, `R_INCLUDE_DIR`, and `R_SYSTEM_ABI`, if they were present when arf first started; if one was absent, arf removes it before restarting so the new R can compute it. The snapshot remains available across restarts. `R_HOME` is always removed because arf sets it from the resolved R version, so an inherited value is not meaningful. `LD_LIBRARY_PATH` is also always removed to preserve current behavior, even when it had a user-set value at startup; restoring that value is a future improvement. These rules prevent values introduced by R or the session from leaking into the new version while preserving the other startup values. If any variables are affected, arf prints their names but never their values, for example:

  ```text
  # [arf] Environment variables for the R version switch: restored: R_LIBS_USER; removed: R_HOME, LD_LIBRARY_PATH
  ```

  For values that should persist across R version switches, prefer `~/.Renviron` over shell environment variables. R reads that file afresh for each version, so its `${VAR-'default'}` handling can calculate paths for the selected installation instead of carrying one exact shell value across versions.

- `:restart` relaunches the same version without touching environment variables, so user-set values and anything set during the session with `Sys.setenv()` carry over.

## History Configuration

### Configuration

```toml
[history]
menu_max_height = 15   # Maximum height of Ctrl+R menu
mode = "persistent"   # "persistent" loads/saves SQLite; "volatile" is session-only
# For a custom persistent directory, use instead:
# mode = { dir = "/custom/path" }
```

### Environment Variable

The `ARF_HISTORY_DIR` environment variable can be used to override the history directory. This is useful for devcontainer Features that persist history via Docker volumes.

```bash
export ARF_HISTORY_DIR=/dc/arf-history
```

### Priority Order

The history directory is resolved with the following priority (highest first):

1. CLI `--history-dir`
2. `ARF_HISTORY_DIR` environment variable
3. TOML `[history] mode = { dir = "..." }`
4. XDG default

### CLI Options

```bash
arf --no-history              # Use volatile session-only history (no disk load/save)
arf --history-dir /path/to   # Custom history directory
```

History files are stored as SQLite databases:
- R history: `{dir}/r.db`
- Shell history: `{dir}/shell.db`

Default location (XDG data directory):
- **Linux**: `~/.local/share/arf/history/`
- **macOS**: `~/Library/Application Support/arf/history/`
- **Windows**: `C:\Users\<user>\AppData\Local\arf\history\`

### Exporting and Importing History

You can export your history to a backup file:

```bash
arf history export --file backup.db
```

To restore or transfer history to another machine:

```bash
arf history import --from arf --file backup.db
```

You can also import history from other sources:

```bash
# Import from radian
arf history import --from radian

# Import from standard R history file
arf history import --from r
```

> [!NOTE]
> Re-importing the same file is safe — duplicate entries are automatically skipped by matching command text and timestamp.

## Experimental Features

Features in this section are under development and may change or be removed in future versions.

### Spinner

Displays an animated spinner at the start of the line while R is evaluating code. **Disabled by default** — set `frames` to enable.

```toml
[experimental.prompt_spinner]
frames = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"  # Braille dots
color = "Cyan"
```

**Configuration options:**

| Option | Default | Description |
|--------|---------|-------------|
| `frames` | `""` (disabled) | Animation frames (each character is one frame). |
| `color` | `"Cyan"` | Spinner color. Accepts standard ANSI color names: `Black`, `Red`, `Green`, `Yellow`, `Blue`, `Magenta`, `Cyan`, `White`, and their `Light` variants (e.g., `LightBlue`). |

**Frame style examples:**

```toml
# Braille dots (recommended)
frames = "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"

# ASCII spinner (works in all terminals)
frames = "|/-\\"

# Block spinner
frames = "▖▘▝▗"
```

### Fuzzy R Completion

Use fuzzy matching for R code completions. When enabled, typing `sf::geo` can match `sf::st_geometry` and `library(dpl` can match `dplyr`. **Disabled by default.**

```toml
[experimental.r_completion]
fuzzy = true
```

Both `::` (exported names) and `:::` (internal names) are supported. Package exports are cached per-package with a 5-minute TTL for performance.

The `package_functions` option controls which function calls trigger package-name fuzzy completion (defaults to `["library", "require"]`). Add custom functions as needed:

```toml
[experimental.r_completion]
fuzzy = true
package_functions = ["library", "require", "box::use"]
```

#### Static formal completion

When enabled, arf can inspect installed package metadata and stored code to
complete formal argument names in qualified calls such as `stats::lm(` without
asking R to evaluate the completion request. The static path is conservative:
unsupported, ambiguous, or unavailable metadata always falls back to R's
completion oracle. It is disabled by default while this experimental feature is
being evaluated.

```toml
[experimental.r_completion.static.formals]
mode = "prefer-static"

[experimental.r_completion.static.formals.exclusions]
packages = ["S7", "methods"]
functions = ["rlang::abort"]
```

`mode = "off"` retains the existing R-only behavior. `mode = "prefer-static"`
uses static formals only for a clear static hit and otherwise falls back to R.
Exclusions are case-sensitive exact matches; function entries use the public
`pkg::function` spelling and package entries take precedence. These exclusions
apply only to static formal completion.

If you used an earlier development build, rename
`[experimental.r_completion.static_formals]` to
`[experimental.r_completion.static.formals]` and move its `.exclusions` table
to the same new hierarchy. The old key is not an alias and no longer enables
static formal completion. The configuration file is still named `arf.toml`.

### History Forget

Automatically removes commands that produced errors from history. Similar to fish's [sponge](https://github.com/meaningful-ooo/sponge) plugin.

> [!NOTE]
> History forget only applies to commands typed interactively by the user in the REPL. It does not apply to headless mode or commands sent via IPC, because agent-sent commands are valuable as an execution log and should not be silently pruned just because they failed.

```toml
[experimental.history_forget]
enabled = true
delay = 2          # Keep last N failed commands for quick retry
on_exit_only = false  # Purge on each prompt (false) or only on exit (true)
```

**Configuration options:**

| Option | Default | Description |
|--------|---------|-------------|
| `enabled` | `false` | Enable automatic removal of failed commands. |
| `delay` | `2` | Number of recent failed commands to keep accessible for retry. Older failed commands are purged. |
| `on_exit_only` | `false` | If `true`, only purge when session ends. If `false`, purge on each prompt. |

### Shell Semicolon Shortcut

Pressing `;` at an empty R prompt instantly switches to shell mode — no `:shell` or Enter required. Similar to [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/#man-shell-mode) shell mode behavior. **Disabled by default.**

```toml
[experimental]
shell_semicolon_shortcut = true
```

When the buffer is not empty, `;` inserts a semicolon as usual, so normal R expressions like `for (i in 1:10) { ... }` are unaffected.

### Shell Abbreviations

Fish-style abbreviations for the shell editor. When you type an abbreviation and press Space or Enter, it is automatically expanded to the full text. Only applies to shell mode — the R editor is unaffected.

**Disabled by default** (empty map).

```toml
[experimental.shell_abbreviations]
"gc" = "git commit"
"gp" = "git push"
"gs" = "git status"
```

Abbreviations are matched against the word immediately to the left of the cursor at the moment you press Space or Enter. The expansion replaces the abbreviation in place.

### R Source Overrides

Automatically select an installed R version from project tooling. This feature is fully opt-in: `r_source_overrides` defaults to an empty array. If it is unset or empty, arf falls back entirely to `startup.r_source`, exactly as before.

> [!IMPORTANT]
> A version read from a file is only ever matched against the R installations that rig knows about — arf takes the candidate list from `rig list --json`. **The `version-file`, `toml-key`, and `json-key` providers therefore require rig**, and can only select an R version that rig has already installed. Without rig, or when no installed version matches, arf warns and falls back to `startup.r_source` rather than failing to start.

Override files are resolved as `<current directory>/<file>`. `file` must be a bare filename: it cannot be empty, `.`, `..`, contain subdirectories, or be an absolute path. arf does **not** walk up parent directories, even though the tools that write these files often do.

arf uses the `file` value as written and performs no case folding, so whether `.r-version` also matches a file named `.R-version` depends on the filesystem: case-insensitive on typical macOS and Windows setups, case-sensitive on typical Linux ones. Write the exact spelling your project uses to keep the config portable across platforms.

Entries are evaluated in array order, which is the priority order. The first entry that successfully resolves a version is used; later entries are not evaluated once one succeeds.

**Configuration options:**

| Option | Default | Description |
|--------|---------|-------------|
| `r_source_overrides` | `[]` (disabled) | Ordered list of R source providers. |
| `type = "version-file"` | — | Reads the first non-empty line as the version specification from the `file` field. |
| `type = "toml-key"` | — | Reads a string version specification from the dot-separated TOML key in the `file` and `key` fields. |
| `type = "json-key"` | — | Reads a string version specification from the dot-separated JSON key in the `file` and `key` fields. |
| `type = "pixi"` | — | Uses the active pixi environment. This provider is not implemented yet and has no additional fields. |

For example, [rv](https://a2-ai.github.io/rv-docs/) stores its R version in `rproject.toml`. This configuration reads the `project.r_version` string and tries to select the matching installed R version:

```toml
[experimental]
r_source_overrides = [
  { type = "toml-key", file = "rproject.toml", key = "project.r_version" },
]
```

The other provider forms are:

```toml
{ type = "version-file", file = ".r-version" }
{ type = "pixi" }
```

**File formats read by each provider:**

`version-file` reads the first non-empty line and trims its leading/trailing whitespace; the trimmed result is used as the version specification. Values longer than 256 bytes are rejected. The format follows the version-file convention popularised by other ecosystems' version managers — `.python-version`, `.ruby-version` and similar files — a single version on its own line, e.g. a `.r-version` containing:

```
4.4.1
```

Comments are not supported. The first non-empty line may be any supported form, including a range such as `>=4.3, <5.0`; later lines are ignored. Only spaces are accepted inside a specification, so a range must stay on one line.

`toml-key` parses `file` as TOML and follows `key` as a dot-separated path through its tables. For example, rv's `rproject.toml` might contain:

```toml
[project]
name = "my-analysis"
r_version = "4.4"
```

With `key = "project.r_version"`, arf looks up the `project` table and reads its `r_version` field. The value must be a TOML string; any other type is treated as an error.

`json-key` parses `file` as JSON and follows `key` as a dot-separated path through its objects. For example, an `renv.lock` file contains the recorded R version near its top level:

```json
{
  "R": {
    "Version": "4.4.1",
    "Repositories": []
  }
}
```

With `key = "R.Version"`, arf reads the string under `R.Version`. The value must be a JSON string; arrays, array indexes, and escaped literal dots are not supported. This provider is fully opt-in; arf does not detect `renv.lock` automatically. A recorded `R.Version` is the version captured at the time of the snapshot, so updating the lockfile can change which R arf selects. Use this configuration only when that behavior is desired (and, when appropriate, use `renv::settings$r.version("4.4.1")` to intentionally control the recorded value):

```toml
[experimental]
r_source_overrides = [
  { type = "json-key", file = "renv.lock", key = "R.Version" },
]
```

**Version strings read by `version-file`, `toml-key`, and `json-key` use the version specifications above.** These providers accept exact or partial numbers and ranges, and select the newest installed version that matches. `devel` and `release` are recognised names, but named selectors are not supported by the R source override path.

**Who performs the matching:** arf runs rig only to check that it is there (`rig --version`) and to list what is installed (`rig list --json`). It then matches the specification against that list itself and asks the selected installation's R binary for its `R_HOME`. rig never sees the specification, so it is arf that decides what `4.4` means.

`--with-r-version`, `:switch` and `r_source_overrides` share the numeric and range matching described above. Only selectors from rig's own metadata differ: `default`, aliases such as `release`, and exact rig names work with `--with-r-version` and `:switch`, while named selectors are unsupported in an override file.

When resolving providers, a missing file is silently skipped and arf moves to the next entry. If a file exists but its value cannot be parsed, arf logs a warning and moves to the next entry. `pixi` logs the following warning and also moves to the next entry:

> Warning: R source override provider 'pixi' is not implemented; trying the next R source override.

When a provider's requested version is not installed, arf prints installation guidance and tries the next provider. Only after all providers fail does it fall back to `startup.r_source`; startup continues rather than aborting. Rig being unavailable is different: arf cannot evaluate the overrides, so it falls back immediately without trying further providers. Numeric version selectors use `rig add`, while version ranges use non-command guidance because a range is not an executable `rig add` argument. The warnings are:

```text
Warning: rig is not installed, so the R source override cannot be resolved.
         Install rig from https://github.com/r-lib/rig or use "auto".
         Falling back to startup.r_source.

Warning: R source override provider 'version-file' at .r-version requested R version "4.4", which is not installed.
         Install it with rig add 4.4, then restart arf.
         Trying the next R source override.

Warning: R source override provider 'version-file' at .r-version has no installed R version matching specification ">=4.3, <5.0".
         Install a matching R version with rig, then restart arf.
         Trying the next R source override.

Warning: All R source overrides failed.
         Falling back to startup.r_source.
```

Use `--no-r-source-overrides` to disable evaluation of `r_source_overrides`. It is an override-disable switch, not an R source tier, and it does not disable explicit `--r-home`, `--with-r-version`, `ARF_R_HOME`, or `ARF_R_VERSION` selection.

## R Source Precedence

The first three tiers are explicit CLI and environment selections. Tiers 4 and 5 are settings in the single `arf.toml` configuration file that arf loaded, either from `--config` or from the XDG global config path: `r_source_overrides` is the ordered provider list, and `startup.r_source` is its configuration-level fallback. The providers may consult project-local files such as `rproject.toml` and `.r-version`; those files are not separate arf configuration files. Tiers 6 and 7 are a separate discovery layer: they describe how arf searches for R only after the selected configuration resolves to PATH mode.

For `headless` and `r resolve`, `--r-home` and `--with-r-version` are resolved as one mutually exclusive R-source pair, and the flags belong to the subcommand: write `arf headless --r-home /opt/R` or `arf r resolve --r-home /opt/R`, not `arf --r-home /opt/R headless` or `arf --r-home /opt/R r resolve`. Placing them before the subcommand is an error that names the corrected form; placing `--r-home` between `r` and `resolve` is an unexpected argument. `ARF_R_HOME` and `ARF_R_VERSION` need no placement — the subcommands read them directly.

| Tier | Source | Evaluation behavior |
|------|--------|---------------------|
| 1 | CLI `--r-home` | Returns immediately with the explicit path; no lower tier is evaluated. |
| 2 | CLI `--with-r-version` | Returns immediately with the rig-selected version; no lower tier is evaluated. |
| 3 | `ARF_R_HOME` / `ARF_R_VERSION` | Clap converts these into the corresponding CLI values, so they have the same early-return behavior as tiers 1–2. A command-line value wins over its env var. The interactive console, `headless` and `r resolve` each read these variables for themselves. |
| 4 | `r_source_overrides` (setting in the loaded `arf.toml`) | Evaluates providers in order. A provider's project-local file may be absent or fail to resolve; those cases fall through to the next provider and then to tier 5. |
| 5 | `startup.r_source` (setting in the loaded `arf.toml`) | Resolves the configured source after the override providers have been exhausted; when it resolves here, source selection ends. |
| 6 | Inherited `R_HOME` | Not a selection tier. It is a discovery-layer input consulted only when tier 5 resolves to PATH mode. |
| 7 | `R RHOME` / built-in default paths | Final fallback search used to discover R when PATH-mode resolution needs it. |

Specifying `--r-home` or `--with-r-version` (or `ARF_R_HOME` or `ARF_R_VERSION`) skips the `r_source_overrides` detection step entirely: an existing `rproject.toml` is not read and no warning is emitted. Inherited `R_HOME` likewise matters only as a discovery-layer input when `startup.r_source` falls into PATH mode.

> [!WARNING]
> With the default `startup.r_source = "auto"`, arf uses rig's default R directly when rig is available and its default can be resolved; otherwise it falls back to the R found on PATH. This does not guarantee that arf and an editor use the same installation: for example, a conda-provided R can appear before rig's shim on PATH, so the editor may discover it while arf uses rig's default.
>
> `r_source_overrides` and `ARF_R_HOME` / `ARF_R_VERSION` select R independently of PATH, so arf's R can silently diverge from the editor's. That breaks integrations assuming a shared installation, because installed packages and library paths are resolved against the editor's R.
>
> In an IDE-integrated workflow, prefer having the editor ask [`arf r resolve`](r-resolve.md) which R arf would use. Otherwise, consider leaving both disabled; if you enable them, keep the selection in sync with the editor, or have the editor launch arf with `--r-home` pointing at its own R.

## Other CLI Options

Command-line options take precedence over their corresponding config file settings:

| CLI Option | Config Setting |
|------------|----------------|
| `--no-banner` | `startup.show_banner` |
| `--reprex=<off\|on\|format>` | `startup.reprex` |
| `--no-history` | `history.mode = "volatile"` |
| `--history-dir` / `ARF_HISTORY_DIR` | `history.mode = { dir = "..." }` |

Example:
```bash
# Enable reprex mode with formatting
arf --reprex=format
```
````

## File: docs/editors.md
````markdown
# Editor Integration

arf can be used as the R terminal in code editors that support custom terminal programs.

## VS Code (vscode-R)

The [vscode-R](https://github.com/REditorSupport/vscode-R) extension provides R language support in VS Code, including the ability to send code from the editor to an R terminal. To use arf as the R terminal, configure the following settings.

### Settings

Set `r.rterm` to `"arf"` for your platform, and enable `r.bracketedPaste`:

```json
{
    "r.rterm.linux": "arf",
    "r.bracketedPaste": true
}
```

The platform-specific `r.rterm` settings are `r.rterm.linux`, `r.rterm.mac`, and `r.rterm.windows`.

> [!NOTE]
> If `"arf"` doesn't work, you may need to specify the full path. Use `which arf` (Linux/macOS) or `where.exe arf` (Windows) to find the executable path, then use that path instead (e.g., `"${userHome}/.cargo/bin/arf"`).

Without `r.bracketedPaste`, vscode-R sends code line-by-line to the terminal. This can cause issues with arf's auto-match feature (automatic bracket/quote completion), because each line is processed as individual keystrokes. With bracketed paste enabled, code is sent as a single unit, avoiding interference from auto-match.

> [!NOTE]
> This is the same recommendation as for radian. The `r.bracketedPaste` setting is disabled by default in vscode-R because the standard R terminal does not support it.

> [!WARNING]
> On Windows, vscode-R forcibly disables bracketed paste regardless of the `r.bracketedPaste` setting ([vscode-R#1590](https://github.com/REditorSupport/vscode-R/issues/1590)). Until [vscode-R#1631](https://github.com/REditorSupport/vscode-R/pull/1631) is merged, code sent from the editor will be received as individual key events, which may cause issues with auto-match.

## Zed (zed-r)

The [zed-r](https://github.com/ocsmit/zed-r) extension provides R language support in Zed. You can use arf as the R terminal by configuring a task.

### Setting Up an R Terminal Task

Add the following to your `tasks.json`:

```json
[
    {
        "label": "R Terminal (arf)",
        "command": "arf",
        "cwd": "$ZED_WORKTREE_ROOT",
        "use_new_terminal": true
    }
]
```

You can bind this task to a keyboard shortcut in your `keymap.json`:

```json
{
    "context": "Workspace",
    "bindings": {
        "ctrl-2": [
            "task::Spawn",
            { "task_name": "R Terminal (arf)", "reveal_target": "dock" }
        ]
    }
}
```

## Migrating from radian

If you are currently using radian with vscode-R, the migration to arf is straightforward:

1. Change `r.rterm` from the radian path to the arf path.
2. Keep `r.bracketedPaste` set to `true` (same as radian).
3. No other vscode-R settings need to change.

For Zed users, replace `"radian"` with `"arf"` in your task's `command` field.

Note that arf uses its own configuration file (`arf.toml`) instead of `.radian_profile`. See the [Configuration](configuration.md) documentation for details on configuring arf.

### Importing History

You can import your radian command history into arf:

```sh
# Preview what would be imported (dry run)
arf history import --from radian --dry-run

# Import from radian (default: ~/.radian_history)
arf history import --from radian
```

> [!NOTE]
> Re-importing the same file is safe — duplicate entries are automatically skipped by matching command text and timestamp.
````

## File: docs/ipc.md
````markdown
# IPC & Headless Mode

arf includes a built-in IPC (Inter-Process Communication) server that allows external tools to interact with a running R session. This enables AI agents, CI pipelines, and editor extensions to evaluate R code, query session state, and control the session programmatically.

> [!WARNING]
> IPC is an experimental feature. The protocol and CLI interface may change in future versions.

## Overview

The IPC system has two parts:

1. **Server** — Runs inside arf, listening on a Unix socket (Linux/macOS) or named pipe (Windows)
2. **Client** — The `arf ipc` subcommands that connect to a running server

The server can be enabled in three ways:

| Method | Use case |
|--------|----------|
| `arf headless` | CI, AI agents, background R sessions (no terminal needed) |
| `arf --with-ipc` | Interactive REPL with external tool access |
| `:ipc start` meta command | Enable IPC in an already-running session |

## Headless Mode

Headless mode starts R with an IPC server but without the interactive REPL. This is ideal for environments where no terminal is available.

```sh
arf headless
```

The server runs until interrupted by `Ctrl+C`, `SIGTERM`, or `arf ipc shutdown`. Immediately after startup there is a brief window where the IPC endpoint is listening but R is not yet ready, so early client requests may return `R_BUSY`. For scripted or automated use, prefer `arf headless --json` and treat the JSON emitted on stdout as the readiness signal, or retry the first `arf ipc` command with a small backoff until it succeeds.

### Options

| Option | Description |
|--------|-------------|
| `--json` | Print session info as JSON to stdout when ready (implies `--quiet`) |
| `--ipc-bind <PATH>` | Custom socket path (Unix) or named pipe path (Windows) |
| `--ipc-pid-file <PATH>` | Write PID to file (removed on shutdown) |
| `--log-file <PATH>` | Redirect log output to file instead of stderr |
| `--history-dir <PATH>` | Override history database directory |
| `--no-history` | Keep command history in memory for this session only (no disk load/save) |
| `--quiet` | Suppress status messages on stderr |
| `--config <PATH>` | Path to configuration file |
| `--with-r-version <VER>` | R version to use via rig |
| `--r-home <PATH>` | Explicit R_HOME path |
| `--no-r-source-overrides` | Disable directory-level R source overrides |
| `--vanilla` | Start R without init files |

### PID file lifecycle (interactive and headless)

The PID file is the current-process pointer for an integration slot; it is not
a readiness marker. Readiness is established by the IPC session metadata (or
the `--json` output). Interactive `:restart` and `:switch` are a
short transition: clients should use bounded retries, re-read the PID and
session metadata, and detect the new generation by a changed `started_at`
value. On Unix the replacement keeps ownership of a matching PID file. On
Windows the parent relinquishes the file before spawning the replacement, so
the file is briefly absent and then publishes a new PID. On Windows only, the
default endpoint also changes because it contains the child PID; each retry
must resolve it again. On Unix the default endpoint path remains the same
across an exec restart, although it is temporarily unavailable during the
restart window. In both cases, `started_at` changes for the new generation.
An explicitly configured `--ipc-bind` path is reused by the replacement on
both platforms. For an interactive session, a relative custom path is resolved
once against arf's initial working directory, before R startup profiles can
change it. Headless sessions follow the same pointer/readiness contract until
shutdown.

### JSON Output (`--json`)

When `--json` is specified, arf prints session connection info to stdout as a single JSON object once the server is ready:

```json
{
  "pid": 12345,
  "socket_path": "/run/user/1000/arf/12345.sock",
  "r_version": "4.4.2",
  "r_home": "/opt/R/4.4.2/lib/R",
  "cwd": "/workspace",
  "started_at": "2026-03-22T10:00:00+09:00",
  "log_file": null,
  "history_session_id": 1742601600000000000,
  "ipc_policy": {
    "silent": {
      "mode": "restricted",
      "allowed_functions": ["+", "mean"]
    },
    "visible": {
      "mode": "approval_not_required"
    }
  },
  "history_runtime": {
    "state": "persistent",
    "path": "/home/user/.local/share/arf/history/r.db",
    "reason": null,
    "detail": null
  },
  "r_source_override": {
    "state": "applied",
    "provider": "toml-key",
    "file": "rproject.toml",
    "key": "project.r_version",
    "requested_version": "4.4",
    "resolved_version": "4.4.2"
  },
  "warnings": []
}
```

All keys are always present. `r_version`, `r_home`, and `log_file` may be `null`; `history_session_id` is `null` only when history initialization is unavailable. `ipc_policy` is always present in this readiness output: `silent` is either restricted with its complete sorted `allowed_functions` list (an empty restricted list still permits bare literals and identifiers) or unrestricted with no allowlist field. Because this is headless readiness output, `visible` has mode `approval_not_required` for both `send` and `eval --visible`. `history_runtime` reports `persistent`, configured `volatile`, fallback `volatile`, or `unavailable`; its `path` is a diagnostic path when one was requested (for example, for a persistent or fallback open, or an unavailable initialization), and `detail` contains an optional human-readable failure diagnostic. `r_home` is the R installation the session is using, or `null` when the session has no R. The `r_source_override` object is always present; its state is one of `applied`, `not_configured`, `no_match`, `failed`, `disabled`, or `shadowed_by_cli`, and its other fields are `null` unless an override was applied. `warnings` captures non-fatal startup issues (e.g., config parse errors or history fallback diagnostics) that would otherwise only appear on stderr.

The IPC `r_version` is measured from a live R session; `arf r resolve` reports `resolved_version`, a prediction made before R starts.

Output is pretty-printed when stdout is a terminal, compact when piped. This is useful in CI scripts:

```sh
arf headless --json | jq -r .socket_path
```

### R Configuration in Headless Mode

Headless mode automatically configures R for non-interactive use:

- **Pager**: Redirected to stdout (no interactive `less`)
- **Help**: Forced to plain text (`options(help_type = "text")`)
- **Browser**: Disabled (URLs are printed instead of opening a browser)
- **Graphics**: Defaults to file-based devices (png/pdf) instead of X11
- **Save/Restore**: Always `--no-save --no-restore-data`

## IPC Subcommands

All `arf ipc` subcommands connect to a running arf session. If only one session is active, it is used automatically. When multiple sessions are running, use `--pid` to target a specific one.

### Output Format

All IPC action subcommands (`list`, `eval`, `send`, `session`, `shutdown`, `history`) output JSON to stdout. Output is pretty-printed when stdout is a terminal, compact when piped. Errors are written to stderr as structured JSON:

```json
{
  "error": {
    "code": "R_BUSY",
    "message": "R is busy",
    "hint": "R is executing code. Wait for it to finish, or use 'arf ipc session' to check status.",
    "data": null
  }
}
```

All four fields (`code`, `message`, `hint`, `data`) are always present. `hint` is `null` when no hint is available. `data` contains additional structured information (e.g. `{"buffer": "..."}` for `USER_IS_TYPING`) or `null`.

The `code` field is a string identifier for stable matching. Process exit codes indicate the error category:

| Exit code | Meaning |
|-----------|---------|
| 0 | Success |
| 2 | IPC transport error (socket/pipe connection failed, connection-level read timeout) |
| 3 | Session resolution error (no session found, ambiguous PID) |
| 4 | JSON-RPC protocol error (R busy, user typing, server-side request timeout from `--timeout`, etc.) |

> **Note:** Transport-level timeouts (failing to connect to the socket or low-level read/write timeouts) produce exit code **2** (`TRANSPORT_ERROR`). Server-side evaluation timeouts triggered by `arf ipc eval --timeout` result in a JSON-RPC error response from the server, which the client reports as exit code **4**.

Error code strings:

| Code | Exit | Description |
|------|------|-------------|
| `TRANSPORT_ERROR` | 2 | Socket/pipe connection failed, connection-level read timeout, etc. |
| `SESSION_NOT_FOUND` | 3 | No session with the specified PID, or no sessions at all |
| `SESSION_AMBIGUOUS` | 3 | Multiple sessions running and `--pid` not specified |
| `R_BUSY` | 4 | R is executing code |
| `R_NOT_AT_PROMPT` | 4 | R is in browser/menu mode |
| `INPUT_ALREADY_PENDING` | 4 | Another IPC request is already queued |
| `USER_IS_TYPING` | 4 | User is typing in the REPL (see `data` fields below) |
| `INCOMPLETE_INPUT` | 4 | R code is syntactically incomplete and would enter the continuation prompt |
| `R_EVAL_NOT_ALLOWED` | 4 | Evaluation was rejected by the server-side syntactic policy |
| `INPUT_NOT_APPROVED` | 4 | Interactive `send` was not approved at the REPL prompt |
| `EMPTY_RESPONSE` | 4 | Server returned no result |
| `PARSE_ERROR` | 4 | Invalid JSON in request |
| `INVALID_REQUEST` | 4 | Not a valid JSON-RPC request |
| `METHOD_NOT_FOUND` | 4 | Unknown method name |
| `INVALID_PARAMS` | 4 | Invalid method parameters |
| `INTERNAL_ERROR` | 4 | Server internal error |
| `PROTOCOL_ERROR` | 4 | Other JSON-RPC error |

#### `USER_IS_TYPING` error data

When the user is typing in the REPL, the `data` field contains:

| Field | Type | Description |
|-------|------|-------------|
| `buffer` | string | Current editor buffer content (capped at 1024 characters) |
| `buffer_truncated` | boolean | `true` if the buffer was truncated |
| `buffer_original_length` | integer | Full character count of the original buffer |

### `arf ipc eval` — Evaluate R Code

What decides the policy is whether a human can see the operation, not whether
the session is headless or interactive. Silent eval leaves no trace a person
watching the session would notice, so it is protected by an exact allowlist.
`send` and `eval --visible` do surface in the session, so they are protected by
human approval instead: an interactive session shows a confirmation prompt, and
a headless session has no human to ask, so both headless `send` and headless
`eval --visible` run immediately and are unrestricted.

History follows a related but separate rule: every IPC operation is recorded
except silent eval in an interactive session, which is the one path that runs
without leaving anything behind for the person at the prompt.

Plain (silent) IPC evaluation uses a best-effort tree-sitter-r policy in both
interactive and headless sessions. The default allowlist is empty. Configure
exact direct call targets at startup, for example
`--ipc-eval-allow-function mean` or `--ipc-eval-allow-function stats::median`;
nested calls must also be allowlisted. Bare literals and object references
(bare identifiers) evaluate without any configuration. Extraction operators
(`$`, `[`, and `[[`) remain allowlist-gated; enable them with repeated
`--ipc-eval-allow-function` flags, as in this debugger-style inspection setup:

```sh
arf headless \
  --ipc-eval-allow-function '$' \
  --ipc-eval-allow-function '[' \
  --ipc-eval-allow-function '[[' &
```

Other R operators use their exact spelling (such as `+`) in the same list.
Assignments, control flow, computed callees, the native pipe `|>`, and `:::`
are always rejected in restricted mode. Syntax errors and policy violations
are rejected before R evaluation and history recording.
`--ipc-eval-unrestricted` is a startup-only escape hatch. This policy is not an
R sandbox and does not promise that an allowed function is non-mutating. Evaluating
a bare identifier can itself run code by forcing a promise or triggering an active
binding; this is allowed by default because IPC eval never permits assignment, so a
caller cannot create such a binding through IPC eval.

The same policy is advertised as the `ipc_policy` object in the headless
`--json` readiness output and live `arf ipc session` responses. The interactive
`:info` pager reports whether the IPC server is enabled.
When enabled, it shows the silent-eval mode, lists each configured target on
its own line so the complete allowlist can be checked without horizontal
scrolling, and states the current approval requirement for visible requests
(`send`/`eval --visible`). When disabled, it omits the policy details.

Evaluates R code and returns the captured output. The code runs silently by
default — output is not shown in the session. With `--visible`, an interactive
session uses the same human approval as `send`; a headless session runs it
immediately like `send`. The response fields differ between these two visible
paths: headless visible evaluation still goes through the capture wrapper and
populates `value` and `error`, while interactive visible evaluation runs
through normal REPL evaluation and returns `null` for both fields. In the
interactive case, printed values and errors are in `stdout` and `stderr`.

```sh
# Basic evaluation
arf headless \
  --ipc-eval-allow-function length \
  --ipc-eval-allow-function Sys.sleep \
  --ipc-eval-allow-function getwd &
arf ipc eval 'length("abc")'

# With timeout (milliseconds; Sys.sleep must be allowlisted at server startup)
arf ipc eval --timeout 10000 'Sys.sleep(5)'

# Also show output in the session (REPL or headless stdout).
# This runs where the session shows it, so it needs no allowlist entry.
arf ipc eval --visible 'cat("hello\n")'

# Target a specific session
arf ipc eval --pid 12345 'getwd()'
```

**Parameters:**

| Parameter | Description |
|-----------|-------------|
| `<CODE>` | R code to evaluate (required) |
| `--visible` | Also show output in the session. In an interactive session, this is governed by the same human approval as `send`, not the eval allowlist, and `value`/`error` are always `null` in the response. In headless mode, it runs immediately like `send` and still populates `value`/`error`. |
| `--timeout <MS>` | Timeout in milliseconds for waiting for the response (default: 300000 = 5 minutes). This does NOT cancel the R evaluation — long-running code keeps R busy after timeout. |
| `--pid <PID>` | Target session PID |

**Output format:** JSON object with `stdout` (string), `stderr` (string), `value` (string or null), and `error` (string or null). All four fields are always present, but `value` and `error` are not populated for an interactive session's visible evaluation: normal REPL output and errors appear in `stdout` and `stderr` instead. Silent evaluation (the default) and visible evaluation in a headless session use the capture wrapper, so the printed result appears in `value` and R evaluation errors appear in `error`, with exit code 0 — they are normal responses, not IPC failures.

When the timeout fires, the server returns a JSON-RPC error response instead of a result, and the client prints that error as structured JSON on stderr and exits with code 4 — the timeout is therefore not reported in the result object's `error` field. The R evaluation continues, so the session stays busy until it finishes.

Example (silent eval, result captured in `value`):

```json
{
  "stdout": "",
  "stderr": "",
  "value": "[1] 2",
  "error": null
}
```

Example (R error):

```json
{
  "stdout": "",
  "stderr": "",
  "value": null,
  "error": "object 'x' not found"
}
```

### `arf ipc send` — Send User Input

Sends code as if the user typed it at the prompt. Output goes to the session's output streams (REPL terminal or headless stdout/log file) and is **not** captured in the IPC response.

`send` is a visible, history-recorded operation. In an interactive REPL it is
shown for human approval; in headless mode it runs immediately because there is
no human to ask. It is not governed by the silent-eval allowlist.

In an interactive REPL, `send` displays the complete escaped code that will be
executed after approval. Control and other non-printing characters are escaped
so they cannot alter or spoof the terminal display. The approval block is
shown as three separate lines and requires an explicit `y` or `Y` key for each
request by default:

```text
# [arf] IPC send request:
  <escaped code>
# [arf] Press y to approve, any other key declines:
```

The heading and `# [arf]` prefix are dark cyan, the escaped code is yellow,
and the confirmation text is bold yellow. The three-line structure carries the
meaning independently of color. Long code is not shortened; it remains
available in the terminal scrollback, so the displayed escaped code corresponds
to the complete code being approved.

Any other key, including Enter, `n`, Ctrl+C, Ctrl+D, or Esc, rejects the
request. Non-key terminal events are ignored while waiting. A read error or a
request whose client timeout has elapsed also rejects the request. This is
controlled for the current process only with `:ipc
send-policy allow` and restored with `:ipc send-policy prompt`; it cannot be
changed by configuration or startup CLI options. Headless `send` remains
immediate.

```sh
# Send code that appears in the session output
arf ipc send 'library(dplyr)'

# Target a specific session
arf ipc send --pid 12345 'print(mtcars)'
```

**Output format:** JSON object with `accepted` (bool). Example: `{"accepted": true}`

**When to use `eval` vs `send`:**

| | `eval` | `send` |
|---|---|---|
| Output captured in response | Yes | No |
| Shown in session | Only with `--visible` | Always |
| User-configurable timeout (`--timeout` / `timeout_ms`) | Yes | No |
| Use case | Programmatic access | Human-visible interaction |

### `arf ipc session` — Get Session Info

Returns structured session information as JSON, including arf version, R environment details, and runtime state.

```sh
# Pretty-printed on terminal, compact when piped
arf ipc session

# Extract R version with jq
arf ipc session | jq -r '.r.version'

# Check loaded namespaces
arf ipc session | jq '.r.loaded_namespaces'
```

The response always has the same shape. When R is busy, the `r` field is `null` and `r_unavailable_reason` explains why:

```json
{
  "arf_version": "0.2.6",
  "pid": 12345,
  "os": "linux",
  "arch": "x86_64",
  "r_home": "/opt/R/4.4.2/lib/R",
  "socket_path": "/run/user/1000/arf/12345.sock",
  "started_at": "2026-03-22T10:00:00+09:00",
  "log_file": null,
  "ipc_policy": {
    "silent": {
      "mode": "restricted",
      "allowed_functions": []
    },
    "visible": {
      "mode": "approval_not_required"
    }
  },
  "r": null,
  "r_unavailable_reason": "R is busy evaluating another expression",
  "hint": null
}
```

All top-level keys are always present. `ipc_policy` is the complete policy object described in
the evaluation section; it is present even when R is busy. `r_home` is the R installation the
session is using, or `null` when the session has no R. The `r` object contains information collected by evaluating R
and may be `null` while R is busy or unavailable. `arch` is the architecture of the arf process,
not the R installation.

The example above shows a headless session, so `visible` has mode
`approval_not_required`; it covers both `send` and `eval --visible`. For an
interactive session, this live policy reflects the current `:ipc send-policy`
state: `allow` reports `approval_not_required`, while `prompt` reports
`approval_required`.

When R is idle, the `r` field contains session details (other top-level fields omitted for brevity):

```json
{
  "r": {
    "version": "4.4.1",
    "platform": "x86_64-pc-linux-gnu",
    "locale": "en_US.UTF-8",
    "cwd": "/workspace",
    "loaded_namespaces": ["base", "stats", "utils"],
    "attached_packages": ["base", "datasets"],
    "lib_paths": ["/usr/lib/R/library"]
  },
  "r_unavailable_reason": null,
  "hint": null
}
```

### `arf ipc list` — List Active Sessions

Returns all running arf sessions with IPC enabled as JSON.

```sh
arf ipc list

# Example output:
# {
#   "sessions": [
#     {
#       "pid": 12345,
#       "r_version": "4.4.1",
#       "r_home": "/opt/R/4.4.1/lib/R",
#       "socket_path": "/run/user/1000/arf/12345.sock",
#       "cwd": "/workspace",
#       "started_at": "2026-03-22T10:00:00+09:00",
#       "session_type": "headless",
#       "log_file": null,
#       "history_session_id": 1742601600000000000
#     }
#   ]
# }
```

When no sessions are running, returns `{"sessions": []}` (exit 0).

The `session_type` field is `"headless"` for sessions started with
`arf headless` and `"interactive"` for sessions running an interactive REPL.
The field is always present in current session metadata.

The `r_home` field is the R installation the session is using. A `null` value
means either that the session has no R, or that it was created by an older arf
that did not record the path: a session file written before this field existed
is listed with `r_home` set to `null`, like any other unset field. Clients must
treat `null` as unknown and must not assume an R installation is available.

`r_version`, `r_home`, `log_file`, and `history_session_id` may be `null`. The
list is discovery metadata only; it does not include the effective IPC policy.
Query `arf ipc session` to obtain the live policy at the time of the request.

### `arf ipc history` — Query Command History

Returns command history entries from the session's SQLite history database as JSON. By default, only entries from the current session are returned. This method is handled on the server thread and does not touch R, so it works even when R is busy.

```sh
# Show recent history from this session (default 50 entries)
arf ipc history

# Show last 10 entries
arf ipc history --limit 10

# Include history from all sessions (not just current)
arf ipc history --all-sessions

# Search for commands containing 'dplyr'
arf ipc history --grep dplyr

# Filter by working directory
arf ipc history --cwd /path/to/project

# Show entries since a date
arf ipc history --since 2026-03-29

# Combine filters
arf ipc history --grep 'library' --limit 20

# Extract commands with jq
arf ipc history | jq -r '.entries[].command'
```

**Parameters:**

| Parameter | Description |
|-----------|-------------|
| `--limit <N>` | Maximum number of entries to return (default: 50, must be positive) |
| `--all-sessions` | Include entries from all sessions, not just the current one |
| `--cwd <PATH>` | Filter entries by exact working directory |
| `--grep <PATTERN>` | Filter entries whose command contains this substring |
| `--since <DATE>` | Only return entries after this timestamp (RFC 3339 or `YYYY-MM-DD`) |
| `--pid <PID>` | Target session PID |

**Output format:** JSON object with `entries` array (newest first) and `session_id`. Each entry contains `command`, `timestamp`, `cwd`, `exit_status`, and `session_id` (all fields are always present; null when not available). Output is pretty-printed when stdout is a terminal, compact when piped.

> [!NOTE]
> Only completed commands are recorded in the history database. A command that is currently executing will not appear in the results until it finishes.

### `arf ipc shutdown` — Shut Down Headless Session

Sends a graceful shutdown request to a headless session. The session cleans up (removes socket, PID file, session file) before exiting.

```sh
arf ipc shutdown
arf ipc shutdown --pid 12345
```

**Output format:** JSON object with `accepted` (bool). Example: `{"accepted": true}`

## IPC in Interactive REPL

You can enable IPC in the interactive REPL without headless mode:

### Using the `--with-ipc` Flag

```sh
arf --with-ipc
```

This starts the REPL normally and also starts the IPC server. External tools can then interact with your session while you continue working interactively.

### Using Meta Commands

Within a running session, you can start and stop the IPC server:

```
:ipc start    # Start the IPC server
:ipc stop     # Stop the IPC server
:ipc status   # Show server status
```

### Interactive + IPC: Mutual Exclusion

When both a human and an external tool use the same session, arf prevents conflicts:

- If you are typing when an IPC `eval` or `send` request arrives, the request is rejected with a `USER_IS_TYPING` error
- If an IPC `eval` or `send` request contains syntactically incomplete R code, it is rejected with an `INCOMPLETE_INPUT` error
- If R is busy (not at the prompt), `evaluate` requests are rejected immediately with `R_BUSY`
- If R is not at the prompt, `user_input` / `send` requests are rejected with `R_NOT_AT_PROMPT`
- Clients are expected to handle these errors by retrying later (for example, with backoff). In interactive/REPL mode, the server accepts at most one pending request — additional requests are rejected with `INPUT_ALREADY_PENDING`. In headless mode, requests are queued and processed sequentially
- The `session` and `history` methods do not touch R and can be called even when R is busy or not at the prompt. `session` always succeeds; `history` may fail only when no history owner is available or the store cannot be queried
- `list` reads local session files and does not connect to any server, so it always works regardless of R state

## Transport & Security

### Unix (Linux/macOS)

The IPC server listens on a Unix domain socket. The default path depends on the platform:

- When `$XDG_RUNTIME_DIR` is set: `$XDG_RUNTIME_DIR/arf/<PID>.sock` (typically `/run/user/<UID>/arf/<PID>.sock` on Linux with systemd)
- When `$XDG_RUNTIME_DIR` is not set (e.g. macOS): `<temp_dir>/arf-<random>/<PID>.sock` (where `<temp_dir>` is the system temp directory, e.g. `$TMPDIR`; on Linux this is typically `/tmp`)

The socket directory and file are created with restrictive permissions:
- Socket directory: mode `0700` (owner only)
- Socket file (`<PID>.sock`): mode `0600` (owner only)

Before using the socket directory, arf validates that it is not a symlink, is owned by the current user, and is not writable by group or other users. If validation fails, arf attempts to use a per-process fallback directory instead. If all candidate directories are unsafe or cannot be created, IPC does not start and arf returns an error rather than continuing without IPC.

Session metadata JSON files (`<PID>.json`) are stored separately in the OS cache directory (e.g., `~/.cache/arf/sessions/` on Linux):
- Directory: mode `0700` (owner only)
- File: mode `0600` (owner only)

This prevents other users on the system from discovering or connecting to your session.

### Windows

The IPC server listens on a named pipe:

```
\\.\pipe\arf-ipc-<PID>
```

> [!NOTE]
> Although Windows 10 1803+ supports AF_UNIX sockets, arf currently uses named pipes on Windows because the async runtime (tokio) does not yet support AF_UNIX on Windows. See [tokio#2201](https://github.com/tokio-rs/tokio/issues/2201) for upstream progress.

### Custom Bind Path

Use `--ipc-bind` to specify a custom socket/pipe path. This works for both
headless and interactive REPL (`--with-ipc`) modes:

```sh
# Headless — Unix
arf headless --ipc-bind /tmp/my-arf.sock

# Headless — Windows
arf headless --ipc-bind \\.\pipe\my-arf

# Interactive REPL — Unix (editor launches arf and knows the socket path upfront)
arf --with-ipc --ipc-bind /tmp/my-arf.sock
```

> [!NOTE]
> On Unix, the socket file is created with `bind()` and then restricted to `0600`. There is a brief window between these two calls where the default umask applies. If you use a custom path, ensure the parent directory is user-private (e.g., mode `0700`) to prevent other users from connecting during that window.

### Session Discovery

Each arf session with IPC enabled writes a session file to the OS cache directory (e.g., `~/.cache/arf/sessions/<PID>.json` on Linux, `~/Library/Caches/arf/sessions/<PID>.json` on macOS). The session file contains discovery metadata such as the socket path so that `arf ipc` client commands can discover running sessions; it does not store the effective IPC policy. Query `arf ipc session` for the live policy at request time. Stale session files (where the process is no longer running) are automatically cleaned up.

### Remote Access (No Built-in TCP)

arf intentionally does not listen on TCP. Supporting TCP would require building authentication and encryption into arf itself, which is better handled by dedicated tools. Instead, use an existing proxy or tunnel to expose the local socket remotely:

- **SSH tunneling** (OpenSSH 6.7+ supports Unix socket forwarding) — recommended for most cases, as it provides encryption and authentication with no extra software
- **socat** — lightweight bidirectional relay between Unix sockets and TCP, useful for quick bridging on trusted networks
- **Reverse proxies** (Caddy, nginx) — suitable for persistent setups, especially when TLS is required

On Windows, arf listens on a named pipe which these tools cannot target directly. In WSL environments, [npiperelay](https://github.com/albertony/npiperelay) can bridge a Windows named pipe to stdin/stdout, allowing it to be combined with socat or SSH.

## JSON-RPC Protocol

For tool developers who want to communicate with arf directly (without the `arf ipc` CLI), the server speaks JSON-RPC 2.0 over HTTP on the Unix socket or named pipe.

The server also accepts raw JSON request bodies (without HTTP request-line/headers) for simpler clients. Responses are still sent as standard `HTTP/1.1 200 OK` messages with headers followed by a JSON body, so raw-JSON clients need to strip the HTTP headers before parsing the response.

### Request Format

Send an HTTP POST request with a JSON-RPC body:

```http
POST / HTTP/1.1
Host: localhost
Content-Type: application/json
Content-Length: ...
Connection: close

{"jsonrpc": "2.0", "id": 1, "method": "evaluate", "params": {"code": "1 + 1"}}
```

### Available Methods

| Method | Parameters | Description |
|--------|-----------|-------------|
| `evaluate` | `code` (string), `visible` (bool, default false), `timeout_ms` (int, optional) | Evaluate R code and return captured output |
| `user_input` | `code` (string) | Send code as user input |
| `session` | *(none)* | Get session information |
| `history` | `limit` (int, default 50), `all_sessions` (bool, default false), `cwd` (string, optional), `grep` (string, optional), `since` (string, optional) | Query command history |
| `shutdown` | *(none)* | Shut down the session (headless mode only; returns an error in interactive mode) |

### Response Examples

**Successful evaluation:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "stdout": "",
    "stderr": "",
    "value": "[1] 2"
  }
}
```

**R error:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "stdout": "",
    "stderr": "",
    "error": "object 'x' not found"
  }
}
```

Errors are caught by `tryCatch`, so the error message appears in the `error` field (via `conditionMessage()`). The `stderr` field is typically empty for caught errors.

**R is busy:**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32000,
    "message": "R is busy"
  }
}
```

### Output Capture

The `evaluate` method captures R output through two separate channels:

- **`stdout` / `stderr` (console output)**: Captured via R's `WriteConsoleEx` callback at the C level. This includes text produced by `cat()`, `message()`, `warning()`, and other writes to the R console.
- **`value` / `error` (structured result)**: Captured separately as the evaluated result (or error) of the last expression, using a binary protocol (`charToRaw()` + `writeBin()` to a temp file, then read from Rust). In silent `evaluate` calls, printed values of expressions appear here rather than in `stdout`/`stderr`.

The result fields in the JSON response are already properly escaped strings — tool developers do not need to handle the raw binary protocol themselves.

### Error Codes

| Code | Name | Description |
|------|------|-------------|
| -32700 | Parse Error | Invalid JSON |
| -32600 | Invalid Request | Not a valid JSON-RPC request |
| -32601 | Method Not Found | Unknown method name |
| -32602 | Invalid Params | Invalid method parameters |
| -32603 | Internal Error | Server internal error |
| -32000 | R Busy | R is executing code |
| -32001 | R Not At Prompt | R has not returned to the prompt |
| -32002 | Input Already Pending | Another IPC request is already queued |
| -32003 | User Is Typing | User is typing in the REPL (interactive mode only) |
| -32004 | Incomplete Input | R code is syntactically incomplete |

## Troubleshooting

### "No active arf sessions found"

The `arf ipc` client could not find a session file in the cache directory. This means:

- No arf session has IPC enabled, or
- The session file could not be created (for example, the cache directory is missing or not writable), or
- The session file was cleaned up (the process exited)

**Fix:** Start arf with `arf headless` or `arf --with-ipc`.

### "R is busy"

In interactive/REPL mode, the request is rejected immediately with `R_BUSY` — it is not queued. In headless mode, requests are queued and processed sequentially; clients will typically block until the current operation finishes or their own timeout elapses.

**Fix:** For interactive mode, handle `R_BUSY` responses by retrying the request with backoff. In headless mode, configure appropriate client-side timeouts. Note that `--timeout` only limits how long the IPC call waits for a reply — it does not cancel the underlying R evaluation, and long-running code may keep R busy even after the client times out.

### "User is typing" (interactive mode)

In interactive REPL mode, IPC requests are rejected when the user has text in the editor buffer.

**Fix:** Clear the input line or press Enter before sending the IPC request. This protection prevents IPC from disrupting the user's typing.

### Connection refused / timeout

The socket exists but the server is not responding.

**Possible causes:**
- The arf process crashed but the socket file was not cleaned up
- R is stuck in an infinite loop or blocking operation

**Fix:** Check if the process is still running with `arf ipc list`. If the session is stale, remove the socket file shown in the `socket_path` field (for example, `$XDG_RUNTIME_DIR/arf/<PID>.sock` or `<temp_dir>/arf-<random>/<PID>.sock` on Unix) and the session metadata file (`~/.cache/arf/sessions/<PID>.json`).

### Permission denied on socket

On Unix, the socket directory and files are created with restrictive permissions (mode `0700`/`0600`). If you see permission errors:

- Ensure you are connecting as the same user who started arf
- Check that the socket directory (`$XDG_RUNTIME_DIR/arf/` or `<temp_dir>/arf-<random>/`) has the correct ownership
````

## File: docs/r-resolve.md
````markdown
# `arf r resolve`

`arf r resolve` is a machine-facing API for editor extensions and other external tools that need to know which R installation arf would use before starting R.

> [!WARNING]
> `arf r resolve` is experimental. The command name, JSON descriptor, and exit codes may change in future versions.

## Overview

An editor extension and arf must agree on which R installation to use. `arf r resolve` lets the editor ask arf rather than reimplementing arf's R source selection logic. The selection rules themselves are documented in [R Source Overrides](configuration.md#r-source-overrides) and [R Source Precedence](configuration.md#r-source-precedence); this page documents the interface.

To ask arf which R installation it would use without starting R, run:

```bash
arf r resolve
```

`arf r resolve` accepts the same `--r-home`, `--with-r-version`, `--no-r-source-overrides`, and `--config` options as the startup path. On success it always emits JSON; there is no `--json` flag. Output is pretty-printed when stdout is a terminal and compact when piped, so consumers do not need a format flag. For example:

```json
{
  "schema_version": 1,
  "resolved": true,
  "cwd": "/project",
  "target": {
    "r_home": "/opt/R/4.5.2/lib/R",
    "r_binary": "/opt/R/4.5.2/lib/R/bin/R",
    "resolved_version": "4.5.2"
  },
  "resolver": { "name": "arf", "version": "0.4.5" },
  "selected_by": {
    "kind": "version_request",
    "requested_r_home": null,
    "requested_version": "4.5",
    "source": {
      "kind": "project_file",
      "name": null,
      "path": "/project/rproject.toml",
      "format": "toml",
      "key": "project.r_version"
    }
  },
  "provider": "rig",
  "diagnostics": []
}
```

## JSON Descriptor

Every key is always present. A value is `null` when it does not apply, so consumers can rely on the key set being stable. `resolved` is `false`, and `target` and `provider` are `null`, exactly when no R installation could be found. That is not an error: the command still exits 0, because normal arf startup also continues in that state with R evaluation unavailable.

`resolver` names the tool that produced the descriptor, so resolution could later move behind a separate tool without breaking readers. `provider` identifies the mechanism that located the installation and is `null` when nothing was located; current values are `rig`, `path`, and `explicit_path`. `resolved_version` is deliberately not called `r_version`: it is a prediction made before R starts, unlike the versions reported from a running session by the IPC layer. See [IPC session information](ipc.md#arf-ipc-session--get-session-info) for those runtime values.

### `selected_by` and `source`

`selected_by` separates what was matched from where that condition came from. Its `kind` values are:

| Value | Meaning |
|-------|---------|
| `r_home` | An explicit R_HOME path was selected. |
| `version_request` | A requested R version was selected, from the command line, environment, or a project file. |
| `default` | No explicit request selected the R source; configuration or the built-in default was used. |

The `source.kind` values identify the origin of that condition:

| Value | Meaning |
|-------|---------|
| `command_line_argument` | `--r-home` or `--with-r-version`. |
| `environment_variable` | `ARF_R_HOME` or `ARF_R_VERSION`. |
| `project_file` | A project file, with its path, format, and optional key. |
| `configuration_file` | The loaded `arf.toml`, with its path, format, and key. |
| `built_in_default` | arf's built-in default when no configuration file setting applies. |

Both enum sets may grow, so clients must accept unknown values. The source fields carry the specific name (`--r-home`, `ARF_R_VERSION`, or a file path plus key) so a caller can point the user at the exact thing to change. The nullable `requested_r_home`, `requested_version`, `name`, `path`, `format`, and `key` fields remain present in every descriptor.

## Diagnostics

`diagnostics` is a list of `{code, severity, message, path}` objects. Codes are an open enum: clients must not reject unknown codes, and the set may grow. `message` is for display only and must not be used for machine classification. The codes currently produced are:

| Code | Meaning |
|------|---------|
| `config.read_failed` | The configuration file could not be read. |
| `config.parse_failed` | The configuration file could not be parsed. |
| `r_discovery.failed` | No R could be discovered from PATH or the default installation paths. This accompanies `resolved: false`. |
| `r_source_override.provider_unsupported` | An R source override provider is unsupported. |
| `r_source_override.value_invalid` | An R source override value is invalid. |
| `r_source_override.fallback` | R source overrides fell back to the configured startup source. |
| `r_source_override.resolution_failed` | An R source override could not be resolved. |
| `r_source_override.rig_unavailable` | rig was unavailable while evaluating an override. |
| `r_source_override.version_not_installed` | A requested override version is not installed. |

## Resolution Behavior

Resolution mirrors normal startup rather than being stricter. A configuration file that fails to load still falls back to defaults and exits 0 with a diagnostic, and a version request that a project file merely suggests does the same when it cannot be satisfied. A version requested explicitly on the command line or through `ARF_R_HOME` / `ARF_R_VERSION` is an error when it cannot be satisfied, because startup refuses to continue in that case too. Requests that resolve successfully behave the same way whatever their source. Reporting a different R than arf would actually use would defeat the purpose of the command.

## Exit Codes

Exit codes match `arf ipc`: `0` means success, including `resolved: false`; `2` means invalid invocation; and `4` means internal failure.

Errors raised after the arguments parse successfully are JSON on stderr, in the same shape used by `arf ipc`. Argument-parsing failures — an unknown flag, a missing value, or `--r-home` combined with `--with-r-version` — are reported by the argument parser as plain text and also exit `2`, so a client that needs to distinguish them must tolerate a non-JSON stderr at that exit code.
````
