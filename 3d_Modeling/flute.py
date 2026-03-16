import sys
import os
import trimesh
import numpy as np

# Pathing for Mac
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def generate_flute_stl(cup_dia=38, cup_len=135, stem_len=85, base_dia=60, filename="champagne_flute.stl"):
    thickness = 1.4
    r_cup = cup_dia / 2
    r_base = base_dia / 2
    taper = 0.95 
    
    # 1. BOWL PROFILE (U-shape)
    angles = np.linspace(-np.pi/2, 0, 30)
    bottom_x = np.cos(angles) * r_cup
    bottom_y = np.sin(angles) * r_cup + r_cup
    
    top_x = np.linspace(r_cup, r_cup * taper, 40)
    top_y = np.linspace(r_cup, cup_len, 40)
    
    outer_x = np.concatenate([bottom_x, top_x])
    outer_y = np.concatenate([bottom_y, top_y])
    
    inner_x = outer_x - thickness
    inner_y = outer_y + thickness
    inner_x = np.clip(inner_x, 0, None)

    # 2. STEM & BASE
    stem_r = 2.2
    base_h = 3.0
    
    # We build the full loop of the profile
    px = [0, r_base, r_base, stem_r, stem_r] + list(outer_x) + list(inner_x[::-1]) + [0]
    py = [-stem_len-base_h, -stem_len-base_h, -stem_len, -stem_len, 0] + list(outer_y) + list(inner_y[::-1]) + [inner_y[0]]
    
    profile = np.column_stack((px, py))

    # 3. REVOLVE
    # We don't call fix_normals() here to avoid the SciPy dependency
    mesh = trimesh.creation.revolve(profile, sections=100)
    
    # 4. EXPORT
    mesh.export(filename)
    print(f"--- SUCCESS: {filename} generated ---")

# --- RUN IT ---
generate_flute_stl(filename="perfect_flute.stl")