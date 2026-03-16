import trimesh, numpy as np, os, sys
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def make_shot():
    r, h, thick = 22.5, 60, 2.0
    ox, oy = [r*0.85, r, r], [0, 0, h]
    ix, iy = [0, r-thick, r-thick], [8, 8, h]
    px = [0] + ox + ix[::-1] + [0]
    py = [0] + oy + iy[::-1] + [iy[0]]
    trimesh.creation.revolve(np.column_stack((px, py)), sections=100).export("shot.stl")
    print("shot.stl generated.")

make_shot()