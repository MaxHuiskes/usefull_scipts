import sys
import os 
import numpy as np
import trimesh
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def generate_stl_glass(style="bordeaux", cup_dia=60, cup_len=80, stem_len=70, base_dia=55, filename="glass.stl"):
    thickness = 1.2
    r_cup = cup_dia / 2
    r_base = base_dia / 2
    
    # Style-specific geometry tweaks
    if style.lower() == "chardonnay":
        h_mult, w_mult, rim_cut = 1.6, 0.9, 0.7  # Taller, narrower
    elif style.lower() == "bordeaux":
        h_mult, w_mult, rim_cut = 1.1, 1.4, 0.5  # Squat, very wide
    else:
        h_mult, w_mult, rim_cut = 1.0, 1.0, 0.5

    # Create the bowl profile points
    # We generate a half-arc for the bowl
    angles = np.linspace(-np.pi/2, np.pi/2 * rim_cut, 50)
    
    # Outer profile
    outer_x = np.cos(angles) * r_cup * w_mult
    outer_y = np.sin(angles) * r_cup * h_mult + (r_cup * h_mult)
    
    # Inner profile (hollow)
    inner_x = np.cos(angles[::-1]) * (r_cup * w_mult - thickness)
    inner_y = np.sin(angles[::-1]) * (r_cup * h_mult - thickness) + (r_cup * h_mult)

    # Combine points into a single continuous line for revolution
    # Order: Inside Rim -> Inside Bottom -> Outside Bottom -> Outside Rim -> Stem -> Base
    px = [0] # Start at bottom center
    py = [outer_y[0]]
    
    # Add the bowl curve
    px.extend(outer_x)
    py.extend(outer_y)
    
    # Add thickness at the rim and go back down the inside
    px.extend(inner_x)
    py.extend(inner_y)
    
    # Close the bowl bottom
    px.append(0)
    py.append(inner_y[-1])
    
    # Now the Stem and Base (Solid)
    px.extend([2, 2, r_base, r_base, 0])
    py.extend([outer_y[0], -stem_len, -stem_len, -stem_len - 3, -stem_len - 3])
    
    profile = np.column_stack((px, py))

    # Revolve 360 degrees
    mesh = trimesh.creation.revolve(profile, sections=80)

    mesh.export(filename)
    print(f"Done! Created {style} glass: {filename}")

# --- TEST IT ---
generate_stl_glass(style="chardonnay", cup_dia=70, filename="chardonnay.stl")
generate_stl_glass(style="bordeaux", cup_dia=60, filename="bordeaux.stl")
generate_stl_glass(style="", cup_dia=60, filename="non.stl")
