import trimesh, numpy as np, os, sys
# Pathing for Apple Silicon Macs
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def make_martini():
    # Dimensions
    r_rim = 50       
    h_bowl = 60      
    s_len = 80       
    b_dia = 70       
    thick = 2.0      
    stem_r = 4.0     # Thicker stem
    
    # THE REVOLVE PROFILE
    # We are drawing the RIGHT SIDE of the glass silhouette
    # [Radius (X), Height (Z)]
    
    profile = np.array([
        [0, -s_len - 3],           # Bottom Center
        [b_dia/2, -s_len - 3],     # Base Edge Bottom
        [b_dia/2, -s_len],         # Base Edge Top
        [stem_r, -s_len],          # Stem Bottom
        [stem_r, 5],               # Stem Top (Extends ABOVE the bowl start)
        [r_rim, h_bowl],           # Outer Rim
        [r_rim - thick, h_bowl],   # Inner Rim
        [0, thick + 5],            # Inner Floor (Inside the cup)
        [0, -s_len - 3]            # Back to Start
    ])

    # Generate the mesh
    # 120 sections for high quality
    mesh = trimesh.creation.revolve(profile, sections=120)
    
    # Export
    mesh.export("martini_solid.stl")
    print("--- SUCCESS: martini_solid.stl generated ---")
    print("The stem now extends into the bowl base to ensure a solid connection.")

if __name__ == "__main__":
    make_martini()