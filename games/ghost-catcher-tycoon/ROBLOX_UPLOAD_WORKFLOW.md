# Roblox Asset Upload Workflow

## Step 1: Prepare Images
✅ **Done** - All 120 ghost PNGs with transparent backgrounds are ready at:
```
C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\AI img creator\ghost_output_fixed\
```

## Step 2: Upload to Roblox

### Method 1: Manual Web Upload (Recommended for first-time)
1. Visit: https://www.roblox.com/develop/assets
2. Click **"Create"** → **"Image"**
3. For each ghost PNG:
   - Select the file
   - Upload
   - Copy the **Asset ID** (number at end of URL)
   - Paste into `ghost_asset_ids.json`

**Note:** Uploading 120 images manually will take ~2-3 hours. Consider batching or using bulk tools.

### Method 2: Roblox Studio Upload (Faster)
1. Open Roblox Studio
2. Go to **Home** → **Asset Manager**
3. Bulk drag-and-drop all 120 PNGs
4. Copy asset IDs from the manager

### Method 3: API Upload (Fastest, requires script)
If Roblox API supports batch uploads, we can automate this step.

---

## Step 3: Map Asset IDs

After uploading, you'll have a list of asset IDs like:
```
Captain Wisp → 113156350598911
Jolly Specter → 80070526429699
... (120 total)
```

**Fill the template:**
```
C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\ghost_asset_ids.json
```

Example format:
```json
{
  "1": {
    "name": "Captain Wisp",
    "asset_id": 113156350598911
  },
  "2": {
    "name": "Jolly Specter",
    "asset_id": 80070526429699
  },
  ...
}
```

---

## Step 4: Auto-Generate GhostData.lua

Run this command when JSON is complete:
```bash
python update_ghostdata.py
```

This will:
- Read `ghost_asset_ids.json`
- Generate updated `GhostImages` table
- Update `src/shared/GhostData.lua`
- Ready to copy into Studio

---

## Timeline
- **Upload to Roblox:** 2-3 hours (manual) or 15 min (batch)
- **Map Asset IDs:** 5 min (copy-paste)
- **Update GhostData.lua:** 1 min (automatic)
- **Total:** ~2.5-3.5 hours

---

## Checklist
- [ ] All 120 images at `ghost_output_fixed/`
- [ ] Upload images to Roblox
- [ ] Fill `ghost_asset_ids.json` with asset IDs
- [ ] Run `python update_ghostdata.py`
- [ ] Copy updated `GhostData.lua` into Studio
- [ ] Test 5-10 ghosts spawn with images in Studio
- [ ] Done!
