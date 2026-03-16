# Useful Scripts

Personal collection of scripts and utilities, organized by category.

## Project Structure

| Folder | Description |
|--------|-------------|
| **Image_Processing/** | PNG→SVG conversion, bulk resize/convert |
| **Storage/** | File organization by type, zip splitting by size |
| **3d_Modeling/** | Trimesh-based STL glass models (martini, flute, whiskey, etc.) |
| **Notify/** | Website change monitoring with email alerts |
| **pdf/** | Merge PDFs from a folder |
| **git/** | Git activity check by date and author |

## Scripts

### Image_Processing
- **pngtosvg.py** — Converts PNG to SVG (multi-color, vtracer). Usage: `python pngtosvg.py [input.png]` (default: `input.png`).
- **bulk_image_resizer_converter.py** — Resizes images from `./input_images`, saves to `./output_images` (config: `MAX_WIDTH`, `TARGET_FORMAT`). Dependencies: Pillow.
- **requirements.txt** — `vtracer` (for pngtosvg).

### Storage
- **file_organizer.py** — Moves files in a directory into subfolders by extension (Images, Documents, Archives, etc.). Set `TARGET_DIR` in script.
- **zip_splitter.py** — Zips a folder into multiple archives with a max size (default 4 GB). Edit path and prefix in script: `zip_in_chunks('/path/to/folder', 'name_file', max_size_gb=3)`.

### 3d_Modeling
- Trimesh scripts that export STL glass models: `martini.py`, `flute.py`, `whiskey.py`, `margarita.py`, `coupe.py`, `shot.py`, `wine_glass.py`. Run any script to generate its `.stl`. Requires `trimesh`, `numpy`.

### Notify
- **website_change.py** — Polls a URL at an interval, emails on content change (hash-based). Configure `URL_TO_MONITOR`, `CHECK_INTERVAL`, and SMTP settings in script.

### pdf
- **PDF_merger.py** — Merges all PDFs in `./pdfs_to_merge` (alphabetically) into `merged_document.pdf`. Requires `PyPDF2`.

### git
- **gitcheck.sh** — Lists git activity for a given date and optional author in all repos under a directory. Skips `vendor/` and `contrib/`.
  - Usage: `./gitcheck.sh [-f] YYYY-MM-DD [directory] [username]`
  - `-f`: run `git fetch --all` in each repo before checking.

## Getting Started

1. Clone the repo and go to the script’s folder:
   ```bash
   git clone https://github.com/MaxHuiskes/usefull_scipts.git
   cd usefull_scipts/<category>
   ```
2. Install dependencies if needed (e.g. `pip install -r requirements.txt` in Image_Processing; PyPDF2 for pdf; trimesh/numpy for 3d_Modeling; requests for Notify).
3. Adjust config/paths in the script if required, then run it (e.g. `python script.py` or `./gitcheck.sh 2026-03-16 .`).

## Contributing

Personal repo; suggestions and PRs welcome.

---
*Created by Max*
