// --- Parameters ---
/* [What to Render] */
Part = "core"; // [core, flat_spacer, dovetail_male, dovetail_female]

/* [Dimensions] */
// The internal size of the hole (e.g., 90 for wine, 140 for large box)
Internal_Size = 90; 
Depth = 120; 
Wall_Thickness = 6; // Thicker walls look better as a skeleton

// Only used if Part == "core"
Core_Type = "bottle"; // [bottle, box]

// How much to add to make it reach the next "grid" size
Spacer_Width = 50; 

/* [Skeletonization] */
// How much material to leave (1.0 = solid, 0.1 = skeleton). Adjust for strength.
Skeleton_Factor = 0.25; // [0.1:0.05:0.9]

/* [Dovetail Settings] */
// Fixed dovetail size (locked): do not scale with any other setting.
DT_Width = 14;
DT_Height = 5;
Clearance = 0.2; 
DT_Left = "female";   // [none, male, female]
DT_Right = "male";    // [none, male, female]
DT_Top = "male";      // [none, male, female]
DT_Bottom = "female"; // [none, male, female]

// --- Calculations ---
$fn = 80;
Outer_Size = Internal_Size + (Wall_Thickness * 2);
Cutout_Thickness = Wall_Thickness * (1 - Skeleton_Factor);
// Locked values used everywhere so dovetail size stays constant.
DT_Width_Effective = 14;
DT_Height_Effective = 5;
DT_Join_Overlap = 0.4;

module dovetail(w, h, buffer=0) {
    polygon(points=[
        [0 - buffer, 0 - buffer], 
        [w + buffer, 0 - buffer], 
        [w * 1.5 + buffer, h + buffer], 
        [-w * 0.5 - buffer, h + buffer]
    ]);
}

module add_male(side, dim_x, dim_y, dim_z) {
    if (side == "left")
        translate([0, (dim_y/2) - (DT_Width_Effective/2), 0]) rotate([0, 0, 90]) linear_extrude(dim_z) dovetail(DT_Width_Effective, DT_Height_Effective);
    else if (side == "right")
        translate([dim_x, (dim_y/2) + (DT_Width_Effective/2), 0]) rotate([0, 0, -90]) linear_extrude(dim_z) dovetail(DT_Width_Effective, DT_Height_Effective);
    else if (side == "top")
        translate([(dim_x/2) - (DT_Width_Effective/2), dim_y, 0]) rotate([0, 0, 0]) linear_extrude(dim_z) dovetail(DT_Width_Effective, DT_Height_Effective);
    else if (side == "bottom")
        translate([(dim_x/2) + (DT_Width_Effective/2), 0, 0]) rotate([0, 0, 180]) linear_extrude(dim_z) dovetail(DT_Width_Effective, DT_Height_Effective);
}

module cut_female(side, dim_x, dim_y, dim_z) {
    if (side == "left")
        translate([0, (dim_y/2) + (DT_Width_Effective/2), -1]) rotate([0, 0, -90]) linear_extrude(dim_z + 2) dovetail(DT_Width_Effective, DT_Height_Effective, Clearance);
    else if (side == "right")
        translate([dim_x, (dim_y/2) + (DT_Width_Effective/2), -1]) rotate([0, 0, 90]) linear_extrude(dim_z + 2) dovetail(DT_Width_Effective, DT_Height_Effective, Clearance);
    else if (side == "top")
        translate([(dim_x/2) + (DT_Width_Effective/2), dim_y, -1]) rotate([0, 0, 180]) linear_extrude(dim_z + 2) dovetail(DT_Width_Effective, DT_Height_Effective, Clearance);
    else if (side == "bottom")
        translate([(dim_x/2) - (DT_Width_Effective/2), 0, -1]) rotate([0, 0, 0]) linear_extrude(dim_z + 2) dovetail(DT_Width_Effective, DT_Height_Effective, Clearance);
}

