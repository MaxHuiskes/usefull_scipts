include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [⚙️ General] */
Display = "screw"; // [all, screw, nut, washer]
Spec = "M5";
Thread = "coarse"; // [coarse, fine, custom, none]
Pitch = 1;
Nut_Style = "standard"; // [standard, flanged]

/* [🪛️ Screw] */
Screw_Length = 16;
Screw_Head = "hex"; // [none, flat, button, socket, ribbedsocket, hex, pan, cheese]
Screw_Drive = "none"; // [none, hex, slot, phillips, ph1, ph2, ph3, ph4, torx, t10, t15, t20, t25]
Screw_Undersize = 0.0;
Screw_Thread_Length = 0;
Screw_Reorient = true;
Screw_Split = false;

/* [🔩 Nut] */
Nut_Shape = "hex"; // [hex, square]
Nut_Thickness = "normal"; // [thin, normal, thick, din, custom]
Nut_Custom_Thickness = 10;
Nut_Width = 0;
Nut_Clearance = 0.1;
Nut_Bevel = "auto"; // [auto, none, inside, outside, both]
Nut_Flush = false;

/* [⭕ Washer] */
Washer_Size = "regular"; // [regular, large]
Washer_Chamfer = 0;
// Outer diameter (overall width) and thickness; 0 = use spec table + Washer_Size
Washer_Outer_Diameter_Custom = 0;
Washer_Thickness_Custom = 0;

/* [📷 Render] */
Resolution = 3; // [1, 2, 3, 4]
Color = "#e2dede";
Debug = false;

Face = (Resolution == 4) ? [1, 0.1]
    : (Resolution == 3) ? [2, 0.15]
    : (Resolution == 2) ? [2, 0.2]
    : [4, 0.4];
$fa = Face[0];
$fs = Face[1];

/* [Hidden] */
Screw_Head_Mapped = Screw_Head == "ribbedsocket" ? "socket ribbed" : Screw_Head;
Thread_Mapped = Thread == "custom" ? Pitch : (Thread == "none" ? 0 : Thread);
Nut_Inner_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "outside" ? false
    : true;
Nut_Outer_Bevel = Nut_Bevel == "auto" ? undef
    : Nut_Bevel == "none" || Nut_Bevel == "inside" ? false
    : true;

// BOSL2 struct_val() returns only the value for [key, value]; value must be one list per spec.
Washer_Specs = struct_set([], [
    "M2",   [2.2,  5,   0.3,  9,   0.5],
    "M2.5", [2.7,  6,   0.5,  10,  0.8],
    "M3",   [3.2,  7,   0.5,  12,  0.8],
    "M4",   [4.3,  9,   0.8,  15,  1.2],
    "M5",   [5.3,  10,  1.0,  20,  1.6],
    "M6",   [6.4,  12,  1.6,  24,  2.0],
    "M7",   [7.4,  14,  1.6,  22,  2.0],
    "M8",   [8.4,  16,  1.6,  30,  2.5],
    "M10",  [10.5, 20,  2.0,  40,  3.0],
    "M12",  [13.0, 24,  2.5,  50,  3.5],
    "M14",  [15.0, 28,  2.5,  56,  4.0],
    "M16",  [17.0, 30,  3.0,  60,  4.5],
    "M18",  [19.0, 34,  3.0,  56,  4.0],
    "M20",  [21.0, 37,  3.0,  60,  4.0],
    "#4",   [0.125 * INCH,  0.312 * INCH,  0.036 * INCH],
    "#6",   [0.149 * INCH,  0.375 * INCH,  0.036 * INCH],
    "#8",   [0.174 * INCH,  0.437 * INCH,  0.050 * INCH],
    "#10",  [0.198 * INCH,  0.500 * INCH,  0.050 * INCH],
    "#12",  [0.250 * INCH,  0.562 * INCH,  0.065 * INCH],
    "1/4",  [0.257 * INCH,  0.750 * INCH,  0.063 * INCH],
    "5/16", [0.320 * INCH,  0.875 * INCH,  0.078 * INCH],
    "3/8",  [0.385 * INCH,  1.000 * INCH,  0.083 * INCH],
    "7/16", [0.460 * INCH,  1.125 * INCH,  0.095 * INCH],
    "1/2",  [0.5625 * INCH, 1.375 * INCH, 0.109 * INCH],
    "9/16", [0.625 * INCH,  1.500 * INCH,  0.125 * INCH],
    "3/4",  [0.8125 * INCH, 2 * INCH,      0.148 * INCH]
]);

W_Data = struct_val(Washer_Specs, Spec);
Is_Metric = starts_with(Spec, "M");
Washer_Inner_Diameter = W_Data[0];
_od_tab = Is_Metric ? ((Washer_Size == "large") ? W_Data[3] : W_Data[1]) : W_Data[1];
_h_tab = Is_Metric ? ((Washer_Size == "large") ? W_Data[4] : W_Data[2]) : W_Data[2];
Washer_Outer_Diameter = Washer_Outer_Diameter_Custom > 0 ? Washer_Outer_Diameter_Custom : _od_tab;
Washer_Height = Washer_Thickness_Custom > 0 ? Washer_Thickness_Custom : _h_tab;
Washer_Info = [
    ["diameter", Washer_Inner_Diameter],
    ["outer_diameter", Washer_Outer_Diameter],
    ["thickness", Washer_Height],
];

