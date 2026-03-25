import os
import re
import subprocess
import uuid

from flask import Flask, after_this_request, render_template, request, send_file

app = Flask(__name__)

SCAD_FILE = "dies_gen.scad"

DIE_MAX_SIDE = {
    "d4": 4,
    "d6": 6,
    "d8": 8,
    "d10": 10,
    "d12": 12,
    "d20": 20,
    "d100": 100,
    "d30": 30,
    "d24": 24,
    "d48": 48,
    "d12_rhombic": 12,
}


def scad_bool(name, default="false"):
    v = request.form.get(name)
    if v is None:
        return default
    return "true" if str(v).lower() in ("true", "on", "1", "yes") else "false"


def scad_color(raw, fallback="#00a0ff"):
    s = (raw or fallback).strip()
    if not re.match(r"^#[0-9A-Fa-f]{6}$", s):
        s = fallback
    return f'"{s}"'


def scad_float(name, default, min_v=None, max_v=None):
    try:
        x = float(request.form.get(name, default))
    except (TypeError, ValueError):
        x = float(default)
    if min_v is not None:
        x = max(min_v, x)
    if max_v is not None:
        x = min(max_v, x)
    return str(x)


def scad_int(name, default, min_v=1, max_v=512):
    try:
        n = int(float(request.form.get(name, default)))
    except (TypeError, ValueError):
        n = int(default)
    return str(max(min_v, min(max_v, n)))


def scad_quoted_string(s):
    t = s.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{t}"'


def scad_string_array(strings):
    return "[" + ",".join(scad_quoted_string(s) for s in strings) + "]"


def scad_num_array(nums):
    return "[" + ",".join(str(float(x)) for x in nums) + "]"


def _bounded_float(form, key, default, lo, hi):
    try:
        x = float(form.get(key, default))
    except (TypeError, ValueError):
        x = float(default)
    return max(lo, min(hi, x))


def form_float(key, default, min_v=None, max_v=None):
    try:
        x = float(request.form.get(key, default))
    except (TypeError, ValueError):
        x = float(default)
    if min_v is not None:
        x = max(min_v, x)
    if max_v is not None:
        x = min(max_v, x)
    return str(x)


def add_face_params(params, die_key, form):
    n = DIE_MAX_SIDE.get(die_key, 20)
    use_face_vectors = n > 20

    if use_face_vectors:
        labels = []
        graphics = []
        sizes = []
        fonts = []
        font_styles = []
        svg_names = []
        svg_scales = []
        ox_list = []
        oy_list = []
        rots = []
        for i in range(1, n + 1):
            p = f"side{i}_"
            labels.append((form.get(f"{p}text") or "").strip())
            g = (form.get(f"{p}graphic") or "text").strip().lower()
            graphics.append(g if g in ("text", "svg") else "text")
            ts_raw = (form.get(f"{p}text_size") or "").strip()
            try:
                sizes.append(float(ts_raw) if ts_raw else -0.1)
            except ValueError:
                sizes.append(-0.1)
            fonts.append((form.get(f"{p}font") or "default").strip() or "default")
            font_styles.append((form.get(f"{p}font_style") or "default").strip() or "default")
            svg_names.append((form.get(f"{p}svg") or "default.svg").strip() or "default.svg")
            svg_scales.append(_bounded_float(form, f"{p}svg_scale", "0.025", 0.001, 10))
            ox_list.append(_bounded_float(form, f"{p}offset_x", "0", -10, 10))
            oy_list.append(_bounded_float(form, f"{p}offset_y", "0", -10, 10))
            rots.append(_bounded_float(form, f"{p}rotation", "0", -360, 360))
        params["face_label_vector"] = scad_string_array(labels)
        params["face_graphic_vector"] = scad_string_array(graphics)
        params["face_text_size_vector"] = scad_num_array(sizes)
        params["face_font_vector"] = scad_string_array(fonts)
        params["face_font_style_vector"] = scad_string_array(font_styles)
        params["face_svg_file_vector"] = scad_string_array(svg_names)
        params["face_svg_scale_vector"] = scad_num_array(svg_scales)
        params["face_offset_x_vector"] = scad_num_array(ox_list)
        params["face_offset_y_vector"] = scad_num_array(oy_list)
        params["face_rotation_vector"] = scad_num_array(rots)
        return

    for i in range(1, n + 1):
        p = f"side{i}_"
        raw_text = (form.get(f"{p}text") or "").strip()
        params[f"side{i}_text"] = (
            scad_quoted_string("default") if not raw_text else scad_quoted_string(raw_text)
        )

        g = (form.get(f"{p}graphic") or "text").strip().lower()
        if g not in ("text", "svg"):
            g = "text"
        params[f"side{i}_graphic"] = scad_quoted_string(g)

        ts_raw = (form.get(f"{p}text_size") or "").strip()
        if not ts_raw:
            params[f"side{i}_text_size"] = "-0.1"
        else:
            try:
                params[f"side{i}_text_size"] = str(float(ts_raw))
            except ValueError:
                params[f"side{i}_text_size"] = "-0.1"

        font = (form.get(f"{p}font") or "default").strip() or "default"
        params[f"side{i}_font"] = scad_quoted_string(font)

        fst = (form.get(f"{p}font_style") or "default").strip() or "default"
        params[f"side{i}_font_style"] = scad_quoted_string(fst)

        params[f"side{i}_svg_scale"] = form_float(f"{p}svg_scale", "0.025", 0.001, 10)

        ox = form_float(f"{p}offset_x", "0", -10, 10)
        oy = form_float(f"{p}offset_y", "0", -10, 10)
        params[f"side{i}_offset"] = f"[{ox},{oy}]"

        params[f"side{i}_rotation"] = form_float(f"{p}rotation", "0", -360, 360)

        svg_name = (form.get(f"{p}svg") or "default.svg").strip() or "default.svg"
        params[f"side{i}_svg"] = scad_quoted_string(svg_name)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/generate", methods=["POST"])
