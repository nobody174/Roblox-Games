<!--
  Ghost Catcher Tycoon — Asset Conversion Guide
  Author:  nobody174 (nobodylearn174@gmail.com)
  Repo:    https://github.com/nobody174/roblox-games
  License: All rights reserved © 2025 nobody174
  "It's never too late to give up!"
-->

# Asset Conversion Guide: HTML → PNG

## Overview

Two asset files have been created as **interactive HTML canvases**:
- `assets/thumbnail.html` — 1024×1024px (for game thumbnail on Roblox)
- `assets/icon.html` — 512×512px (for game icon on Roblox)

These need to be **converted to PNG** before uploading to Roblox.

---

## Method 1: Browser Screenshot (Easiest)

### Step 1: Open the HTML File

1. Open **File Explorer**
2. Navigate to: `C:\Users\Vartd\OneDrive\Skrivebord\Learning AI\vscode\New projects\roblox-games\games\ghost-catcher-tycoon\assets\`
3. Right-click `thumbnail.html` → **Open with** → **Google Chrome** (or your browser)

### Step 2: Take Screenshot

**For Thumbnail:**
1. Press `F12` to open Developer Tools
2. Press `Ctrl+Shift+M` to enter Device Emulation mode
3. Set device size to **1024×1024**
4. Press `Ctrl+Shift+P` → type `Screenshot` → select "Capture full page screenshot"
5. Save as `thumbnail.png` to the assets folder

**For Icon:**
1. Same process, but set device size to **512×512**
2. Save as `icon.png` to the assets folder

---

## Method 2: Use Online Tool (Recommended)

### Step 1: Convert Online

1. Go to: **https://www.html2pdf.com/html-to-image** (or similar HTML→PNG converter)
2. Copy the HTML code from `thumbnail.html` and paste into the converter
3. Select **PNG** format, **1024×1024** dimensions
4. Click "Convert" and download as `thumbnail.png`
5. Repeat for `icon.html` with **512×512** dimensions

### Popular converters:
- https://www.html2pdf.com/html-to-image
- https://cloudconvert.com/html-to-png
- https://www.zamzar.com/convert/html-to-png/

---

## Method 3: Python (Programmatic)

If you have Python installed:

### Install Required Package

```powershell
pip install pillow selenium
```

### Create Conversion Script

```python
# convert_assets.py
from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import os

def convert_html_to_png(html_file, output_png, width, height):
    driver = webdriver.Chrome()  # Requires chromedriver
    
    # Load HTML file
    file_path = f"file:///{os.path.abspath(html_file)}"
    driver.get(file_path)
    
    # Set window size
    driver.set_window_size(width, height)
    time.sleep(2)
    
    # Take screenshot
    driver.save_screenshot(output_png)
    driver.quit()
    
    print(f"✅ Saved: {output_png}")

# Convert both assets
convert_html_to_png("thumbnail.html", "thumbnail.png", 1024, 1024)
convert_html_to_png("icon.html", "icon.png", 512, 512)
```

Run with:
```powershell
python convert_assets.py
```

---

## Method 4: Node.js (Alternative)

If you prefer Node.js:

```bash
npm install puppeteer
```

```javascript
// convert.js
const puppeteer = require('puppeteer');
const fs = require('fs');

async function convertToPng(htmlFile, outputFile, width, height) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  
  await page.setViewport({ width, height });
  await page.goto(`file://${__dirname}/${htmlFile}`);
  await page.screenshot({ path: outputFile, fullPage: false });
  
  await browser.close();
  console.log(`✅ Saved: ${outputFile}`);
}

