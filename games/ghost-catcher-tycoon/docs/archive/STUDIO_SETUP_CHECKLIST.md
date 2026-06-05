# Studio Setup Checklist: Fixing Module Paths

**Problem:** MainServer and GameClient can't find their required modules.

**Solution:** Create folder structures and add modules in Studio.

---

## **Step 1: Create ServerScriptService → systems Folder**

1. In Roblox Studio Explorer, expand **ServerScriptService**
2. Right-click → **Insert Object** → **Folder**
3. Name it: `systems`
4. Click OK

---

## **Step 2: Add GhostSpawner Module to systems Folder**

1. Right-click the **systems** folder you just created
2. **Insert Object** → **ModuleScript**
3. Name it: `GhostSpawner`
4. Click OK
5. **Double-click the GhostSpawner script** to open it
6. **Replace ALL the code** with contents from:
   - File: `src/server/systems/GhostSpawner.lua`
   - Location: `C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\src\server\systems\GhostSpawner.lua`
7. Save (Ctrl+S)

---

## **Step 3: Create StarterPlayerScripts → modules Folder**

1. Expand **StarterPlayer** → **StarterPlayerScripts**
2. Right-click → **Insert Object** → **Folder**
3. Name it: `modules`
4. Click OK

---

## **Step 4: Add GhostCardBuilder Module to modules Folder**

1. Right-click the **modules** folder you just created
2. **Insert Object** → **ModuleScript**
3. Name it: `GhostCardBuilder`
4. Click OK
5. **Double-click the GhostCardBuilder script** to open it
6. **Replace ALL the code** with contents from:
   - File: `src/client/modules/GhostCardBuilder.lua`
   - Location: `C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\src/client/modules/GhostCardBuilder.lua`
7. Save (Ctrl+S)

---

## **Step 5: Verify Folder Structure in Studio**

After completing steps 1-4, your Studio Explorer should look like:

```
ServerScriptService
├── MainServer (existing script)
├── ZoneAutoBuilder (existing script)
├── systems (NEW FOLDER)
│   └── GhostSpawner (NEW MODULE)
├── All other existing systems...

StarterPlayer
└── StarterPlayerScripts
    ├── GameClient (existing script)
    ├── FlyTool (existing script)
    └── modules (NEW FOLDER)
        └── GhostCardBuilder (NEW MODULE)
```

---

## **Step 6: Test Again**

1. **Save the place** (Ctrl+S or File → Save)
2. **Press Play** in Studio
3. Check **Output** for errors
4. You should see the "Infinite yield" errors are gone!

---

## **If You Still Get Errors**

Check that:
- [ ] GhostSpawner.lua code is 100% copied into ServerScriptService → systems → GhostSpawner
- [ ] GhostCardBuilder.lua code is 100% copied into StarterPlayer → StarterPlayerScripts → modules → GhostCardBuilder
- [ ] Both modules are **ModuleScript** (not LocalScript)
- [ ] Folder names are **exactly** "systems" and "modules" (case-sensitive)
- [ ] You saved the place after adding the modules

---

## **Alternative: Copy-Paste Full Code**

If you need the full code for the modules, I can provide them in the next message. Just ask!

---

**After this, the game should load without the "Infinite yield" errors.** 🎮
