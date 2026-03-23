import subprocess
import os
import re
import uuid
from flask import Flask, render_template, request, send_file, after_this_request

app = Flask(__name__)

SCAD_FILE = "screw_generator.scad"


def scad_bool(name, default="false"):
    v = request.form.get(name)
    if v is None:
        return default
    return "true" if str(v).lower() in ("true", "on", "1", "yes") else "false"


def scad_color(raw):
    s = (raw or "#e2dede").strip()
    if not re.match(r"^#[0-9A-Fa-f]{6}$", s):
        s = "#e2dede"
    return f'"{s}"'


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/generate", methods=["POST"])
def generate():
    raw_thick = request.form.get("nut_thickness", "normal")
    if raw_thick == "custom":
        nut_thickness_scad = '"custom"'
        nut_custom = request.form.get("nut_custom_thickness", "5")
    else:
        nut_thickness_scad = f'"{raw_thick}"'
        nut_custom = request.form.get("nut_custom_thickness", "10")

    params = {
        "Spec": f'"{request.form.get("spec", "M5")}"',
        "Display": f'"{request.form.get("display", "screw")}"',
        "Thread": f'"{request.form.get("thread", "coarse")}"',
        "Pitch": request.form.get("pitch", "1.0"),
        "Nut_Style": f'"{request.form.get("nut_style", "standard")}"',
        "Screw_Length": request.form.get("length", "16"),
        "Screw_Head": f'"{request.form.get("head", "hex")}"',
        "Screw_Drive": f'"{request.form.get("drive", "none")}"',
        "Screw_Split": scad_bool("screw_split", "false"),
        "Screw_Undersize": request.form.get("screw_undersize", "0.0"),
        "Screw_Thread_Length": request.form.get("screw_thread_length", "0"),
        "Screw_Reorient": scad_bool("screw_reorient", "true"),
        "Nut_Shape": f'"{request.form.get("nut_shape", "hex")}"',
        "Nut_Thickness": nut_thickness_scad,
        "Nut_Custom_Thickness": nut_custom,
        "Nut_Clearance": request.form.get("nut_clearance", "0.1"),
        "Nut_Bevel": f'"{request.form.get("nut_bevel", "auto")}"',
        "Nut_Flush": scad_bool("nut_flush", "false"),
        "Nut_Width": request.form.get("nut_width", "0"),
        "Washer_Size": f'"{request.form.get("washer_size", "regular")}"',
        "Washer_Chamfer": request.form.get("washer_chamfer", "0"),
        "Washer_Outer_Diameter_Custom": request.form.get("washer_outer_d", "0"),
        "Washer_Thickness_Custom": request.form.get("washer_thickness", "0"),
        "Resolution": request.form.get("resolution", "3"),
        "Color": scad_color(request.form.get("color")),
        "Debug": scad_bool("debug", "false"),
    }

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

        d_name = params["Display"].replace('"', "")
        s_name = params["Spec"].replace('"', "")
        return send_file(stl_path, as_attachment=True, download_name=f"{d_name}_{s_name}.stl")

    except subprocess.CalledProcessError as e:
        return f"Render Error: {e.stderr}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
