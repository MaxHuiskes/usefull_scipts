import trimesh, numpy as np, os, sys
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def make_coupe():
    r, s_len, b_dia, thick = 45, 90, 75, 1.5
    angles = np.linspace(-np.pi/2, np.pi/2 * 0.3, 60)
    ox, oy = np.cos(angles)*r*1.5, np.sin(angles)*r*0.6 + (r*0.6)
    ix, iy = np.clip(ox-thick, 0, None), oy+thick
    px = [0, b_dia/2, b_dia/2, 2.5, 2.5] + list(ox) + list(ix[::-1]) + [0]
    py = [-s_len-3, -s_len-3, -s_len, -s_len, oy[0]] + list(oy) + list(iy[::-1]) + [iy[0]]
    trimesh.creation.revolve(np.column_stack((px, py)), sections=100).export("coupe.stl")
    print("coupe.stl generated.")

make_coupe()