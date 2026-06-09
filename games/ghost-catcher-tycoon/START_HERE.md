# 🚀 START HERE - Complete Setup Guide

Welcome! This document will guide you through setting up all the changes in Roblox Studio.

---

## 📋 What Was Built

You now have:
- ✅ **Ghost AI System** - Ghosts behave based on rarity (Common=still, Legendary=teleport)
- ✅ **Private Phases** - Each player gets their own Starting Area instance
- ✅ **Smart Spawning** - Ghosts spawn in both shared zones AND private starting areas
- ✅ **Persistence Framework** - Catches, coins, and stats persist when you rejoin

---

## ⚡ Quick Start (5 Minutes)

### Step 1: Copy 2 NEW Files (2 min)

Open Roblox Studio and create these 2 new ModuleScripts:

**A. Create `GhostAI` Module:**
- In ServerScriptService, click `+` → ModuleScript
- Name it: `GhostAI`
- Copy entire contents from: `src/server/GhostAI.lua`
- Save

**B. Create `PhaseManager` Module:**
- In ServerScriptService, click `+` → ModuleScript
- Name it: `PhaseManager`
- Copy entire contents from: `src/server/PhaseManager.lua`
- Save

### Step 2: Replace 2 EXISTING Files (2 min)

**C. Replace `MainServer_Phase4_Extended` Script:**
- Open ServerScriptService → MainServer_Phase4_Extended
- Select all (Ctrl+A)
- Copy from: `src/server/MainServer_Phase4_Extended.lua`
- Paste entire contents
- Save

**D. Replace `ZoneManager` Module:**
- Open ServerScriptService → ZoneManager
- Select all (Ctrl+A)
- Copy from: `src/server/ZoneManager.lua`
- Paste entire contents
- Save

### Step 3: Test (1 min)

1. Close all script editors
2. Click **PLAY** in Studio
3. Open Output window (View → Output)
4. Look for: `[PHASE 4] Spawn cycle #1: Spawned X ghosts`
5. Walk around and find a ghost!
6. Click CHARGE → CATCH
7. Success! You caught your first ghost! 🎉

---

## 📁 File Reference

Need help? Check these files in your project folder:

| Document | Purpose |
|----------|---------|
| `COPY_PASTE_GUIDE.md` | Simple step-by-step copy/paste instructions |
| `UPDATES_FOR_STUDIO.md` | Detailed file-by-file update guide |
| `FILE_LOCATIONS.txt` | Exact file paths on your computer and in Studio |
| `FILES_SUMMARY.txt` | Quick overview of what changed |
| `DETAILED_CHANGES.md` | Line-by-line changes explained |
| `TEST_PERSISTENCE.md` | How to test ghost persistence |

---

## 🎯 What Each New File Does

### GhostAI.lua
Makes ghosts behave differently based on rarity:
- **Common** (0 speed) - Stands completely still
- **Uncommon** (5 speed) - Wanders slowly, 20% dodge chance
- **Rare** (12 speed) - Flees from players, 40% dodge chance
- **Epic** (20 speed) - Aggressively flees, 60% dodge chance
- **Legendary** (30 speed) - Teleports away, 80% dodge chance
- **Corrupted** (35 speed) - Aggressively teleports, 100% dodge chance

### PhaseManager.lua
Creates private zones for each player:
- When you join, a new "Phase_#_YourName" folder is created
- The Hub zone is cloned into your private phase
- You're teleported to your private phase
- Ghosts spawn in your private phase
- Your phase is cleaned up when you leave

---

## ✅ Expected Results

### Right After Playing
- [ ] You spawn in private Starting Area
- [ ] Ghosts appear every few seconds
- [ ] You can catch ghosts
- [ ] Coins increase per catch
- [ ] Inventory shows caught ghosts

### After Stop/Play Cycle
- [ ] Your caught ghosts are still there
- [ ] Your coins are still there
- [ ] New game session = new private phase instance

---

## 🐛 If Something's Wrong

### "No ghosts spawning"
→ Check Output for: `[PHASE 4] Spawn cycle #1`
→ If missing, you didn't create GhostAI or PhaseManager modules yet

### "Module not found" error
→ Check spelling of module names (must be exactly: `GhostAI`, `PhaseManager`)
→ Make sure you created them as ModuleScript, not Script

### "Ghosts spawn but don't move"
→ You didn't copy GhostAI.lua correctly
→ Check for red errors in Output

### "Can't catch ghosts"
→ Move closer to ghost (within 20 studs)
→ Click CHARGE button first (2-3 times)
→ Then click CATCH when near ghost

---

## 📊 Architecture Overview

```
When Player Joins:
    ↓
PhaseManager creates private "Phase_1_PlayerName"
    ↓
Clones Hub zone into private phase
    ↓
Teleports player to private phase
    ↓
Ghost Spawn Loop starts:
    • Spawns ghosts in shared zones (Whisper Woods, etc.)
    • Spawns ghosts in each player's private Hub
    ↓
GhostAI initializes each ghost with behavior based on rarity
    ↓
Player can catch ghosts, earn coins, build inventory
    ↓
Data saves every 30 seconds + on player leave
    ↓
When Player Rejoin:
    • New private phase created
    • Previous catch/coin data loaded
    • Ready to catch more ghosts!
```

---

## 🎓 Learning Resources

- **How Ghost AI Works:** Open `src/server/GhostAI.lua` and read the behavior definitions
- **How Phases Work:** Open `src/server/PhaseManager.lua` and look at `createPlayerPhase()` function
- **How Spawning Works:** Open `src/server/MainServer_Phase4_Extended.lua` and search for `startGhostSpawnLoop()`

---

## 🚀 Next Steps (After Testing)

Once you verify everything works:

1. **Test Persistence:**
   - Catch 5 ghosts
   - Stop game
   - Play again
   - Verify ghosts are still there
   - See: `TEST_PERSISTENCE.md`

2. **Test Combat AI:**
   - Spawn Corrupted ghost (hardest AI)
   - Watch it teleport away
   - Try to catch it
   - Compare with Common ghost (just stands there)

3. **Test Multiplayer (Optional):**
   - Have 2 players join
   - Each gets own private phase
   - Ghosts spawn in both phases
   - Both can catch independently

4. **Deploy to Roblox:**
   - Upload to Roblox and test on live server
   - Real DataStore will persist data permanently
   - See: `UPDATES_FOR_STUDIO.md` for deployment checklist

---

## 💡 Pro Tips

- **Faster Testing:** Set `Config.GhostSpawnRate = 2` to spawn ghosts every 2 seconds instead of default
- **Debug Output:** Search Output for `[PhaseManager]` or `[PHASE 4]` to see what's happening
- **Multiple Players:** Use ALT+CLICK to open multiple Studio windows, join game twice
- **Code Hot Reload:** In Studio, edits to ModuleScripts take effect immediately (no restart needed)

---

## 📞 Quick Reference

| Task | Action |
|------|--------|
| See what's spawning | Open Output window |
| Find a ghost | Walk around, look for glowing sphere |
| Catch ghost | CHARGE button → move close → CATCH button |
| Check inventory | Look at UI (top right usually) |
| Debug zone | Search Output for `[ZoneManager]` |
| Debug phases | Search Output for `[PhaseManager]` |
| Debug ghosts | Search Output for `[PHASE 4]` |

---

## 🎉 You're All Set!

Everything is ready to go. Just:
1. Copy the 2 new files
2. Replace the 2 existing files
3. Click PLAY
4. Catch some ghosts!

**Questions?** Check the detailed guides above.

**Ready?** Go update Studio! 🚀

---

*Built with assistance from Claude Code by Anthropic*
