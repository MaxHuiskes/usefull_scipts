import streamlit as st
import subprocess
import os
from streamlit_stl import stl_from_file

st.set_page_config(page_title="Modular Skeleton Rack Gen", layout="wide")

# Title and Layout
st.title("🍾 Modular Skeleton Rack Configurator")
col1, col2 = st.columns([1, 2])

with col1:
    st.header("Settings")
    part_type = st.selectbox("Part to Render", ["core", "flat_spacer", "dovetail_male", "dovetail_female"])
    
    # Common Dimensions
    internal_size = st.number_input("Internal Hole (mm)", value=90)
    depth = st.number_input("Depth (mm)", value=120)
    
    # Keep wall thick enough so fixed dovetails do not break into the core cavity.
    wall = st.number_input("Skeleton Wall Thickness (mm)", min_value=6, value=8)
    
    # NEW: Skeleton Control
    skeleton_factor = st.slider("Skeleton Density (0.1 = Thin, 0.9 = Near-Solid)", 0.1, 0.9, 0.25, step=0.05)

    st.subheader("Dovetail Per Side")
    side_options = ["none", "male", "female"]
    dt_left = st.selectbox("Left Side", side_options, index=2)
    dt_right = st.selectbox("Right Side", side_options, index=1)
    dt_top = st.selectbox("Top Side", side_options, index=1)
    dt_bottom = st.selectbox("Bottom Side", side_options, index=2)

    # Part Specifics
    if part_type == "core":
        core_shape = st.radio("Shape", ["bottle", "box"])
        spacer_width = 0
    elif part_type == "flat_spacer":
        core_shape = "bottle"
        spacer_width = st.number_input("Spacer/Extension Width (mm)", value=25)
    else:
        core_shape = "bottle"
        spacer_width = 25

    generate_btn = st.button("🔨 Generate Skeleton & Preview")

# OpenSCAD Logic
def generate_stl():
    output_file = "preview.stl"
    command = [
        "openscad", "-o", output_file,
        "-D", f'Part="{part_type}"',
        "-D", f"Internal_Size={internal_size}",
        "-D", f"Depth={depth}",
        "-D", f"Wall_Thickness={wall}",
        "-D", f"Skeleton_Factor={skeleton_factor}", # NEW PARAMETER
        "-D", f'Core_Type="{core_shape}"',
        "-D", f"Spacer_Width={spacer_width}",
        "-D", f'DT_Left="{dt_left}"',
        "-D", f'DT_Right="{dt_right}"',
        "-D", f'DT_Top="{dt_top}"',
        "-D", f'DT_Bottom="{dt_bottom}"',
        "generator.scad"
    ]
    subprocess.run(command)
    return output_file

with col2:
    st.header("3D Skeleton Preview")
    if generate_btn:
        with st.spinner("Rendering..."):
            file_path = generate_stl()
            if os.path.exists(file_path):
                # Using 'wireframe' view style makes the skeleton pop
                stl_from_file(file_path, color="#CCFF33", material="wireframe")
                
                with open(file_path, "rb") as f:
                    st.download_button(
                        label=f"💾 Download {part_type.title()} STL",
                        data=f,
                        file_name=f"{part_type}_skel_{int(skeleton_factor*100)}percent.stl",
                        mime="application/sla"
                    )
    else:
        st.info("Adjust settings and click 'Generate' to see the skeleton model.")