# Tabletop dice STL generator

Web UI that drives [OpenSCAD](https://openscad.org/) with [BOSL2](https://github.com/revarbat/BOSL2) to export **polyhedral dice** as STL files for 3D printing (based on [Lerch’s dice generator](https://makerworld.com/en/models/739273)).

## What it does

- **Flask** serves a form at `/` and POSTs parameters to `/generate`.
- **OpenSCAD** renders `dies_gen.scad` with `-D` overrides; output is a temporary STL returned as a download (`{die}_die.stl`, e.g. `d20_die.stl`).
- **BOSL2** is vendored under `BOSL2/`; `OPENSCADPATH` must include the project root so `include <BOSL2/...>` resolves.

The form covers die type, graphic mode, size/rounding, default text/font/colors, **per-face Side1–SideN** text (and optional graphic type, size, font, SVG path/scale, offset, rotation), d10/d20 options, cutout tweaks, and `$fn`. Only sides used by the selected die are passed to OpenSCAD; unused sides keep `dies_gen.scad` defaults.

## Run with Docker

From this directory (with `BOSL2/` present):

```bash
docker build -t project_dies .
docker run -p 5000:5000 project_dies
```

Open http://localhost:5000

## Run locally

Requirements:

- OpenSCAD installed and `openscad` on your `PATH`
- Python 3.10+ recommended

```bash
cd /path/to/project_dies
pip install flask
export OPENSCADPATH="$(pwd)"
python app.py
```

Open http://127.0.0.1:5000

## Project layout

| Path | Role |
|------|------|
| `app.py` | Flask app, invokes `openscad` |
| `dies_gen.scad` | Model parameters and geometry |
| `templates/index.html` | Web form |
| `BOSL2/` | BOSL2 library (required for SCAD) |
| `Dockerfile` | Image with Python, Flask, OpenSCAD, and `OPENSCADPATH=/app` |

## Troubleshooting

- **500 / Render Error**: OpenSCAD stderr is returned in the response body.
- **BOSL2 not found**: Ensure `OPENSCADPATH` is the directory that contains `BOSL2/` (the Dockerfile sets this automatically).
