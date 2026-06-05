# Admin Chat Handler Setup

**Date:** 2026-06-04  
**Feature:** Native Roblox chat admin commands  
**Prefix:** `!` (e.g., `!coin`, `!help`, `!heal`)

---

## What Changed

1. **New File:** `src/server/AdminChatHandler.lua` — Intercepts chat messages and routes admin commands
2. **Modified:** `src/server/AdminCommands.lua` — Updated error message to use `!` instead of `/`

The system now uses **native Roblox Player.Chatted event** instead of custom UI or RemoteFunction calls.

---

## How It Works

1. You type in the **in-game Roblox chat** (bottom of screen)
2. Type a command with `!` prefix: `!coin`, `!heal`, `!help`
3. AdminChatHandler intercepts the message
4. Routes to AdminCommand RemoteFunction
5. AdminCommands handler executes the command
6. Results appear in **Studio output log**

---

## Setup in Studio

### Step 1: Add AdminChatHandler to ServerScriptService
1. Open `place.rbxl` in Studio
2. In **Explorer**, expand **ServerScriptService**
3. Right-click → **Insert Object** → **LocalScript** (NOT LocalScript, use **Script**)
4. Rename to `AdminChatHandler`
5. Copy entire contents of `src/server/AdminChatHandler.lua`
6. Paste into the script in Studio

**Result:** You should see in output: `[ADMIN CHAT] System ready! Prefix: !`

### Step 2: Verify AdminCommands is Running
- Check that `MainServer` or `MainServer_Phase4_Extended` is in **ServerScriptService**
- Check that it creates `AdminCommand` remote in **ReplicatedStorage/Remotes**
- In output, you should see: `[ADMIN COMMANDS] System ready!`

### Step 3: You're Done!
Both scripts are now running and ready to handle chat commands.

---

## Available Commands

Type these in the **in-game chat** (bottom of screen):

| Command | Effect |
|---------|--------|
| `!coin` | Add 1000 coins |
| `!energy` | Add 1000 energy |
| `!ghost [name]` | Spawn a ghost in inventory |
| `!heal` | Add 1000 coins |
| `!heal max` | Set coins to 9999 |
| `!heal @player` | Add 1000 coins to target player |
| `!mute @player` | Mute a player |
| `!unmute @player` | Unmute a player |
| `!kick @player` | Kick a player |
| `!tp @player [ISLAND\|@player2]` | Teleport player |
| `!admin @player` | Make a player admin |
| `!unadmin @player` | Remove admin status |
| `!help` | Show all commands |

---

## Testing Checklist

- [ ] Type `!coin` in chat → See output log: `[ADMIN CHAT] nobodylearn174 executed: !coin`
- [ ] Check coins increased by 1000
- [ ] Type `!help` in chat → See full command list in output
- [ ] Type `!heal max` in chat → Coins set to 9999
- [ ] Non-admin types `!coin` → See error: `is not an admin`
- [ ] Type invalid command `!notacmd` → See error in output log

---

## Output Log Locations

**To see command results:**
1. In Studio, look at **Output** window (bottom of screen)
2. Commands appear as:
   - Success: `[ADMIN CHAT] nobodylearn174 executed: !coin`
   - Error: `[ADMIN CHAT] Command failed or permission denied...`
   - Details: `[ADMIN] nobodylearn174 gained 1000 coins (total: 1234)`

---

## Notes

- Commands must start with `!` (e.g., `!coin`, not `/coin`)
- Only admins can execute commands (username in AdminCommands.lua adminList)
- Non-admin attempts are logged but command fails silently in chat
- All results appear in **Studio output log**, not in-game chat
- Chat message with command still appears in-game (e.g., "nobodylearn174: !coin")

---

## Troubleshooting

**Q: Command doesn't execute**  
A: Check that both `MainServer` (or `MainServer_Phase4_Extended`) AND `AdminChatHandler` are running in ServerScriptService

**Q: "System ready" but commands don't work**  
A: Check in output log for `[ADMIN COMMANDS] Connected to main server player data` message

**Q: Getting permission denied**  
A: Make sure your username is in `AdminCommands.lua` line 48 in the `adminList` table

**Q: Can't see output log results**  
A: Open Studio's **Output** window (View → Output, or Ctrl+P in studio)

---

**Ready to test!** Type `!help` in the in-game chat to verify everything is working.
