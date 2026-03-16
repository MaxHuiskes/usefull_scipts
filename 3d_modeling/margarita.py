import trimesh, numpy as np, os, sys
sys.path.append(os.path.expanduser("~/Library/Python/3.12/lib/python/site-packages"))

def make_margarita():
    r, h, s_len, b_dia, thick = 55, 60, 75, 80, 1.6
    ang = np.linspace(-np.pi/2, 0, 20)
    bx = np.concatenate([np.cos(ang)*r*0.4, np.cos(ang)*r + (r*0.3)])
    by = np.concatenate([np.sin(ang)*15 + 15, np.sin(ang)*20 + 40])
    ox, oy = np.concatenate([bx, [r]]), np.concatenate([by, [h]])
    ix, iy = np.clip(ox-thick, 0, None), oy+thick
    px = [0, b_dia/2, b_dia/2, 2.5, 2.5] + list(ox) + list(ix[::-1]) + [0]
    py = [-s_len-3, -s_len-3, -s_len, -s_len, oy[0]] + list(oy) + list(iy[::-1]) + [iy[0]]
    trimesh.creation.revolve(np.column_stack((px, py)), sections=100).export("margarita.stl")
    print("margarita.stl generated.")

make_margarita()