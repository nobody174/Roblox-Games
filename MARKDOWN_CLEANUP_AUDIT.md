# Markdown Cleanup Audit Report

## Classification Summary

| File Path | Category | Justification |
|-----------|----------|----------------|
| **ROOT LEVEL** | | |
| README.md | **KEEP** | Primary project documentation; essential for repo visitors |
| START_HERE.md | **ARCHIVE** | Development notes for onboarding; useful during dev but not maintenance |
| IDEAS.md | **ARCHIVE** | Feature brainstorming; useful reference but not critical documentation |
| INDEX.md | **ARCHIVE** | Index/TOC generated during planning; superseded by README |
| MASTER_PROMPT.md | **KEEP** | Used for starting new chat sessions; essential reference document |
| PROJECT_SUMMARY.md | **ARCHIVE** | Status snapshot from development phase; historical/archival value only |
| CONTRIBUTING.md | **KEEP** | Contributor guidelines; essential for collaboration |
| **DOCS FOLDER** | | |
| docs/SETUP.md | **KEEP** | Installation/setup guide; critical for new developers |
| docs/FEATURES.md | **KEEP** | Feature documentation; user-facing and maintainable |
| docs/GAMEPLAY.md | **KEEP** | Gameplay mechanics reference; important for game understanding |
| docs/SYSTEMS.md | **KEEP** | Architecture documentation; critical for maintainers |
| docs/GAMES.md | **KEEP** | Multi-game reference; useful for navigating multiple projects |
| docs/CONTRIBUTING.md | **DELETE** | Duplicate of root CONTRIBUTING.md (consolidate to one location) |
| **GHOST CATCHER ROOT** | | |
| games/ghost-catcher-tycoon/README.md | **KEEP** | Game-specific documentation |
| games/ghost-catcher-tycoon/CONTRIBUTING.md | **DELETE** | Duplicate of root; remove if not game-specific |
| games/ghost-catcher-tycoon/START_HERE.md | **ARCHIVE** | Development guide for this game; move to docs/archive/ |
| games/ghost-catcher-tycoon/INDEX.md | **ARCHIVE** | Planning index; archival value for reference |
| games/ghost-catcher-tycoon/QUICK_REFERENCE.md | **ARCHIVE** | Quick-start for development; useful historical reference |
| games/ghost-catcher-tycoon/CODE_LOCATIONS.md | **ARCHIVE** | Code navigation notes from development; archival reference |
| games/ghost-catcher-tycoon/SYSTEM_COMPONENTS_CHECKLIST.md | **ARCHIVE** | Development checklist; useful historical record |
| games/ghost-catcher-tycoon/MASTER_PROMPT.md | **ARCHIVE** | Game-specific Claude prompt; can be archived as reference |
| games/ghost-catcher-tycoon/PROJECT_SUMMARY.md | **ARCHIVE** | Phase summary; historical development milestone |
| games/ghost-catcher-tycoon/COMPLETION_STATUS.md | **ARCHIVE** | Development status from earlier phase; superseded by STATUS.md |
| games/ghost-catcher-tycoon/ANSWER_TO_QUESTION.md | **ARCHIVE** | Q&A from development; archival reference only |
| games/ghost-catcher-tycoon/INTEGRATION_SUMMARY.md | **ARCHIVE** | Integration notes from development phase; archival |
| games/ghost-catcher-tycoon/EGGSYSTEM_WIRED.md | **ARCHIVE** | System verification notes; historical reference |
| games/ghost-catcher-tycoon/ROBLOX_STUDIO_IMPORT.md | **ARCHIVE** | Studio setup notes; useful for reference but not active maintenance |
| games/ghost-catcher-tycoon/PRE_REOPEN_VERIFICATION.md | **ARCHIVE** | Pre-reopening checklist; one-time use development artifact |
| games/ghost-catcher-tycoon/RESTART_AND_TEST.md | **ARCHIVE** | Testing instructions from development; archival |
| games/ghost-catcher-tycoon/TEST_GUIDE.md | **KEEP** | Comprehensive testing guide; important for QA and maintenance |
| games/ghost-catcher-tycoon/DOCUMENTATION_INDEX.md | **ARCHIVE** | Planning index; superseded by actual docs structure |
| **GHOST CATCHER DOCS** | | |
| games/ghost-catcher-tycoon/docs/SETUP.md | **KEEP** | Game-specific setup guide |
| games/ghost-catcher-tycoon/docs/FEATURES.md | **KEEP** | Game features documentation |
| games/ghost-catcher-tycoon/docs/GAMEPLAY.md | **KEEP** | Gameplay mechanics reference |
| games/ghost-catcher-tycoon/docs/SYSTEMS.md | **KEEP** | Game systems architecture |

---

## Proposed Folder Structure

### KEEP (Essential Documentation)