def generate():
    die_key = request.form.get("die", "d20")
    if die_key not in DIE_MAX_SIDE:
        die_key = "d20"

    ox = scad_float("cutout_loc_x", "0", -10, 10)
    oy = scad_float("cutout_loc_y", "0", -10, 10)

    params = {
        "die": f'"{die_key}"',
        "graphic_type": f'"{request.form.get("graphic_type", "cutout")}"',
        "die_diameter": scad_float("die_diameter", "30", 5, 200),
        "die_rounding": scad_float("die_rounding", "1", 0, 20),
        "die_color": scad_color(request.form.get("die_color"), "#00a0ff"),
        "default_text_size": scad_float("default_text_size", "4.3", 0.1, 100),
        "default_graphic_depth": scad_float("default_graphic_depth", "1", 0.01, 10),
        "graphic_color": scad_color(request.form.get("graphic_color"), "#505050"),
        "default_font": f'"{request.form.get("default_font", "Lora")}"',
        "default_font_style": f'"{request.form.get("default_font_style", "Bold")}"',
        "indicator_for_6_and_9": scad_bool("indicator_for_6_and_9", "false"),
        "offset_for_indicated_6_and_9": scad_float("offset_for_indicated_6_and_9", "0", -10, 10),
        "d10_0_indexed": scad_bool("d10_0_indexed", "true"),
        "d10_multiples_of_10": scad_bool("d10_multiples_of_10", "false"),
        "d10_height_ratio": scad_float("d10_height_ratio", "0.5", 0.5, 0.75),
        "numerically_balanced_d20": scad_bool("numerically_balanced_d20", "false"),
        "cutout_scale": scad_float("cutout_scale", "0.75", 0.1, 2),
        "cutout_size_offset": scad_float("cutout_size_offset", "0", -10, 10),
        "cutout_location_offset": f"[{ox},{oy}]",
        "$fn": scad_int("fn", "128", 16, 256),
        "comma_labels": scad_quoted_string((request.form.get("comma_labels") or "")[:25000]),
    }

    add_face_params(params, die_key, request.form)

    unique_id = str(uuid.uuid4())
    stl_path = f"/tmp/{unique_id}.stl"

    command = ["openscad", "-o", stl_path]
    for key, value in params.items():
        command.extend(["-D", f"{key}={value}"])
    command.append(SCAD_FILE)

    try:
        subprocess.run(command, check=True, capture_output=True, text=True)

        @after_this_request
        def cleanup(response):
            if os.path.exists(stl_path):
                os.remove(stl_path)
            return response

        d = params["die"].replace('"', "")
        return send_file(stl_path, as_attachment=True, download_name=f"{d}_die.stl")

    except subprocess.CalledProcessError as e:
        return f"Render Error: {e.stderr}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
