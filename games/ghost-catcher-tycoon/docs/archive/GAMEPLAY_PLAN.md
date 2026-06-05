# Ghost Catcher Tycoon — Gameplay Plan (Updated)

## What You ACTUALLY Have

You've already built a **complete tycoon game system** across 18 systems! Here's what exists:

### Data & Content (Already Complete ✅)
- **120 ghosts** across 6 rarity tiers (Common → Corrupted)
- **11 zones** with spawn weights per ghost (Whisper Woods → Eternity Nexus)
- **5 bosses** with HP, damage, drop tables (Gravekeeper → Rift Titan)
- **7 egg types** with rarity chances & pools (Common Egg → Premium Robux Egg)
- **5 HQ rooms** (GhostChamber, TrainingFacility, EnergyReactor, ResearchLab, BossArena)
- **Full enum system** for rarities, zones, rooms, currency, events
- **Remote events** for all gameplay: ChargeVacuum, CatchGhost, TrainGhost, UpgradeRoom, UnlockZone, GachaPull, etc.

### Systems Already Coded ✅
1. **GhostService** — Ghost spawning & catching logic
2. **CurrencySystem** — Energy currency
3. **HQSystem** — Room management
4. **ZoneSystem** — Zone unlocking
5. **TrainingSystem** — Ghost leveling
6. **EggSystem** — Hatching
7. **GachaSystem** — Pulling from eggs
8. **BossSystem** — Boss fights
9. **PrestigeSystem** — Reset + bonuses
10. **LeaderboardSystem** — Top players
11. **EventSystem** — Time-based events
12. **QuestSystem** — Quest tracking
13. **MonetizationSystem** — Game passes & products
14. **PvPSystem** — Player battles
15. **CosmeticsSystem** — Skins & customization
16. **ProductionSystem** — Passive income
17. **AutoCatchSystem** — Auto-catch (if enabled)
18. **AutoTrainSystem** — Auto-train (if enabled)

---

## What's MISSING (The MVP to Wire)

### Phase 1: Connect Everything (Next 1-2 hours)

1. **Ghost Spawning in Zones** ✋
   - Modify ZONE_AUTO_BUILDER to spawn colored spheres (per rarity)
   - Wire GhostService.SpawnGhost() calls in zones
   - Make ghosts clickable → trigger CatchGhost remote

2. **Wire Catch Button** ✋
   - GameClient.lua: Connect "Catch Ghost" button
   - Call CatchGhost remote (server-side deducts charge, adds ghost)
   - Update UI: show caught ghost, increment coins

3. **Wire Charge Button** ✋
   - GameClient.lua: Connect "Charge" button  
   - Call ChargeVacuum remote (server-side)
   - Display charge bar updating

4. **Wire UI Tabs** ✋
   - **Ghost tab:** Show caught ghosts (from DataManager)
   - **HQ tab:** Show room levels + upgrade buttons
   - **Zones tab:** Show unlocked zones + unlock cost
   - **Shop tab:** Show eggs + hatch buttons (optional for MVP)
   - **Info tab:** Show current stats (catch count, coins, charge)

---

## Implementation Strategy

**Start simple (1 zone):**
1. Spawn ghosts in Meadow zone only
2. Test catching 1 ghost type
3. Verify coins increment
4. Then expand to all zones

**Don't do yet:**
- Ghost AI/movement (static floaters are fine)
- Sound effects or animations
- Advanced cosmetics
- Prestige/battles (code exists, not needed for MVP)

---

## Pending Documentation Tasks

These visual documents clarify game design but don't block MVP. Add after testing:

1. **Zone Progression Chart (visual)** — Show all 11 zones with unlock costs, biomes, and ghost pools
2. **Feature Roadmap (visual)** — Timeline showing phases: MVP → Mechanics → Polish → Features
3. **Monetization Flowchart** — Diagram showing coin/energy/robux flow (catch → coins → upgrades → zones)
4. **Ghost Inventory UI Design** — Mockup for caught ghosts grid (currently has test data)
5. **Top-Down Zone Layout Mockup** — ASCII or visual showing zone positions and bridge connections
6. **Zone Size Standardization Doc** — Document recommending consistent 350×350 studs per zone
7. **Full Integration Prompt** — Complete step-by-step guide for wiring all systems together

---

## Key Files to Wire

| File | What to do |
|------|-----------|
| `ZONE_AUTO_BUILDER.lua` | Call GhostService.SpawnGhost() for each zone |
| `GameClient.lua` | Wire Catch + Charge buttons to remotes |
| `GhostService.lua` | Already exists—just call from zones |
| `DataManager.lua` | Already handles persistence |

---

## Your Competitive Advantage

You have **15+ complete systems** most games start without. Your main task is **connecting the UI to the backend**—not building systems from scratch. 🚀

**Next:** Start with ghost spawning in zones, then wire the buttons. Should be ~200 lines of code total.

---

**Ready to wire the Catch button?**
