# Screw / nut / washer STL generator

Web UI that drives [OpenSCAD](https://openscad.org/) with [BOSL2](https://github.com/revarbat/BOSL2) to export metric and inch **screws**, **nuts**, or **washers** as STL files for 3D printing.

## What it does

- **Flask** serves a form at `/` and POSTs parameters to `/generate`.
- **OpenSCAD** renders `screw_generator.scad` with `-D` overrides; output is a temporary STL returned as a download (`{display}_{spec}.stl`, e.g. `screw_M5.stl`).
- **BOSL2** is vendored under `BOSL2/`; `OPENSCADPATH` must include the project root so `include <BOSL2/...>` resolves.

Configurable options (via the form) include fastener spec (M2–M20, #4–3/4, etc.), display mode (screw / nut / washer), thread style and pitch, screw length/head/drive/split/undersize, nut shape/style/thickness/clearance/bevel, washer size, and mesh resolution.

## Run with Docker

From this directory:

```bash
docker build -t project_screw .
docker run -p 5000:5000 project_screw
```

Open http://localhost:5000

## Run locally

Requirements:

- OpenSCAD installed and `openscad` on your `PATH`
- Python 3.10+ recommended

```bash
cd /path/to/project_screw
pip install flask
export OPENSCADPATH="$(pwd)"   # so BOSL2 is found
python app.py
```

Open http://127.0.0.1:5000

## Project layout

| Path | Role |
|------|------|
| `app.py` | Flask app, invokes `openscad` |
| `screw_generator.scad` | Model parameters and geometry |
| `templates/index.html` | Web form |
| `BOSL2/` | BOSL2 library (required for SCAD) |
| `Dockerfile` | Image with Python, Flask, OpenSCAD, and `OPENSCADPATH=/app` |

## Troubleshooting

- **500 / Render Error**: OpenSCAD stderr is returned in the response body; check unsupported spec/option combinations.
- **BOSL2 not found**: Ensure `OPENSCADPATH` is the directory that contains `BOSL2/` (the Dockerfile sets this automatically).
