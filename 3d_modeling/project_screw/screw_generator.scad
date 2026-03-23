include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [⚙️ General] */
Display = "screw"; 
Spec = "M5"; 
Thread = "coarse"; 
Pitch = 1;
Nut_Style = "standard"; // [standard, flanged]

/* [🪛️ Screw] */
Screw_Length = 16; 
Screw_Head = "hex"; 
Screw_Drive = "none"; 
Screw_Undersize = 0.0;
Screw_Thread_Length = 0;
Screw_Reorient = true;
Screw_Split = false;

/* [🔩 Nut] */
Nut_Shape = "hex"; 
Nut_Thickness = "normal"; 
Nut_Custom_Thickness = 10;
Nut_Width = 0;
Nut_Clearance = 0.1; 
Nut_Bevel = "auto"; 
Nut_Flush = false;

/* [⭕ Washer] */
Washer_Size = "regular";  
Washer_Chamfer = 0; 

/* [📷 Render] */
Resolution = 3; 
Color = "#e2dede"; 

_INCH = 25.4;
Face = (Resolution == 4) ? [1, 0.1] : (Resolution == 3) ? [2, 0.15] : [4, 0.4];
$fa = Face[0];
$fs = Face[1];

/* [Hidden Mapping] */
Screw_Head_Mapped = Screw_Head == "ribbedsocket" ? "socket ribbed" : Screw_Head;
Thread_Mapped = Thread == "custom" ? Pitch : (Thread == "none" ? 0 : Thread);
Nut_Inner_Bevel = Nut_Bevel == "auto" ? undef : (Nut_Bevel == "none" || Nut_Bevel == "outside" ? false : true);
Nut_Outer_Bevel = Nut_Bevel == "auto" ? undef : (Nut_Bevel == "none" || Nut_Bevel == "inside" ? false : true);

// Unified Data Table for Washers
Washer_Table = [
    ["M2",   2.2,  5,   0.3,  9,   0.5], ["M2.5", 2.7,  6,   0.5,  10,  0.8],
    ["M3",   3.2,  7,   0.5,  12,  0.8], ["M4",   4.3,  9,   0.8,  15,  1.2],
    ["M5",   5.3,  10,  1.0,  20,  1.6], ["M6",   6.4,  12,  1.6,  24,  2.0],
    ["M7",   7.4,  14,  1.6,  22,  2.0], ["M8",   8.4,  16,  1.6,  30,  2.5],
    ["M10",  10.5, 20,  2.0,  40,  3.0], ["M12",  13.0, 24,  2.5,  50,  3.5],
    ["M14",  15.0, 28,  2.5,  56,  4.0], ["M16",  17.0, 30,  3.0,  60,  4.5],
    ["M18",  19.0, 34,  3.0,  56,  4.0], ["M20",  21.0, 37,  3.0,  60,  4.0],
    ["#4",   0.125*_INCH, 0.312*_INCH, 0.036*_INCH], ["#6", 0.149*_INCH, 0.375*_INCH, 0.036*_INCH],
    ["#8",   0.174*_INCH, 0.437*_INCH, 0.050*_INCH], ["#10", 0.198*_INCH, 0.500*_INCH, 0.050*_INCH],
    ["#12",  0.250*_INCH, 0.562*_INCH, 0.065*_INCH], ["1/4", 0.257*_INCH, 0.750*_INCH, 0.063*_INCH],
    ["5/16", 0.320*_INCH, 0.875*_INCH, 0.078*_INCH], ["3/8", 0.385*_INCH, 1.000*_INCH, 0.083*_INCH],
    ["7/16", 0.460*_INCH, 1.125*_INCH, 0.095*_INCH], ["1/2", 0.5625*_INCH, 1.375*_INCH, 0.109*_INCH],
    ["9/16", 0.625*_INCH, 1.500*_INCH, 0.125*_INCH], ["3/4", 0.8125*_INCH, 2*_INCH, 0.148*_INCH]
];

W_Data = struct_val(Washer_Table, Spec);

module generate_screw() {
    if (Screw_Split) {
        zrot(90) top_half(s=Screw_Length*3) {
            left(0.1) screw(Spec, head=Screw_Head_Mapped, drive=Screw_Drive, length=Screw_Length, thread=Thread_Mapped, undersize=Screw_Undersize, orient=RIGHT, anchor="head_top");
            right(0.1) screw(Spec, head=Screw_Head_Mapped, drive=Screw_Drive, length=Screw_Length, thread=Thread_Mapped, undersize=Screw_Undersize, orient=LEFT, anchor="head_top");
        }
    } else {
        screw(Spec, head=Screw_Head_Mapped, drive=Screw_Drive, length=Screw_Length, thread=Thread_Mapped, undersize=Screw_Undersize, anchor=(Screw_Reorient?TOP:BOTTOM), orient=(Screw_Reorient?DOWN:UP));
    }
}

module generate_nut() {
    thick = (Nut_Thickness == "custom") ? Nut_Custom_Thickness : Nut_Thickness;
    nut(Spec, shape=Nut_Shape, thickness=thick, nutwidth=Nut_Width>0?Nut_Width:undef, 
        thread=Thread_Mapped, flanged=(Nut_Style=="flanged"), bevel=Nut_Outer_Bevel, 
        ibevel=Nut_Inner_Bevel, bevel1=Nut_Flush?false:undef, anchor=BOTTOM, $slop=Nut_Clearance);
}

module generate_washer() {
    id = W_Data[0];
    is_m = starts_with(Spec, "M");
    od = is_m ? (Washer_Size == "large" ? W_Data[3] : W_Data[1]) : W_Data[1];
    h  = is_m ? (Washer_Size == "large" ? W_Data[4] : W_Data[2]) : W_Data[2];
    tube(id=id, od=od, h=h, chamfer=h/2 * Washer_Chamfer, anchor=BOTTOM);
}

if (Display == "nut") generate_nut();
else if (Display == "washer") generate_washer();
else generate_screw();