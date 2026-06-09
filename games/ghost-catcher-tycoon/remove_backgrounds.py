#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Remove white/opaque backgrounds from ghost PNG images, making them transparent.
Uses PIL to detect and remove background colors.
"""

import os
import sys
from pathlib import Path
from PIL import Image
import numpy as np

# Configuration
INPUT_DIR = r"C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\AI img creator\ghost_output"
OUTPUT_DIR = r"C:\Users\Vartd\Desktop\Learning AI\vscode\New projects\AI img creator\ghost_output_transparent"

# Fix Windows encoding
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

def ensure_output_dir():
    """Create output directory if it doesn't exist"""
    Path(OUTPUT_DIR).mkdir(parents=True, exist_ok=True)
    print(f"Output directory: {OUTPUT_DIR}")

def remove_white_background(image_path, output_path, threshold=240):
    """
    Remove white/light background from image and make it transparent.

    Args:
        image_path: Path to input PNG
        output_path: Path to output PNG
        threshold: Brightness threshold for background detection (0-255)
    """
    try:
        # Open image
        img = Image.open(image_path)

        # Convert to RGBA if needed
        if img.mode != 'RGBA':
            img = img.convert('RGBA')

        # Get image data as numpy array
        data = np.array(img)

        # Calculate brightness for each pixel (R+G+B)/3
        brightness = (data[:,:,0].astype(float) + data[:,:,1].astype(float) + data[:,:,2].astype(float)) / 3

        # Identify light pixels (likely background)
        # Make them transparent by setting alpha to 0
        light_mask = brightness > threshold
        data[light_mask, 3] = 0  # Set alpha channel to 0

        # Create new image with transparent background
        result = Image.fromarray(data)

        # Save as PNG
        result.save(output_path, 'PNG')
        return True

    except Exception as e:
        print(f"  ERROR: {e}")
        return False

def main():
    print("=== Remove White Backgrounds from Ghost Images ===\n")

    # Ensure output directory exists
    ensure_output_dir()

    # Get all PNG files
    png_files = sorted([f for f in os.listdir(INPUT_DIR) if f.endswith('.png') and f.startswith('ghost_')])

    if not png_files:
        print("ERROR: No ghost PNG files found!")
        return

    print(f"Found {len(png_files)} ghost images\n")

    # Process each image
    success_count = 0
    for i, filename in enumerate(png_files, 1):
        input_path = os.path.join(INPUT_DIR, filename)
        output_path = os.path.join(OUTPUT_DIR, filename)

        # Show progress
        if i % 10 == 1:
            print(f"Processing: {i}-{min(i+9, len(png_files))}/{len(png_files)}")

        # Remove background
        if remove_white_background(input_path, output_path, threshold=240):
            success_count += 1
        else:
            print(f"  Failed: {filename}")

    print(f"\nComplete! {success_count}/{len(png_files)} images processed successfully")
    print(f"\nTransparent images saved to: {OUTPUT_DIR}")
    print("\nNext steps:")
    print("1. Copy all files from ghost_output_transparent/ to your upload folder")
    print("2. Upload to Roblox using https://www.roblox.com/develop/assets")
    print("3. Note the asset IDs and fill ghost_asset_ids.json")

if __name__ == "__main__":
    main()
