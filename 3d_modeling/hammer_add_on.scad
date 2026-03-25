// --- Parameters ---
$fn = 100;              

inner_bottom = 15.50;   
inner_top = 17.18;      
depth = 8.0;            
wall_thickness = 2.0;   
base_thickness = 5.0;   // Thick enough to hold a 2mm magnet + 3mm of floor

// Magnet Dimensions (3x2mm)
mag_d = 3.0 + 0.2;      // Diameter + tolerance for fit
mag_h = 2.0 + 0.2;      // Height + tolerance

// Calculated outer dimensions
outer_bottom = inner_bottom + (wall_thickness * 2);
outer_top = inner_top + (wall_thickness * 2);
total_height = depth + base_thickness;

// --- The Model ---
difference() {
    // 1. The Main Body (Outer Shell)
    cylinder(h = total_height, d1 = outer_bottom, d2 = outer_top);

    // 2. The Main Inner Hole (The tapered cavity)
    translate([0, 0, base_thickness])
        cylinder(h = depth + 0.1, d1 = inner_bottom, d2 = inner_top);

    // 3. The Internal Magnet Pocket 
    // This starts at the "floor" of the inner hole and goes DOWN 2mm
    translate([0, 0, base_thickness - mag_h + 0.01]) 
        cylinder(h = mag_h, d = mag_d);
}