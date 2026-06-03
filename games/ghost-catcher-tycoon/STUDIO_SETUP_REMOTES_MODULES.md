<!--
  Ghost Catcher Tycoon — Studio Setup: Remotes & Modules
  Author:  nobody174 (vartdal@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Studio Setup: Remotes & Modules Guide

## Quick Answer
- **Remotes folder:** RemoteEvents & RemoteFunctions (NOT ModuleScripts)
- **Modules folder:** ModuleScripts (Lua code you can require)

---

## Step 1: Create Remotes in ReplicatedStorage/Remotes

**Remotes are RemoteEvents & RemoteFunctions (NOT ModuleScripts)**

### In Studio:
1. Right-click **ReplicatedStorage/Remotes**
2. Insert Object → **RemoteEvent**
3. Name it exactly: **ChargeVacuum**
4. Repeat for these RemoteEvents:
   - ✅ ChargeVacuum (RemoteEvent)
   - ✅ CatchGhost (RemoteEvent)
   - ✅ BringGhostsHome (RemoteEvent)
   - ✅ UpdateUI (RemoteEvent)
   - ✅ ShowNotification (RemoteEvent)

5. For RemoteFunction, create this one:
   - Right-click Remotes → Insert Object → **RemoteFunction**
   - Name: **GetGameState**

### Result:
```
ReplicatedStorage/
├── Remotes/
│   ├── ChargeVacuum (RemoteEvent)
│   ├── CatchGhost (RemoteEvent)
│   ├── BringGhostsHome (RemoteEvent)
│   ├── UpdateUI (RemoteEvent)
│   ├── ShowNotification (RemoteEvent)
│   └── GetGameState (RemoteFunction) ← DIFFERENT!
```

**Important:** RemoteEvent is for one-way messages, RemoteFunction is for request-response

---

## Step 2: Create ModuleScripts in ReplicatedStorage/Modules

**ModuleScripts ARE Lua code (like .lua files)**

### GhostCardBuilder.lua

1. Right-click **ReplicatedStorage/Modules**
2. Insert Object → **ModuleScript**
3. Name: **GhostCardBuilder**
4. Double-click to edit
5. **DELETE** all default code
6. **PASTE** contents from: `src/client/modules/GhostCardBuilder.lua`
7. Save (Ctrl+S)

### Result:
```
ReplicatedStorage/
├── Modules/
│   └── GhostCardBuilder (ModuleScript) ← Lua code inside
```

---

## Step 3: Create Shared Data in ReplicatedStorage/shared

**These are ModuleScripts with data/configuration**

You need to create these ModuleScripts in the **shared/** folder:

### Files to create (all ModuleScripts):

1. **config.lua**
   - Right-click shared → Insert ModuleScript
   - Name: **config**
   - Paste from: `src/shared/config.lua`

2. **constants.lua**
   - Insert ModuleScript
   - Name: **constants**
   - Paste from: `src/shared/constants.lua`

3. **enums.lua**
   - Insert ModuleScript
   - Name: **enums**
   - Paste from: `src/shared/enums.lua`

4. **ZoneData.lua**
   - Insert ModuleScript
   - Name: **ZoneData**
   - Paste from: `src/shared/ZoneData.lua`

5. **GhostData.lua**
   - Insert ModuleScript
   - Name: **GhostData**
   - Paste from: `src/shared/GhostData.lua`

6. **EggData.lua**
   - Insert ModuleScript
   - Name: **EggData**
   - Paste from: `src/shared/EggData.lua`

7. **BossData.lua**
   - Insert ModuleScript
   - Name: **BossData**
   - Paste from: `src/shared/BossData.lua`

### Result:
```
ReplicatedStorage/
├── shared/
│   ├── config (ModuleScript)
│   ├── constants (ModuleScript)
│   ├── enums (ModuleScript)
│   ├── ZoneData (ModuleScript)
│   ├── GhostData (ModuleScript)
│   ├── EggData (ModuleScript)
│   └── BossData (ModuleScript)
```

---

## Quick Reference: What Goes Where

| Type | Purpose | Example |
|------|---------|---------|
| **RemoteEvent** | Fire data from client→server or server→client (one-way) | ChargeVacuum, CatchGhost |
| **RemoteFunction** | Request-response (wait for answer) | GetGameState |
| **ModuleScript** | Reusable Lua code you can require() | GhostCardBuilder, config |

---

## Step-by-Step Copy-Paste Process

1. **Open VSCode** with your game files open
2. **Open Studio** with place.rbxl open
3. For each ModuleScript:
   - In VSCode: Open `src/shared/config.lua` (or other file)
   - Select all (Ctrl+A)
   - Copy (Ctrl+C)
   - Switch to Studio
   - Double-click the ModuleScript you just created
   - Select all (Ctrl+A)
   - Paste (Ctrl+V)
   - Close the editor (X)

4. **Save** in Studio (Ctrl+S)

---

## Full Directory Structure (After Setup)

This is what you should have:

```
ReplicatedStorage/
├── Remotes/
│   ├── ChargeVacuum (RemoteEvent)
│   ├── CatchGhost (RemoteEvent)
│   ├── BringGhostsHome (RemoteEvent)
│   ├── UpdateUI (RemoteEvent)
│   ├── ShowNotification (RemoteEvent)
│   └── GetGameState (RemoteFunction)
├── Modules/
│   └── GhostCardBuilder (ModuleScript with code)
└── shared/
    ├── config (ModuleScript with data)
    ├── constants (ModuleScript with data)
    ├── enums (ModuleScript with data)
    ├── ZoneData (ModuleScript with data)
    ├── GhostData (ModuleScript with data)
    ├── EggData (ModuleScript with data)
    └── BossData (ModuleScript with data)
```

---

## Testing After Setup

1. **Play** the game (▶)
2. **Check Output window**
3. You should see:
   ```
   [Ghost Catcher Tycoon] Server started
   [Ghost Catcher Tycoon] Client initializing...
   [Ghost Catcher Tycoon] Remotes connected
   [Ghost Catcher Tycoon] UI created with polished layout
   [Ghost Catcher Tycoon] Input handlers connected
   [Ghost Catcher Tycoon] Client initialized!
   ```

4. **If error:** Check what file is missing and create it
5. **If success:** Move to STUDIO_TESTING_GUIDE.md

---

## Common Mistakes ❌

**Mistake 1:** Creating ModuleScript for Remotes
- ❌ RemoteEvent = ModuleScript (WRONG!)
- ✅ RemoteEvent = Special Roblox object (RIGHT)

**Mistake 2:** Wrong name for RemoteEvent
- ❌ `ChargeVaccum` (typo)
- ✅ `ChargeVacuum` (correct spelling)
- The name must EXACTLY match what MainServer looks for!

**Mistake 3:** Forgetting to paste code into ModuleScript
- ❌ Empty ModuleScript
- ✅ ModuleScript with actual Lua code pasted inside

**Mistake 4:** Creating in wrong folder
- ❌ `Remotes/config.lua` (should be in shared)
- ✅ `shared/config.lua`

---

## Verification Checklist

After you're done, check:

- [ ] ReplicatedStorage has **Remotes** folder
- [ ] ReplicatedStorage has **Modules** folder  
- [ ] ReplicatedStorage has **shared** folder
- [ ] Remotes has 5 RemoteEvents + 1 RemoteFunction (6 total)
- [ ] Modules has GhostCardBuilder ModuleScript
- [ ] shared has 7 ModuleScripts (config, constants, enums, ZoneData, GhostData, EggData, BossData)
- [ ] Each ModuleScript has code pasted inside (not empty!)
- [ ] Play game and check Output - no errors!

---

## Next Steps

Once setup is complete:
1. Run STUDIO_TESTING_GUIDE.md tests
2. Report which tests pass/fail
3. I'll fix any issues

---

**Questions?** Let me know which step you're on! 👻

Built with Claude Code by Anthropic.
