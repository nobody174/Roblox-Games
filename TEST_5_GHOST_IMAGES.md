<!--
  Test 5 Ghost Images - BillboardGui Rendering Verification
  Date: 2026-06-08
  Goal: Verify image rendering looks correct before uploading all 120
-->

# Test Plan: 5 Ghost Images BillboardGui Rendering

**Goal:** Verify the rounded, floating image billboards look good (not big squares)  
**Test Images:** 5 ghosts (covers different rarities & styles)  
**Timeline:** ~30 min to upload + test

---

## Step 1: Select 5 Test Images

Pick these 5 (good variety):

| # | Ghost Name | File | Rarity | Why |
|---|------------|------|--------|-----|
| 1 | **Captain Wisp** | `ghost_001_Captain_Wisp.png` | Common | Pirate, simple |
| 2 | **Arcane Puff** | `ghost_006_Arcane_Puff.png` | Common | Wizard, sparkles |
| 3 | **Storm Streak** | `ghost_041_Storm_Streak.png` | Uncommon | Storm, more detail |
| 4 | **Quantum Burst** | `ghost_071_Quantum_Burst.png` | Rare | Cyber, complex |
| 5 | **Crown Specter** | `ghost_091_Crown_Specter.png` | Epic | Regal, high detail |

---

## Step 2: Upload 5 Images to Roblox

**Process:**
1. Visit: https://www.roblox.com/develop/assets
2. Click **"Create"** → **"Image"**
3. Upload each PNG file
4. **Copy the Asset ID** shown after upload
5. **Paste into the table below** as you go

### Upload Results (Fill As You Go)

| Ghost | File | Asset ID | Status |
|-------|------|----------|--------|
| Captain Wisp | ghost_001_Captain_Wisp.png | [PASTE HERE] | ⏳ |
| Arcane Puff | ghost_006_Arcane_Puff.png | [PASTE HERE] | ⏳ |
| Storm Streak | ghost_041_Storm_Streak.png | [PASTE HERE] | ⏳ |
| Quantum Burst | ghost_071_Quantum_Burst.png | [PASTE HERE] | ⏳ |
| Crown Specter | ghost_091_Crown_Specter.png | [PASTE HERE] | ⏳ |

---

## Step 3: Create Test JSON File

Once you have the 5 asset IDs, create this file:

**File:** `ghost_asset_ids_test.json`  
**Location:** Same folder as `update_ghostdata.py`

**Content (fill in your asset IDs):**
```json
{
  "1": {
    "name": "Captain Wisp",
    "asset_id": YOUR_ID_HERE
  },
  "6": {
    "name": "Arcane Puff",
    "asset_id": YOUR_ID_HERE
  },
  "41": {
    "name": "Storm Streak",
    "asset_id": YOUR_ID_HERE
  },
  "71": {
    "name": "Quantum Burst",
    "asset_id": YOUR_ID_HERE
  },
  "91": {
    "name": "Crown Specter",
    "asset_id": YOUR_ID_HERE
  }
}
```

---

## Step 4: Update GhostData.lua (Test Version)

**Option A: Quick Manual Update**

Edit `src/shared/GhostData.lua` directly:

Find the `GhostImages` table and update ONLY these 5:
```lua
GhostImages = {
  -- Common
  ["Captain Wisp"] = YOUR_ASSET_ID_1,
  ["Arcane Puff"] = YOUR_ASSET_ID_6,
  
  -- Uncommon
  ["Storm Streak"] = YOUR_ASSET_ID_41,
  
  -- Rare
  ["Quantum Burst"] = YOUR_ASSET_ID_71,
  
  -- Epic
  ["Crown Specter"] = YOUR_ASSET_ID_91,
  
  -- Keep all others as 0 for now
  ["Jolly Specter"] = 0,
  ["Treasure Puff"] = 0,
  ... (rest stay 0)
}
```

**Option B: Use Python Script**

```bash
python update_ghostdata.py ghost_asset_ids_test.json
```

(I can create a modified script that reads from a test JSON file)

