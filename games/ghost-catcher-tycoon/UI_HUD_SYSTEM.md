# UI/HUD System — Ghost Catcher Tycoon

## Current UI (Already Implemented)

### Top Status Bar
```
┌─────────────────────────────────────────────┐
│ Energy: 100/150 | Coins: 5,200 | Ghosts: 12 │  Zone: Whisper Woods
└─────────────────────────────────────────────┘
```

### Bottom Control Bar
```
┌─────────────────────────────────────────────────────────┐
│  [Catch]    [Charge]    [Bring Home]    [Equipment]     │
└─────────────────────────────────────────────────────────┘
```

---

## Expanded UI Sections

### 1. Equipment Slot UI (NEW)

**Location:** Left side of screen or as popup menu

```
┌─────────────────────────┐
│  EQUIPMENT SLOT         │
├─────────────────────────┤
│ 📦 Quantum Device       │
│    Catch Rate: 85%      │
│    Charge: 6s           │
│    Energy: 40           │
│                         │
│    [SWITCH EQUIPMENT]   │
│                         │
│ Available:              │
│ • Basic Net             │
│ • Reinforced Net        │
│ • Ghost Trap            │
│ • Spectral Cage ✓ (sel) │
│ • Quantum Device (eqp)  │
└─────────────────────────┘
```

**Features:**
- Shows currently equipped item
- Quick stats display
- Click to swap equipment
- Lists available gear
- Icon shows equipment rarity (color-coded)

---

### 2. Expanded Top Bar (UPDATED)

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│ [LVL 42]  ▓▓▓▓▓░░░░  15,000/20,000 XP    │    Energy: 100/150  Coins: 5,200    │
│ Zone: Whisper Woods  |  Ghosts Caught: 12                                      │
└──────────────────────────────────────────────────────────────────────────────────┘
```

**New Elements:**
- **Level & XP Bar** — Shows current level and XP progress to next level
- **XP Number Display** — "15,000/20,000" shows exact numbers
- **Ghost Count** — Total ghosts caught this session

---

### 3. Ghost Info Panel (NEW) — On Target

**Shows when hovering/aiming at a ghost:**

```
┌─────────────────────────────────┐
│  GHOST INFO                     │
├─────────────────────────────────┤
│ Name: Spectral Shadow           │
│ Rarity: ⭐⭐⭐ RARE              │
│                                 │
│ With Current Equipment:         │
│ Success Rate: 85% ✅            │
│                                 │
│ Rewards (if caught):            │
│ +100 XP  |  +250 Coins          │
│                                 │
│ [Press E to Catch]              │
└─────────────────────────────────┘
```

**Shows:**
- Ghost name/type
- Rarity (color-coded star rating)
- Success rate with equipped equipment
- XP and coin rewards
- Catch button hint

---

### 4. Quest Log Panel (NEW)

**Location:** Right side or as overlay menu**

```
┌──────────────────────────────────┐
│  QUESTS                          │
├──────────────────────────────────┤
│ [Daily] [Weekly] [Challenge]     │
│                                  │
│ ACTIVE:                          │
│ ✓ Catch 5 Common Ghosts          │
│   Progress: 3/5                  │
│   ▓▓▓░░░░░░                      │
│   Reward: 500 Coins, 100 XP      │
│                                  │
│ ○ Catch a Rare Ghost             │
│   Progress: 0/1                  │
│   ░░░░░░░░░░                      │
│   Reward: 2,000 Coins, 300 XP    │
│                                  │
│ ○ Earn 10,000 Coins              │
│   Progress: 7,500/10,000         │
│   ▓▓▓▓▓▓░░                       │
│   Reward: Bonus 2,000 Coins      │
│                                  │
│  Daily Streak: 🔥 5 days         │
└──────────────────────────────────┘
```

**Features:**
- Tab between Daily/Weekly/Challenge
- Progress bars for each quest
- Active quests highlighted
- Show rewards
- Streak counter with fire icon

---

### 5. Level Up Notification (NEW)

**Pops up when leveling:**

```
╔════════════════════════════════════╗
║        🎉 LEVEL UP! 🎉            ║
║                                    ║
║  Level 42 → 43                     ║
║  +1 Skill Point Available          ║
║                                    ║
║  New Unlock:                       ║
║  ⭐ Ectoplasm Blaster Equipment    ║
║                                    ║
║  Base Rewards:                     ║
║  +4,300 Coins  |  +1 Skill Point   ║
║                                    ║
║         [CLAIM REWARDS]            ║
╚════════════════════════════════════╝
```

---

### 6. Skill Points Menu (NEW)

**Access from pause menu or level up popup:**

```
┌────────────────────────────────────┐
│  SKILL POINTS (Available: 5)       │
├────────────────────────────────────┤
│                                    │
│ CATCHING BONUSES:                 │
│ ⭐⭐⭐ Better Net (+2% catch)       │
│        Cost: 5 points  [BUY]       │
│                                    │
│ ○○ Steady Aim (+3% accuracy)       │
│      Cost: 4 points  [BUY]         │
│                                    │
│ ENERGY & STAMINA:                 │
│ ⭐⭐⭐⭐⭐ Energy Pool (+5 max)       │
│         Cost: 2 points  [BUY]      │
│                                    │
│ ○ Energy Regen (+1/sec)            │
│   Cost: 3 points  [BUY]            │
│                                    │
│ COINS & REWARDS:                  │
│ ⭐⭐⭐ Greed (+5% coins)             │
│        Cost: 3 points  [BUY]       │
│                                    │
│           [Close]                  │
└────────────────────────────────────┘
```

---

### 7. Charging Indicator (NEW)

**Shows while holding charge button:**

```
Charging Equipment:
▓▓▓▓▓░░░░░  50%  (3 seconds)

