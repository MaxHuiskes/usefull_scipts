# Bottle Rack Generator

Streamlit + OpenSCAD generator for modular bottle/box rack parts with configurable skeleton walls and per-side dovetail connectors.

## Features

- Generate `core` and `flat_spacer` parts
- Generate standalone connector test parts: `dovetail_male`, `dovetail_female`
- Per-side dovetail selection for each side:
  - `none`
  - `male` (outward connector)
  - `female` (socket cut)
- Select core hole shape:
  - `bottle` (cylindrical)
  - `box` (square)
- Adjustable skeleton density and wall thickness
- STL preview and download in Streamlit

## Files

- `app.py` - Streamlit UI and OpenSCAD invocation
- `generator.scad` - Parametric geometry
- `Dockerfile` - Containerized runtime

## Local Run

Requirements:

- Python 3.9+
- OpenSCAD installed and available as `openscad` in PATH

Install and run:

```bash
pip install streamlit streamlit-stl
streamlit run app.py
```

Open:

- [http://localhost:8501](http://localhost:8501)

## Docker Run

From this folder:

```bash
docker build -t bottle-rack-gen .
docker run --rm -p 8501:8501 bottle-rack-gen
```

Open:

- [http://localhost:8501](http://localhost:8501)

## How Connector Sides Work

For `core` and `flat_spacer`, set each side independently:

- `Left Side`
- `Right Side`
- `Top Side`
- `Bottom Side`

Each side can be:

- `none` - no connector on that side
- `male` - protruding dovetail
- `female` - dovetail socket

## Fit Tuning

In `generator.scad`:

- `DT_Width` - connector width (fixed)
- `DT_Height` - connector depth (fixed)
- `Clearance` - fit tolerance between male and female

Typical adjustment:

- Too tight: increase `Clearance` (example: `0.2` -> `0.3`)
- Too loose: decrease `Clearance` (example: `0.2` -> `0.15`)

## Notes

- Male dovetails are oriented outward on all sides.
- Box and bottle core cutouts both use full-depth subtraction.
- Dovetail dimensions stay constant and do not scale with wall thickness.
- UI enforces minimum wall thickness of `6` mm for structural safety.
- If Docker shows old behavior, rebuild with no cache:

```bash
docker build --no-cache -t bottle-rack-gen .
```