---

## Step 5: Copy to Studio & Test

1. **Copy updated GhostData.lua** to Studio
   - Select all code (Ctrl+A)
   - Replace the GhostData.lua in Studio
   - Save place file

2. **Spawn the 5 test ghosts** in Studio
   ```
   !sw Captain Wisp
   !sw Arcane Puff
   !sw Storm Streak
   !sw Quantum Burst
   !sw Crown Specter
   ```
   (Use admin commands or spawn manually in zones)

3. **Verify the rendering:**
   - ✅ Images appear as floating billboards (not flat squares on chest)
   - ✅ Images have **rounded corners** (not sharp edges)
   - ✅ Images have **transparent backgrounds** (no white box around them)
   - ✅ Images have **shadow/outline** effect (subtle gray border)
   - ✅ Images scale with distance (get smaller as you move away)
   - ✅ Images float slightly above the ghost body

---

## What to Look For

### ✅ GOOD RESULT
```
Ghost body (round, colored)
    ↓
Floating billboard ~150px
    ├─ Rounded image (20px corners)
    ├─ Transparent background
    └─ Gray shadow outline
```

### ❌ BAD RESULT (What We're Trying to Avoid)
```
Ghost body
    ↓
Big flat white square in front (opaque background)
    ├─ Sharp corners
    ├─ Blocks ghost visibility
    └─ Looks unprofessional
```

---

## Success Criteria

| Check | Status | Notes |
|-------|--------|-------|
| All 5 images upload successfully | ⏳ | Should take ~5 min total |
| Images display as billboards | ⏳ | Should be ~150×150 px floating |
| Rounded corners visible | ⏳ | UICorner with 20px radius |
| Transparent background | ⏳ | No white box, only ghost image |
| Shadow/outline effect | ⏳ | Gray UIStroke visible |
| Images scale with distance | ⏳ | Get smaller as you move away |
| No lag or performance issues | ⏳ | Should be smooth, no stuttering |

---

## If Something Looks Wrong

### Issue: Images still show as flat white squares
**Cause:** Background opacity issue, transparent PNG not loading properly  
**Fix:** Check if image needs post-processing, verify PNG format in Roblox

### Issue: Images not visible at all
**Cause:** Asset ID wrong, image loading failed  
**Fix:** Double-check asset IDs, try re-uploading one image

### Issue: Images are pixelated/blurry
**Cause:** Size too large/small, ScaleType wrong  
**Fix:** Adjust BillboardGui size in MainServer_Phase4_Extended.lua (line 239)

### Issue: Images lag the game
**Cause:** Too many billboards, resolution too high  
**Fix:** Reduce BillboardGui size, MaxDistance, or resolution

---

## Next Steps After Test

### If ✅ GOOD:
1. Delete the 2 duplicate images from ghost_output_fixed
2. Prepare to upload remaining 118 images
3. Scale up the process (maybe batch upload if Roblox supports it)

### If ❌ NEEDS ADJUSTMENT:
1. Identify the issue
2. Adjust BillboardGui code if needed
3. Fix image format if needed
4. Re-test with 1-2 images

---

## Timeline

- **Upload 5 images:** 10 min
- **Fill asset IDs:** 5 min
- **Update GhostData.lua:** 5 min
- **Test in Studio:** 10 min
- **Total:** ~30 minutes

---

## Quick Reference

**Upload location:** https://www.roblox.com/develop/assets

**BillboardGui code location:** `src/server/MainServer_Phase4_Extended.lua` lines 232-267

**Key settings:**
- Size: `UDim2.new(0, 150, 0, 150)` (150×150 pixels)
- Offset: `Vector3.new(0, 0.5, 0)` (floats above ghost head)
- MaxDistance: `100` (visible from up to 100 studs away)
- CornerRadius: `UDim.new(0, 20)` (20px rounded corners)
- UIStroke: `2px` gray outline

---

**Status:** Ready to test  
**Timeline:** 30 min  
**Success Rate:** High (images look great, code is ready)

Let's do this! 🚀