Visual: Growing ring/bar around cursor
Sound: Charging hum effect
```

---

### 8. Catch Attempt Feedback (NEW)

**Shows result of catch attempt:**

**Success:**
```
╔══════════════════════╗
║  ✅ CAUGHT!          ║
║  +100 XP             ║
║  +250 Coins          ║
║  Rare Ghost           ║
╚══════════════════════╝
```

**Failed:**
```
╔══════════════════════╗
║  ❌ ESCAPED!         ║
║  Ghost dodged!       ║
║  Equipment -1 Durability
║  Try stronger gear   ║
╚══════════════════════╝
```

---

### 9. Bottom Control Bar (UPDATED)

```
┌─────────────────────────────────────────────────────────────┐
│  [⚡ Catch]    [🔄 Charge]    [🏠 Home]    [🎒 Equipment]   │
│  (E Key)       (Hold E)        (H Key)      (I Key)          │
└─────────────────────────────────────────────────────────────┘
```

**Updates:**
- Added icons to each button
- Show keyboard shortcuts
- Highlight active action
- Equipment button opens equipment menu

---

### 10. Inventory/Equipment Shop (NEW)

**Access via [🎒 Equipment] button:**

```
┌─────────────────────────────────────────────┐
│  MY EQUIPMENT                               │
├─────────────────────────────────────────────┤
│ Filter: [All] [Owned] [Available]           │
│                                             │
│ OWNED (5):                                  │
│ ✓ Basic Net (Equipped)                      │
│ ✓ Reinforced Net (Lvl 5)                    │
│ ✓ Ghost Trap (Lvl 10)                       │
│ ✓ Spectral Cage (Lvl 15)                    │
│ ✓ Quantum Device (Lvl 30)                   │
│                                             │
│ AVAILABLE FOR UNLOCK:                       │
│ 🔒 Ectoplasm Blaster (Lvl 20)  [1,500 Coins]
│ 🔒 Proton Pack (Lvl 40)        [5,000 Coins]
│ 🔒 Dimensional Siphon (Lvl 50) [10,000 Coins]
│                                             │
│           [CLOSE]                           │
└─────────────────────────────────────────────┘
```

---

### 11. Stats/Profile Screen (NEW)

**Access from pause menu:**

```
┌──────────────────────────────────────┐
│  PROFILE: nobodylearn174             │
├──────────────────────────────────────┤
│ Level: 42  |  Prestige: 0            │
│ Total XP: 850,000                    │
│                                      │
│ STATS:                               │
│ • Ghosts Caught: 1,250               │
│ • Total Coins Earned: 500,000        │
│ • Best Streak: 27                    │
│ • Playtime: 125 hours                │
│ • Favorite Zone: Gloomy Graveyard    │
│                                      │
│ ACHIEVEMENTS: 12/25                  │
│ • First Ghost Catcher                │
│ • 100 Ghost Hunter                   │
│ • Legendary Slayer                   │
│ • Coin Collector (25K)               │
│ [VIEW ALL]                           │
│                                      │
│           [CLOSE]                    │
└──────────────────────────────────────┘
```

---

## UI Color Coding

### Rarity Colors
- **Common** — Gray `#808080`
- **Uncommon** — Green `#00FF00`
- **Rare** — Blue `#0099FF`
- **Epic** — Purple `#9933FF`
- **Legendary** — Gold `#FFD700`
- **Corrupted** — Dark Red `#8B0000`

### Status Colors
- **Success** — Green `#00FF00`
- **Failed** — Red `#FF0000`
- **Charging** — Yellow/Orange `#FFB300`
- **Waiting** — Gray `#CCCCCC`
- **Available** — Cyan `#00FFFF`

---

## Mobile/Controller Support

### Mobile Controls
- **Tap ghost** → Aim at target
- **Long press** → Hold to charge
- **Release** → Fire/throw
- **Swipe left** → Equipment menu
- **Swipe right** → Quest log

### Controller Support
- **Right Trigger** → Charge
- **A/Cross Button** → Catch
- **Menu Button** → Equipment/Inventory
- **D-Pad Up** → Quest Log
- **D-Pad Down** → Stats Screen

---

## Implementation Priority

### Phase 1 (Core)
1. Equipment Slot UI
2. Expanded Top Bar (XP display)
3. Ghost Info Panel
4. Bottom Control Bar (updated)

### Phase 2 (Features)
1. Quest Log Panel
2. Charging Indicator
3. Catch Attempt Feedback
4. Level Up Notification

### Phase 3 (Advanced)
1. Skill Points Menu
2. Inventory/Shop
3. Stats/Profile Screen
4. Mobile/Controller support

---

## Key Interaction Points

| UI Element | Trigger | Action |
|---|---|---|
| Equipment Slot | Click [🎒 Equipment] | Open equipment menu |
| Ghost Info | Hover over ghost | Show target info |
| Charge Bar | Hold Catch button | Display charge progress |
| Quest Log | Click Quest tab | Show active quests |
| Level Up | Gain enough XP | Pop notification |
| Skill Menu | Click [+Skill Points] | Allocate new point |
| Stats | Open pause menu | View profile |

---

## Accessibility Features

- **Colorblind Mode** — Alternative rarity indicators (text labels)
- **Text Size** — Scalable UI elements
- **Audio Cues** — Success/fail sounds
- **Animations** — Toggle screen effects
- **Contrast Mode** — High contrast UI option

---

*Created: 2026-06-09*
*For: Ghost Catcher Tycoon UI/HUD System*
