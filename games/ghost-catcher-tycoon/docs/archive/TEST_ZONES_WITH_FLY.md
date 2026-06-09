<!--
  Ghost Catcher Tycoon — Test Zones with Fly Tool
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Testing Zones with Fly Tool

## Quick Setup

1. **Open place.rbxl in Roblox Studio**
2. **Add Fly Tool script:**
   - Right-click `StarterPlayer` → `StarterCharacterScripts`
   - Insert → LocalScript
   - Name it: `FlyTool`
   - Copy entire code from `FLY_TOOL.lua` and paste into script
3. **Check ZONE_AUTO_BUILDER.lua is running:**
   - Look in ServerScriptService for a script named "ZoneBuilder" or similar
   - If missing, create new Script in ServerScriptService, name it "ZoneBuilder", paste entire ZONE_AUTO_BUILDER.lua code
4. **Press Play ▶️**

---

## Zone Testing Checklist

### Spawn & Initial View
- [ ] Character spawns on green pad at Hub center
- [ ] No terrain clipping or stuck characters
- [ ] Can see sky and zone markers in distance

### Flight Controls
- [ ] Press **F** → chat shows "✈️ Flight activated!"
- [ ] **WASD** moves in camera direction
- [ ] **Space** moves up, **Ctrl** moves down
- [ ] **Mouse** look works smoothly
- [ ] Press **F** again → "🚶 Flight deactivated!" and normal movement returns

### Hub Zone
- [ ] Green spawn pad visible in center
- [ ] 5 bridges radiate outward (East, South, West, North, North)
- [ ] All bridges have railings/edges
- [ ] Bridge surface is solid (walk on them, don't fall through)

### Zone 1 — Meadow (East from Hub)
- [ ] Reach via Bridge 1
- [ ] **Terrain:** Green grass with small rolling hills
- [ ] **Props:** Trees visible (brown cylindrical shapes)
- [ ] **Color:** Natural green tones
- [ ] **Ladders:** Recovery ladders on zone edges
- [ ] **Portals:** Glowing cyan sphere pointing to next zone
- [ ] **Recovery:** Can fall off edge and climb back up via ladder

### Zone 2 — Desert (South from Hub)
- [ ] Reach via Bridge 2
- [ ] **Terrain:** Yellow/orange sand with dunes
- [ ] **Props:** Cacti visible (tall neon shapes)
- [ ] **Color:** Warm desert tones
- [ ] **Ladders:** Recovery ladders on edges
- [ ] **Portals:** Glowing cyan portal visible
- [ ] **Challenge:** Slippery terrain vs grassy meadow

### Zone 3 — Frost (South from Desert, via Bridge 4)
- [ ] Reach via Bridge 4 from Zone 2
- [ ] **Terrain:** White/blue snow
- [ ] **Props:** Ice blocks visible (semi-transparent spheres)
- [ ] **Color:** Cool icy blues and whites
- [ ] **Lighting:** Brighter, cooler blue tone
- [ ] **Ladders:** Recovery ladders present
- [ ] **Portals:** Portal to next zone visible

### Zone 5 — Tech (South from Frost, via Bridge 5)
- [ ] **Correction:** Bridge 5 now connects properly
   - Start: (0, 12, 1125)
   - End: (0, 12, 1375)
   - Should connect Frost zone edge to Tech zone edge
- [ ] **Terrain:** Metallic/tech appearance
- [ ] **Props:** Neon pads visible (glowing flat cylinders)
- [ ] **Color:** Cyan and magenta neon tones
- [ ] **Lighting:** Bright artificial blue-pink
- [ ] **Ladders:** Recovery systems in place

### Boss Arenas (Sky Islands)
- [ ] Fly up to Y=130 or higher
- [ ] **5 floating islands** visible in sky
- [ ] Each island has glowing **purple crystal** in center
- [ ] No terrain on islands (placeholder boss arenas)
- [ ] Islands positioned at:
   - Island 1: (500, 130, 0) — Meadow boss
   - Island 2: (0, 130, 500) — Desert boss
   - Island 3: (0, 130, 1000) — Frost boss
   - Island 4: (-500, 130, 0) — Haunted boss
   - Island 5: (0, 130, 1500) — Tech boss

### Bridge Connection Test

All bridges should:
- [ ] Start at edge of first zone (X±175 or Z±175 from zone center)
- [ ] End at edge of second zone
- [ ] Not float in air or underground
- [ ] Be walkable without clipping
- [ ] Have consistent height (Y=12)

**Specific bridges:**
- [ ] Bridge 1: Hub (0,0) ↔ Meadow (500,0) — East/West
- [ ] Bridge 2: Hub (0,0) ↔ Desert (0,500) — North/South
- [ ] Bridge 3: Hub (0,0) ↔ Haunted (-500,0) — West/East
- [ ] Bridge 4: Desert (0,500) ↔ Frost (0,1000) — North/South
- [ ] Bridge 5: Frost (0,1000) ↔ Tech (0,1500) — North/South ✅ **FIXED**

### Error Checking

Open **Output window** and look for:
- [ ] No red errors
- [ ] No "nil" or "attempt to index" messages
- [ ] Zone builder logs show "✅ All zones created successfully!"
- [ ] Fly tool logs show "[FlyTool] Flight tool ready!"

---

## Common Issues & Fixes

### "Flight not working / script not found"
- Check that FlyTool script is in `StarterCharacterScripts` (not `StarterPlayer`)
- Restart Play session
- Check Output for errors

### "Zones don't exist"
- Check ServerScriptService for zone builder script
- If missing, add new Script there with ZONE_AUTO_BUILDER.lua code
- Restart Play

### "Can't see bridges"
- They should be brown/stone colored parts
- Zoom in/out with mouse scroll
- Try flying under them to see if they exist

### "Boss islands missing"
- Fly up to Y=130 or higher
- Look for purple glowing spheres
- If not visible, check ZONE_AUTO_BUILDER.lua createBossArenas() function

### "Character falls through terrain"
- Terrain may have gaps
- Land on bridges instead
- Report Y-coordinate where you fell through

---

## Test Report Template

When testing complete, create a summary:

```
✅ Fly Tool test — [date]

Zones tested:
- [x] Hub
- [x] Meadow
- [x] Desert
- [x] Frost
- [x] Tech

Bridges:
- [x] All 5 bridges present
- [x] All bridges walkable
- [x] Coordinates correct

Issues found:
(none = "No issues found!")

Next steps:
(suggest fixes or next testing phase)
```

---

**Built with ❤️ by Claude Code**
