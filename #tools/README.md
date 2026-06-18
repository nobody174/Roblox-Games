# Roblox Games Development Tools

Shared testing and development utilities for all Roblox game projects.

## 🛠️ Tools

### **FLY_TOOL.lua**
A flight/testing utility for rapid exploration and testing of game worlds.

**Usage:**
1. Copy `FLY_TOOL.lua` into your game's `ServerScriptService` or load it during testing
2. Run in-game to enable flight mode for faster testing
3. Press configured keys to fly, move camera, etc.

**Best for:** 
- Quickly exploring zone layouts
- Testing camera mechanics
- Rapid iteration during development

**Used by:**
- Ghost Catcher Tycoon (Phase 4+)
- Future Roblox games

---

### **ZONE_AUTO_BUILDER.lua**
Automated zone/island generation system.

**Usage:**
1. Place in your game's `ServerScriptService`
2. Configure zone templates in the game
3. Runs automatically to generate themed zones/islands

**Best for:**
- Creating multiple themed zones
- Consistent zone structure across projects
- Rapid world-building iteration

**Used by:**
- Ghost Catcher Tycoon (World Builder)
- Future Roblox games

---

## 📝 Project-Specific Integration

### For Ghost Catcher Tycoon
Copy tools from here into the project when testing:
```bash
cp #tools/FLY_TOOL.lua games/ghost-catcher-tycoon/
cp #tools/ZONE_AUTO_BUILDER.lua games/ghost-catcher-tycoon/
```

Then delete from project repo before public release (these are .gitignore'd).

### For New Projects
Link or copy these tools into your new game project as needed.

---

## 🔄 Version Control

These tools are:
- ✅ Tracked in `#tools/` folder (shared)
- ❌ NOT tracked in individual game folders (add to `.gitignore`)
- ✅ Reusable across multiple projects

**Workflow:**
1. Keep master copy in `#tools/`
2. Copy into game folder during development
3. Remove/ignore in git before public release
4. Reference these originals for future projects

---

## 📦 Future Tool Candidates

Add new shared tools here as you create them. Examples:
- Asset conversion utilities
- Testing frameworks
- Performance profilers
- Admin command systems
