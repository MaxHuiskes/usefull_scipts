import subprocess
import os
import uuid
from flask import Flask, render_template, request, send_file, after_this_request

app = Flask(__name__)

SCAD_FILE = "screw_generator.scad"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    form = request.form
    
    # Logic for Nut Thickness
    raw_thick = form.get("nut_thickness", "normal")
    nut_val = form.get("nut_custom_thickness", "5") if raw_thick == "custom" else f'"{raw_thick}"'

    # Mapping ALL fields from your HTML
    params = {
        "Spec": f'"{form.get("spec", "M5")}"',
        "Display": f'"{form.get("display", "screw")}"',
        "Thread": f'"{form.get("thread", "coarse")}"',
        "Pitch": form.get("pitch", "1.0"),
        "Nut_Style": f'"{form.get("nut_style", "standard")}"', # Matches your SCAD
        "Screw_Length": form.get("length", "16"),
        "Screw_Head": f'"{form.get("head", "hex")}"',
        "Screw_Drive": f'"{form.get("drive", "none")}"',
        "Screw_Split": form.get("screw_split", "false"),
        "Screw_Undersize": form.get("screw_undersize", "0.0"),
        "Nut_Shape": f'"{form.get("nut_shape", "hex")}"',
        "Nut_Thickness": nut_val, # Category string OR custom number
        "Nut_Clearance": form.get("nut_clearance", "0.1"),
        "Nut_Bevel": f'"{form.get("nut_bevel", "auto")}"',
        "Nut_Flush": form.get("nut_flush", "false"),
        "Nut_Width": form.get("nut_width", "0"),
        "Washer_Size": f'"{form.get("washer_size", "regular")}"',
        "Resolution": form.get("resolution", "3")
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

        d_name = params['Display'].replace('"', '')
        s_name = params['Spec'].replace('"', '')
        return send_file(stl_path, as_attachment=True, download_name=f"{d_name}_{s_name}.stl")

    except subprocess.CalledProcessError as e:
        return f"Render Error: {e.stderr}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)