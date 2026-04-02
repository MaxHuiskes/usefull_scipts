import streamlit as st
from solid2 import *
import subprocess
import os

st.set_page_config(page_title="Bottle Shelf Cradle")
st.title("🍾 Shelf Bottle Cradle")

# UI Controls
st.sidebar.header("Dimensions (mm)")
bottle_dia = st.sidebar.slider("Bottle Diameter", 60, 120, 85)
holder_len = st.sidebar.slider("Length (Depth)", 20, 200, 100)
wall_width = st.sidebar.slider("Wall Thickness (Side)", 2, 20, 5)
base_height = st.sidebar.slider("Height under Bottle", 2, 20, 5)

def generate_stl(d, l, side_wall, bottom_floor):
    # Calculations
    inner_r = d / 2
    outer_width = d + (side_wall * 2)
    # Total height = radius of bottle + the floor thickness
    total_height = inner_r + bottom_floor
    
    # 1. Create the solid base block
    base_block = cube([outer_width, l, total_height])
    
    # 2. Create the "Drill" cylinder (the bottle space)
    # We position it so it sits exactly 'bottom_floor' above the bottom
    drill = cylinder(r=inner_r, h=l + 2, _fn=120)
    
    # Rotate the drill to lie flat and center it horizontally
    # We move it up so it carves out the top of the block
    drill = drill.rotateX(90).translate([outer_width/2, l + 1, total_height])
    
    # 3. The Result: Block minus the Cylinder
    final_shape = base_block - drill
    
    # Save and Render
    final_shape.save_as_scad("temp.scad")
    subprocess.run(["openscad", "-o", "output.stl", "temp.scad"], check=True)

if st.button("Generate STL"):
    try:
        generate_stl(bottle_dia, holder_len, wall_width, base_height)
        with open("output.stl", "rb") as file:
            st.download_button(
                label="📥 Download STL",
                data=file,
                file_name=f"cradle_{bottle_dia}mm.stl",
                mime="application/sla"
            )
        st.success("Generated! Ready to print.")
    except Exception as e:
        st.error(f"Render failed: {e}")