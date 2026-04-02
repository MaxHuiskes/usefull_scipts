import streamlit as st
from solid2 import *
import subprocess
import os

st.set_page_config(page_title="Multi-Bottle Shelf Rack")
st.title("🍾 Multi-Bottle Rack Generator")

# UI Controls
st.sidebar.header("Configuration")
num_bottles = st.sidebar.slider("Number of Bottles", 1, 10, 2)
bottle_dia = st.sidebar.slider("Bottle Diameter (mm)", 60, 120, 85)
holder_len = st.sidebar.slider("Depth (mm)", 50, 200, 100)
side_wall = st.sidebar.slider("Outer Wall (mm)", 2, 20, 5)
spacing = st.sidebar.slider("Gap between bottles (mm)", 0, 20, 5)
base_floor = st.sidebar.slider("Floor Thickness (mm)", 2, 20, 5)

def generate_multi_stl(count, d, l, wall, gap, floor):
    inner_r = d / 2
    total_width = (wall * 2) + (d * count) + (gap * (count - 1))
    total_height = inner_r + floor
    
    # 1. Create Base
    base_block = cube([total_width, l, total_height])
    
    # 2. Create Drills
    drills = []
    for i in range(count):
        x_pos = wall + inner_r + (i * (d + gap))
        # Cylinder for the bottle
        c = cylinder(r=inner_r, h=l + 2, _fn=120)
        c = c.rotateX(90).translate([x_pos, l + 1, total_height])
        drills.append(c)
    
    # 3. Combine
    # Using union() explicitly instead of sum() to avoid 'blank' type errors
    all_drills = union()(*drills)
    final_shape = base_block - all_drills
    
    # 4. Save and Render
    scad_path = "/tmp/temp.scad"
    stl_path = "/tmp/output.stl"
    
    final_shape.save_as_scad(scad_path)
    
    # Run OpenSCAD with full error reporting
    result = subprocess.run(
        ["openscad", "-o", stl_path, scad_path],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        raise Exception(f"OpenSCAD Error: {result.stderr}")
    
    return stl_path

if st.button("Generate STL"):
    try:
        path = generate_multi_stl(num_bottles, bottle_dia, holder_len, side_wall, spacing, base_floor)
        
        if os.path.exists(path):
            with open(path, "rb") as file:
                st.download_button(
                    label="📥 Download STL",
                    data=file,
                    file_name="bottle_rack.stl",
                    mime="application/sla"
                )
            st.success("Success!")
    except Exception as e:
        # This will now show you EXACTLY what went wrong
        st.error(f"Detailed Error: {str(e)}")