import trimesh, numpy as np, os, sys
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def make_whiskey():
    r, h, thick = 42.5, 95, 2.2
    ox, oy = [r*0.95, r, r], [0, 0, h]
    ix, iy = [0, r-thick, r-thick], [10, 10, h]
    px = [0] + ox + ix[::-1] + [0]
    py = [0] + oy + iy[::-1] + [iy[0]]
    trimesh.creation.revolve(np.column_stack((px, py)), sections=100).export("whiskey.stl")
    print("whiskey.stl generated.")

make_whiskey()