(async () => {
  await convertToPng('thumbnail.html', 'thumbnail.png', 1024, 1024);
  await convertToPng('icon.html', 'icon.png', 512, 512);
})();
```

Run with:
```bash
node convert.js
```

---

## Method 5: Windows Print to PDF (Then Convert)

1. Open `thumbnail.html` in Edge/Chrome
2. Press `Ctrl+P` → Print
3. Choose "Print to PDF"
4. Use a PNG converter tool to convert PDF → PNG

---

## Quick Check: Asset Requirements

### Thumbnail (1024×1024px)
- ✅ Must be square (1024×1024)
- ✅ File format: PNG or JPG
- ✅ File size: < 20MB (usually < 1MB)
- ✅ Contains game title & ghost imagery
- ✅ Readable at small sizes (Roblox shows at ~200px)
- ✅ No watermarks or credits

### Icon (512×512px)
- ✅ Must be square (512×512)
- ✅ File format: PNG (supports transparency) or JPG
- ✅ File size: < 10MB (usually < 500KB)
- ✅ Recognizable ghost or vacuum design
- ✅ Works at thumbnail size (shows at ~100px)
- ✅ Good contrast on dark background

---

## Preview Your Assets

Once saved as PNG, check:
1. **Open in Paint/Preview** → Verify colors look good
2. **Check file size** → Should be small (< 2MB total)
3. **Check resolution** → Should be exactly 1024×1024 and 512×512
4. **Check visibility** → Text should be readable even when scaled down

**Quick test:**
- Thumbnail: Save as 200×200px and check readability
- Icon: Save as 100×100px and check recognizability

---

## Uploading to Roblox

Once you have PNG files:

1. Go to **Roblox.com** → **My Creations** → **Games**
2. Click your game (Ghost Catcher Tycoon)
3. Click **Configure** → **Basic Settings**
4. Scroll to **Thumbnail** section
5. Click **Upload Image** and select `thumbnail.png`
6. Click **Upload Image** and select `icon.png` (if icon section exists)
7. Click **Save**

**Note:** Roblox may take 5-15 minutes to process the images.

---

## Visual Preview (What You'll See)

### Thumbnail Elements:
```
┌─────────────────────────────────┐
│     [Dark Purple/Blue BG]        │
│          [⭐ Stars]              │
│                                 │
│    ⚡ [Purple Ghost] ⚡          │
│   [Pink] ✨ [Cyan]             │
│                                 │
│        GHOST CATCHER ✨         │
│           TYCOON                │
│                                 │
│      [Decorative Borders]       │
└─────────────────────────────────┘
```

### Icon Elements:
```
┌─────────────────────────────────┐
│   [Radial Purple→Blue Gradient] │
│                                 │
│      🟡 ⚡ 🟣 ⚡ 🟡             │
│           [Ghost]               │
│        [Big Eyes]               │
│     💫 [Happy Smile] 💫         │
│     [Wavy Ghost Bottom]         │
│        🔵 [Cyan Orb]            │
│                                 │
│      [Circular Border]          │
│     [Corner Accents]            │
└─────────────────────────────────┘
```

---

## Troubleshooting

### Issue: Image looks blurry
**Solution:** Ensure you're capturing at the exact size (1024×1024, 512×512), not scaling afterwards.

### Issue: Text is hard to read
**Solution:** The colors are intentionally bright (cyan, magenta, yellow on dark). This is high-contrast for mobile visibility.

### Issue: Colors don't match preview
**Solution:** Different browsers render canvas colors differently. Use Chrome for best consistency.

### Issue: Roblox won't accept the image
**Solution:** 
- Check file format (must be PNG or JPG)
- Check dimensions (exactly 1024×1024 or 512×512)
- Check file size (< 20MB)
- Try JPG instead of PNG
- Re-save at highest quality

---

## Asset Files Location

```
roblox-games/
├── games/
│   └── ghost-catcher-tycoon/
│       ├── assets/
│       │   ├── thumbnail.html      ← Source (convert to PNG)
│       │   ├── thumbnail.png        ← Output (after conversion)
│       │   ├── icon.html            ← Source (convert to PNG)
│       │   └── icon.png             ← Output (after conversion)
│       ├── ASSET_CONVERSION_GUIDE.md (this file)
│       └── ... (other game files)
```

---

## Next Steps After Conversion

1. ✅ Convert `thumbnail.html` → `thumbnail.png`
2. ✅ Convert `icon.html` → `icon.png`
3. ✅ Verify both PNG files are correct size & format
4. ✅ Upload to Roblox (see instructions above)
5. ✅ Monitor game appearance on Roblox homepage

---

## Support

**Recommendations:**
- Method 1 (Browser Screenshot) — Fastest if you're comfortable with DevTools
- Method 2 (Online Tool) — Easiest if you don't have local tools
- Method 3 (Python) — Most reliable if you have Python installed

**Questions about the design?**
- Thumbnail: Highlights game title, multiple ghosts, electric theme
- Icon: Focus on main character (ghost), glowing effects, recognizable at small size

All designs follow Roblox best practices:
- ✅ High contrast (light text on dark background)
- ✅ Readable at small sizes (mobile-friendly)
- ✅ Bright colors (attention-grabbing)
- ✅ Thematic (purple/blue for spooky, ghosts prominent)

---

**Contact:** nobodylearn174@gmail.com  
**Repository:** https://github.com/nobody174/roblox-games

Built with Claude Code by Anthropic.
