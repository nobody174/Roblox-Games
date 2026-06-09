#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Update GhostData.lua with asset IDs from ghost_asset_ids.json
Generates the complete GhostImages table with all 120 mapped asset IDs.
"""

import json
import sys
import os
from pathlib import Path

# Fix Windows encoding
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# Configuration
PROJECT_ROOT = r"C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon"
ASSET_IDS_FILE = os.path.join(PROJECT_ROOT, "ghost_asset_ids.json")
GHOSTDATA_FILE = os.path.join(PROJECT_ROOT, "src", "shared", "GhostData.lua")
GHOSTDATA_BACKUP = os.path.join(PROJECT_ROOT, "src", "shared", "GhostData.lua.backup")

def load_asset_ids():
    """Load asset IDs from JSON file"""
    if not os.path.exists(ASSET_IDS_FILE):
        print(f"ERROR: {ASSET_IDS_FILE} not found!")
        print("Please fill ghost_asset_ids.json with asset IDs first.")
        return None

    with open(ASSET_IDS_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

def generate_ghostimages_table(asset_ids):
    """Generate the GhostImages Lua table"""
    code = "\t-- Image asset IDs — mapped from Roblox uploads via update_ghostdata.py\n"
    code += "\tGhostImages = {\n"

    # Group by rarity for readability
    rarity_groups = {
        "Common": list(range(1, 41)),      # 1-40
        "Uncommon": list(range(41, 71)),   # 41-70
        "Rare": list(range(71, 91)),       # 71-90
        "Epic": list(range(91, 106)),      # 91-105
        "Legendary": list(range(106, 116)), # 106-115
        "Corrupted": list(range(116, 121)) # 116-120
    }

    total_mapped = 0

    for rarity, ghost_ids in rarity_groups.items():
        code += f"\t\t-- {rarity} ({len(ghost_ids)} ghosts)\n"
        for idx in ghost_ids:
            idx_str = str(idx)
            if idx_str in asset_ids:
                ghost_data = asset_ids[idx_str]
                ghost_name = ghost_data["name"]
                asset_id = ghost_data["asset_id"]

                if asset_id == 0:
                    code += f'\t\t["{ghost_name}"] = 0,\n'
                else:
                    code += f'\t\t["{ghost_name}"] = {asset_id},\n'
                    total_mapped += 1
            else:
                print(f"WARNING: Ghost #{idx} not in asset_ids.json")

        code += "\n"

    code += "\t},\n"
    return code, total_mapped

def read_ghostdata():
    """Read existing GhostData.lua file"""
    if not os.path.exists(GHOSTDATA_FILE):
        print(f"ERROR: {GHOSTDATA_FILE} not found!")
        return None

    with open(GHOSTDATA_FILE, 'r', encoding='utf-8') as f:
        return f.read()

def replace_ghostimages_table(ghostdata_content, new_table):
    """Replace the GhostImages table in GhostData.lua"""
    # Find the start and end of GhostImages table
    start_marker = "\tGhostImages = {"
    end_marker = "\t},"

    start_idx = ghostdata_content.find(start_marker)
    if start_idx == -1:
        print("ERROR: Could not find GhostImages table in GhostData.lua")
        return None

    # Find the end (look for the closing bracket at same indentation level)
    end_idx = ghostdata_content.find(end_marker, start_idx)
    if end_idx == -1:
        print("ERROR: Could not find end of GhostImages table")
        return None

    end_idx += len(end_marker)

    # Replace the table
    new_content = ghostdata_content[:start_idx] + new_table + ghostdata_content[end_idx:]
    return new_content

def main():
    print("=== GhostData.lua Asset ID Mapper ===\n")

    # Step 1: Load asset IDs
    print("1. Loading asset IDs from ghost_asset_ids.json...")
    asset_ids = load_asset_ids()
    if not asset_ids:
        return

    # Step 2: Generate new GhostImages table
    print("2. Generating GhostImages table...")
    new_table, total_mapped = generate_ghostimages_table(asset_ids)
    print(f"   ✓ Generated table with {total_mapped} mapped assets\n")

    # Step 3: Read existing GhostData.lua
    print("3. Reading GhostData.lua...")
    ghostdata_content = read_ghostdata()
    if not ghostdata_content:
        return

    # Step 4: Replace the table
    print("4. Replacing GhostImages table...")
    updated_content = replace_ghostimages_table(ghostdata_content, new_table)
    if not updated_content:
        return

    # Step 5: Backup and save
    print("5. Saving updated GhostData.lua...")

    # Create backup
    if os.path.exists(GHOSTDATA_FILE):
        import shutil
        shutil.copy(GHOSTDATA_FILE, GHOSTDATA_BACKUP)
        print(f"   ✓ Backup saved to: {GHOSTDATA_BACKUP}")

    # Save updated file
    with open(GHOSTDATA_FILE, 'w', encoding='utf-8') as f:
        f.write(updated_content)

    print(f"   ✓ Updated: {GHOSTDATA_FILE}\n")

    # Summary
    print("="*50)
    print("SUCCESS! GhostData.lua has been updated")
    print("="*50)
    print(f"\nMapped assets: {total_mapped}/120")
    print(f"\nNext steps:")
    print("1. Copy the updated GhostData.lua into Roblox Studio")
    print("2. Spawn ghosts and verify images display correctly")
    print("3. Test with both transparent and opaque backgrounds")
    print("\nOld GhostData.lua backed up to:")
    print(f"  {GHOSTDATA_BACKUP}")

if __name__ == "__main__":
    main()