Screw_Info = screw_info(Spec, head = Screw_Head_Mapped, drive = Screw_Drive, thread = Thread_Mapped);
Screw_Diameter = struct_val(Screw_Info, "diameter", 0);
Screw_Head_Diameter = struct_val(Screw_Info, "head_size", Screw_Diameter);

Nut_Info = nut_info(Spec,
    shape = Nut_Shape,
    thickness = Nut_Thickness == "custom" ? Nut_Custom_Thickness : Nut_Thickness,
    width = Nut_Width > 0 ? Nut_Width : undef,
    thread = Thread_Mapped);

_thread_len_effective = Screw_Thread_Length > 0 ? min(Screw_Length, Screw_Thread_Length) : undef;

module generate_screw() {
    module render_screw(anchor, spin, orient) {
        screw(Spec,
            head = Screw_Head_Mapped,
            drive = Screw_Drive,
            length = Screw_Length,
            thread = Thread_Mapped,
            undersize = Screw_Undersize,
            thread_len = _thread_len_effective,
            anchor = anchor,
            spin = spin,
            orient = orient
        );
    }
    if (Screw_Split) {
        zrot(90)
        top_half(s = Screw_Length * 3) {
            left(0.1) render_screw(orient = RIGHT, anchor = "head_top");
            right(0.1) render_screw(orient = LEFT, anchor = "head_top");
        }
        cube([Screw_Head_Diameter - 0.24, 0.24, 0.24], anchor = BOTTOM + CENTER);
    } else {
        render_screw(
            anchor = Screw_Reorient ? TOP : BOTTOM,
            orient = Screw_Reorient ? DOWN : UP
        );
    }
}

module generate_nut() {
    thick = Nut_Thickness == "custom" ? Nut_Custom_Thickness : Nut_Thickness;
    nut(Spec,
        shape = Nut_Shape,
        thickness = thick,
        nutwidth = Nut_Width > 0 ? Nut_Width : undef,
        thread = Thread_Mapped,
        flanged = (Nut_Style == "flanged"),
        bevel = Nut_Outer_Bevel,
        bevel1 = Nut_Flush ? false : undef,
        ibevel = Nut_Inner_Bevel,
        anchor = BOTTOM,
        $slop = Nut_Clearance
    );
}

module generate_washer() {
    assert(!is_undef(W_Data), str("Unknown washer Spec: ", Spec));
    id = Washer_Inner_Diameter;
    od = Washer_Outer_Diameter;
    h = Washer_Height;
    assert(od > id && h > 0, "Washer outer diameter must exceed inner hole; thickness must be > 0");
    tube(id = id, od = od, h = h, chamfer = h / 2 * Washer_Chamfer, anchor = BOTTOM);
}

module info(title, data, keys) {
    if (is_struct(data) && is_list(keys)) {
        lines = [
            title,
            for (key = struct_keys(data))
                let (value = struct_val(data, key, undef))
                if (in_list(key, keys) && !is_undef(value))
                    str(str_replace_char(key, "_", " "), ": ", value, is_num(value) ? "mm" : "")
        ];
        fwd(max(Screw_Head_Diameter / 2, Washer_Outer_Diameter / 2) + 8)
        color("#AAAAAA")
        linear_extrude(height = 0.1)
            write(lines, size = 1.4);
    }
}

module nut_info() {
    if (Debug) info("Nut", Nut_Info, ["shape", "width", "diameter", "pitch", "thickness"]);
}

module screw_info() {
    if (Debug) info("Screw", Screw_Info, ["pitch", "diameter", "head", "head_size", "head_height", "drive", "drive_size", "drive_depth"]);
}

module washer_info() {
    if (Debug) info("Washer", Washer_Info, ["diameter", "outer_diameter", "thickness"]);
}

module write(lines, font = "Liberation Sans", size = 4, spacing = 1, lineheight = 1, halign = "center", valign = "top") {
    fm = fontmetrics(size = size, font = font);
    interline = fm.interline * lineheight;
    n = len(lines);
    bbox = write_bounding_box(lines, font, size, spacing, interline);
    total_height = bbox[1];
    y_offset =
        (valign == "top") ? 0 :
        (valign == "center") ? -total_height / 2 :
        -total_height;
    translate([0, -y_offset]) {
        for (i = [0 : n - 1]) {
            translate([0, -(interline * i + interline / 2)])
                text(
                    text = lines[i],
                    font = i == 0 ? str(font, ":style=Bold") : font,
                    size = size,
                    spacing = spacing,
                    halign = halign,
                    valign = "center"
                );
        }
    }
}

function write_bounding_box(lines, font, size, spacing, interline) = [
    max([for (line = lines) textmetrics(text = line, font = font, size = size, spacing = spacing).size.x]),
    interline * len(lines)
];

if (Display == "nut") {
    color(Color) generate_nut();
    nut_info();
} else if (Display == "screw") {
    color(Color) generate_screw();
    screw_info();
} else if (Display == "washer") {
    color(Color) generate_washer();
    washer_info();
} else {
    color(Color)
    xdistribute(max(Washer_Outer_Diameter, Screw_Head_Diameter * 2)) {
        generate_screw();
        generate_nut();
        generate_washer();
    }
    if (Debug) {
        xdistribute(max(20, Screw_Head_Diameter * 2)) {
            screw_info();
            nut_info();
            washer_info();
        }
    }
}
