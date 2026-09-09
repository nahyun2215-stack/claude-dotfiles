# claude-dotfiles

Portable Claude Code (and Codex) **skills**, synced across machines via git.

The `skills/` folder is the source of truth. An install script symlinks each
skill folder into `~/.claude/skills/` so every machine that clones this repo
gets the same set.

```
skills/
  find-skills/   # vercel-labs/skills  — discover & install other skills
  grill-me/      # mattpocock/skills   — relentless interview to sharpen a plan
```

## Set up on a new machine

```bash
git clone <your-repo-url> ~/claude-dotfiles
cd ~/claude-dotfiles

# Linux / macOS
./install.sh

# Windows (PowerShell)
./install.ps1
```

Restart Claude Code (or open a new session) and the skills are available.

### Prerequisites

- **Linux/macOS:** nothing extra — `ln` is built in.
- **Windows:** none. `install.ps1` uses directory *junctions*, which need
  neither admin rights nor Developer Mode. (Node.js + git are only needed if
  you want to run `npx skills …` to add or update skills.)

## Add a skill

Install it with the Skills CLI, then copy the folder in and commit:

```bash
npx skills add <owner/repo> --skill <name> --global
cp -r ~/.agents/skills/<name> skills/<name>
git add skills/<name> && git commit -m "add <name> skill"
```

(On Windows the global store is `~/.agents/skills/<name>` too.)

## Update a skill

```bash
npx skills update -g <name>
cp -r ~/.agents/skills/<name> skills/<name>
git add -A && git commit -m "update <name> skill"
```

Then `git pull && ./install.sh` (or `install.ps1`) on your other machines.

## Remove a skill

```bash
git rm -r skills/<name>
rm -rf ~/.claude/skills/<name>          # ~/.claude/skills/<name> on the link target
git commit -m "remove <name> skill"
```

## Notes

- The install scripts are idempotent — re-run them after every `git pull`.
- `~/.claude/skills/<name>` becomes a link pointing back into this repo, so
  editing a file here changes the live skill immediately (restart the session
  to reload).
- Windows junctions show up as `<JUNCTION>` in `dir`; remove with
  `Remove-Item <path> -Recurse -Force` (this does *not* delete the target).
