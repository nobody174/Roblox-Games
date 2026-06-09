#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Bulk upload all 120 ghost images to Roblox and generate GhostData.lua mapping.
Requires: roblox-py (pip install robloxapi)
"""

import os
import json
import re
import sys
from pathlib import Path

# Fix Windows encoding
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# Configuration
GHOST_IMAGES_DIR = r"C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\AI img creator\ghost_output"
OUTPUT_DIR = r"C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon"
GHOSTDATA_FILE = os.path.join(OUTPUT_DIR, "src", "shared", "GhostData.lua")
ASSET_IDS_FILE = os.path.join(OUTPUT_DIR, "ghost_asset_ids.json")

def extract_ghost_name(filename):
    """Extract ghost name from filename like 'ghost_001_Captain_Wisp.png'"""
    # Remove extension
    name_part = filename.replace(".png", "")
    # Remove ghost_XXX_ prefix
    name_part = re.sub(r"^ghost_\d{3}_", "", name_part)
    # Replace underscores with spaces
    name_part = name_part.replace("_", " ")
    return name_part

def get_all_ghost_files():
    """Get list of all ghost PNG files sorted by ID"""
    files = []
    for file in sorted(os.listdir(GHOST_IMAGES_DIR)):
        if file.endswith(".png") and file.startswith("ghost_"):
            filepath = os.path.join(GHOST_IMAGES_DIR, file)
            ghost_name = extract_ghost_name(file)
            files.append((file, filepath, ghost_name))
    return files

def generate_ghostdata_mapping(asset_ids):
    """Generate the GhostImages table for GhostData.lua"""
    lua_code = "\t-- Image asset IDs — uploaded via bulk_upload_ghosts.py\n"
    lua_code += "\tGhostImages = {\n"

    # Group by rarity for readability
    rarities = {
        "Common": list(range(1, 41)),      # 1-40
        "Uncommon": list(range(41, 71)),   # 41-70
        "Rare": list(range(71, 91)),       # 71-90
        "Epic": list(range(91, 106)),      # 91-105
        "Legendary": list(range(106, 116)), # 106-115
        "Corrupted": list(range(116, 121)) # 116-120
    }

    for rarity, ghost_ids in rarities.items():
        lua_code += f"\t\t-- {rarity}\n"
        for idx in ghost_ids:
            if idx in asset_ids:
                ghost_name = asset_ids[idx]["name"]
                asset_id = asset_ids[idx]["asset_id"]
                if asset_id == 0:
                    lua_code += f'\t\t["{ghost_name}"] = 0,\n'
                else:
                    lua_code += f'\t\t["{ghost_name}"] = {asset_id},\n'
        lua_code += "\n"

    lua_code += "\t},\n"
    return lua_code

def main():
    print("=== Ghost Image Bulk Upload Tool ===\n")

    # Step 1: Get all ghost files
    ghost_files = get_all_ghost_files()
    print(f"Found {len(ghost_files)} ghost PNG files")

    if len(ghost_files) != 120:
        print(f"ERROR: Expected 120 files, found {len(ghost_files)}")
        return

    # Step 2: Display file list (first 5 + last 5)
    print("\nFirst 5 ghosts:")
    for i, (file, filepath, name) in enumerate(ghost_files[:5], 1):
        print(f"  {i}. {name}")

    print("  ...")
    print("\nLast 5 ghosts:")
    for i, (file, filepath, name) in enumerate(ghost_files[-5:], len(ghost_files)-4):
        print(f"  {i}. {name}")

    # Step 3: Instructions for uploading
    print("\n" + "="*50)
    print("MANUAL UPLOAD INSTRUCTIONS:")
    print("="*50)
    print("""
To upload these images to Roblox:

1. Visit: https://www.roblox.com/develop/assets
2. Click "Create" → "Image"
3. For each ghost image:
   - Select the PNG file from: """ + GHOST_IMAGES_DIR + """
   - Upload and note the asset ID
   - Add to the mapping below

4. Once you have all asset IDs, create a JSON file with:
   {
     "1": {"name": "Captain Wisp", "asset_id": 123456789},
     "2": {"name": "Jolly Specter", "asset_id": 987654321},
     ...
   }

5. Run this script again with the JSON file to update GhostData.lua

ALTERNATIVE: Use Roblox CLI or upload via script API (if available)
""")

    # Step 4: Create template JSON
    template = {}
    for i, (file, filepath, name) in enumerate(ghost_files, 1):
        template[str(i)] = {
            "name": name,
            "asset_id": 0  # To be filled in after upload
        }

    # Save template
    with open(ASSET_IDS_FILE, "w") as f:
        json.dump(template, f, indent=2)

    print(f"\nTemplate JSON created: {ASSET_IDS_FILE}")
    print("Edit this file with the asset IDs after uploading images to Roblox.")

if __name__ == "__main__":
    main()
