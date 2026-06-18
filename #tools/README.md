# Roblox Games Development Tools

Shared testing and development utilities for all Roblox game projects.

## 🛠️ Tools

### **FLY_TOOL.lua**
Flight utility for rapid exploration and testing during Studio development.

**Usage:**
1. Copy or load `FLY_TOOL.lua` into `ServerScriptService` during testing
2. Press configured hotkeys to enable flight mode in-game
3. Move around quickly to test layouts, mechanics, and interactions

**Best for:** 
- Exploring zone layouts and terrain
- Testing player movement mechanics
- Quick iteration without respawning

**Used by:**
- Ghost Catcher Tycoon
- Development-only (remove before release)

---

## 📝 Project-Specific Integration

### For Ghost Catcher Tycoon
Copy FLY_TOOL during development testing, then remove before committing:
```bash
cp #tools/FLY_TOOL.lua games/ghost-catcher-tycoon/
# ...testing...
rm games/ghost-catcher-tycoon/FLY_TOOL.lua
```

### For New Projects
Copy or reference tools from `#tools/` as needed during development. Remove testing tools before release.

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