```
roblox-games/
├── README.md                          (primary project doc)
├── CONTRIBUTING.md                    (collaboration guide)
├── docs/
│   ├── SETUP.md                      (installation & setup)
│   ├── FEATURES.md                   (feature overview)
│   ├── GAMEPLAY.md                   (gameplay mechanics)
│   ├── SYSTEMS.md                    (architecture)
│   ├── GAMES.md                      (multi-game reference)
│   └── archive/                      (archived docs - see below)
│
└── games/ghost-catcher-tycoon/
    ├── README.md                     (game-specific doc)
    ├── TEST_GUIDE.md                 (testing procedures)
    ├── STATUS.md                     (current game status/phase)
    └── docs/
        ├── SETUP.md                  (game setup)
        ├── FEATURES.md               (game features)
        ├── GAMEPLAY.md               (game mechanics)
        └── SYSTEMS.md                (game architecture)
```

### ARCHIVE (Development Artifacts - Historical Reference)

```
docs/archive/ghost-catcher-tycoon/
├── START_HERE.md                     (dev onboarding)
├── QUICK_REFERENCE.md                (quick-start notes)
├── CODE_LOCATIONS.md                 (code navigation from dev)
├── SYSTEM_COMPONENTS_CHECKLIST.md    (dev checklist)
├── MASTER_PROMPT.md                  (claude dev prompt)
├── PROJECT_SUMMARY.md                (phase summary)
├── COMPLETION_STATUS.md              (earlier status)
├── ANSWER_TO_QUESTION.md             (Q&A reference)
├── INTEGRATION_SUMMARY.md            (integration notes)
├── EGGSYSTEM_WIRED.md                (system verification)
├── ROBLOX_STUDIO_IMPORT.md           (studio setup notes)
├── PRE_REOPEN_VERIFICATION.md        (verification checklist)
├── RESTART_AND_TEST.md               (testing instructions)
└── DOCUMENTATION_INDEX.md            (planning index)

docs/archive/root/
├── IDEAS.md                          (feature brainstorming)
├── INDEX.md                          (root index/TOC)
├── MASTER_PROMPT.md                  (root dev prompt)
└── PROJECT_SUMMARY.md                (root project snapshot)
```

---

## DELETE Commands (Safe to Run)

```bash
# Root level - duplicate CONTRIBUTING
rm "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\CONTRIBUTING.md"

# Ghost-catcher - only if game-specific CONTRIBUTING doesn't exist
rm "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\CONTRIBUTING.md"
```

---

## Cleanup Steps (Safe - No Data Loss)

### Step 1: Create Archive Folders
```bash
mkdir -p "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon"
mkdir -p "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\root"
```

### Step 2: Move Archive Files
```bash
# Move ghost-catcher dev artifacts
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\START_HERE.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\INDEX.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\QUICK_REFERENCE.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\CODE_LOCATIONS.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\SYSTEM_COMPONENTS_CHECKLIST.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\MASTER_PROMPT.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\PROJECT_SUMMARY.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\COMPLETION_STATUS.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\ANSWER_TO_QUESTION.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\INTEGRATION_SUMMARY.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\EGGSYSTEM_WIRED.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\ROBLOX_STUDIO_IMPORT.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\PRE_REOPEN_VERIFICATION.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\RESTART_AND_TEST.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\DOCUMENTATION_INDEX.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\ghost-catcher-tycoon\"

# Move root dev artifacts
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\IDEAS.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\root\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\INDEX.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\root\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\MASTER_PROMPT.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\root\"
move "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\PROJECT_SUMMARY.md" "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\archive\root\"
```

### Step 3: Delete Duplicates
```bash
rm "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\docs\CONTRIBUTING.md"
rm "C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\CONTRIBUTING.md"
```

### Step 4: Add START_HERE.md Status File
Create `games/ghost-catcher-tycoon/STATUS.md` to replace outdated status files

---

## Summary: What This Cleanup Achieves

✅ **Cleaner Project Structure**
- Essential docs at root/docs/ level for easy access
- Development artifacts archived but preserved for historical reference
- Game-specific docs in game folder, doesn't clutter root

✅ **Easier Navigation**
- New developers see README.md, START_HERE.md, CONTRIBUTING.md, TEST_GUIDE.md
- Legacy docs (MASTER_PROMPT, PROJECT_SUMMARY) archived but findable
- No confusion about which docs are active vs. historical

✅ **Better Maintenance**
- Each game has its own docs folder (when you add game-2, game-3, etc.)
- Archive folder grows with project history
- Status of each game clear via STATUS.md instead of 5 conflicting status files

✅ **Git History Clean**
- Removes duplicate CONTRIBUTING.md
- Moves instead of deletes = no git history loss
- Archive folder preserves all artifacts for future reference

✅ **Scales to Multiple Games**
- Structure works for 1 game or 20 games
- Each game is self-contained with clear docs
- Root docs explain the entire project

---

## What You Should Do Next

1. **Review this audit** — agree/disagree with classifications
2. **I'll execute the cleanup** — move files, delete duplicates, git commit
3. **Create STATUS.md** — to replace the 5 conflicting status files
4. **Push to GitHub** — one clean commit with "docs: organize and archive development files"

---

*Report Generated: 2026-06-02*
*Total .md files analyzed: 34*
*KEEP: 13 | ARCHIVE: 18 | DELETE: 2 | DUPLICATE: 1*