module side_connectors_add(dim_x, dim_y, dim_z) {
    if (DT_Left == "male") {
        // Force connector-to-body overlap so STL is one connected shell.
        translate([-DT_Join_Overlap/2, 0, 0]) cube([DT_Join_Overlap, dim_y, dim_z]);
        add_male("left", dim_x, dim_y, dim_z);
    }
    if (DT_Right == "male") {
        translate([dim_x - (DT_Join_Overlap/2), 0, 0]) cube([DT_Join_Overlap, dim_y, dim_z]);
        add_male("right", dim_x, dim_y, dim_z);
    }
    if (DT_Top == "male") {
        translate([0, dim_y - (DT_Join_Overlap/2), 0]) cube([dim_x, DT_Join_Overlap, dim_z]);
        add_male("top", dim_x, dim_y, dim_z);
    }
    if (DT_Bottom == "male") {
        translate([0, -DT_Join_Overlap/2, 0]) cube([dim_x, DT_Join_Overlap, dim_z]);
        add_male("bottom", dim_x, dim_y, dim_z);
    }
}

module side_connectors_cut(dim_x, dim_y, dim_z) {
    if (DT_Left == "female") cut_female("left", dim_x, dim_y, dim_z);
    if (DT_Right == "female") cut_female("right", dim_x, dim_y, dim_z);
    if (DT_Top == "female") cut_female("top", dim_x, dim_y, dim_z);
    if (DT_Bottom == "female") cut_female("bottom", dim_x, dim_y, dim_z);
}

// Module to subtract material and create the skeleton
module skeletonize(dim_x, dim_y, dim_z) {
    difference() {
        children();
        
        // Subtract cubes along the Z-axis (Depth)
        if (Cutout_Thickness > 0) {
            num_cutouts = 4; // Adjust for complexity
            // Keep a solid perimeter so dovetail zones remain one piece.
            edge_solid_band = max(Wall_Thickness, DT_Height_Effective + Clearance + 1);
            inner_x = dim_x - (edge_solid_band * 2);
            inner_y = dim_y - (edge_solid_band * 2);
            size_x = inner_x / num_cutouts;
            size_y = inner_y / num_cutouts;

            if (inner_x > 0 && inner_y > 0) {
                for (i = [0 : num_cutouts - 1]) {
                    for (j = [0 : num_cutouts - 1]) {
                        translate([edge_solid_band + (i * size_x) + (size_x * Skeleton_Factor/2), 
                                   edge_solid_band + (j * size_y) + (size_y * Skeleton_Factor/2), 
                                   -1])
                            cube([size_x * (1-Skeleton_Factor), size_y * (1-Skeleton_Factor), dim_z + 2]);
                    }
                }
            }
        }
    }
}

// --- Logic ---

if (Part == "core") {
    difference() {
        union() {
            // SKELETONIZED CORE
            skeletonize(Outer_Size, Outer_Size, Depth) {
                cube([Outer_Size, Outer_Size, Depth]);
            }
            side_connectors_add(Outer_Size, Outer_Size, Depth);
        }
        // Hole Cutout
        translate([Outer_Size/2, Outer_Size/2, -1]) {
            if (Core_Type == "bottle") {
                cylinder(h = Depth + 2, d = Internal_Size);
            } else {
                // Match bottle behavior: cut all the way through depth.
                translate([-Internal_Size/2, -Internal_Size/2, 0])
                    cube([Internal_Size, Internal_Size, Depth + 2]);
            }
        }
        side_connectors_cut(Outer_Size, Outer_Size, Depth);
    }
}

if (Part == "flat_spacer") {
    difference() {
        union() {
            // SKELETONIZED FLAT SPACER
            skeletonize(Spacer_Width, Outer_Size, Depth) {
                cube([Spacer_Width, Outer_Size, Depth]);
            }
            side_connectors_add(Spacer_Width, Outer_Size, Depth);
        }
        side_connectors_cut(Spacer_Width, Outer_Size, Depth);
    }
}

if (Part == "dovetail_male") {
    linear_extrude(Depth) dovetail(DT_Width_Effective, DT_Height_Effective);
}

if (Part == "dovetail_female") {
    block_w = (DT_Width_Effective * 2) + (DT_Height_Effective * 3);
    difference() {
        cube([block_w, DT_Height_Effective + (Wall_Thickness * 2), Depth]);
        translate([(block_w/2) - (DT_Width_Effective/2), Wall_Thickness, -1])
            linear_extrude(Depth + 2) dovetail(DT_Width_Effective, DT_Height_Effective, Clearance);
    }
}