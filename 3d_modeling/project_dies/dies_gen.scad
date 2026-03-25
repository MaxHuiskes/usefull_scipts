/*
Custom Tabletop Dice Generator
Created by: Lerch (https://github.com/Lerch4)(https://makerworld.com/en/@Lerch)
Released: https://makerworld.com/en/models/739273#profileId-671568
License: Standard Digital License
*/

// imports ----------------------------------------------------------------------------------------
include <BOSL2/std.scad>
include <BOSL2/polyhedra.scad>
include <BOSL2/fnliterals.scad>

// Parameters -------------------------------------------------------------------------------------
/*[Die]*/
die = "d20"; // [d20, d12, d10, d8, d6, d4, d100, d30, d24, d48, d12_rhombic]
graphic_type = "cutout"; // [debossed, flush, cutout]
die_diameter = 30;
die_rounding = 1;
die_color="#00a0ff"; //color

/*[Default Graphic]*/
default_text_size = 4.3; //[0:0.1:100]
default_graphic_depth = 1; // [.01:.01:10]
graphic_color="#505050"; //color
default_font="Lora";
default_font_style="Bold";
default_font_true = (default_font_style == "None")? default_font: str(default_font,":style=",default_font_style);

/*[Advanced / Experimental]*/
indicator_for_6_and_9 = false;
offset_for_indicated_6_and_9 =0; // [-10:0.1:10]
d10_0_indexed = true;
d10_multiples_of_10 = false;
d10_height_ratio=.5; // [.5, .66, .75]
//used with d20
numerically_balanced_d20 = false;
// used with d10
cutout_scale=.75;
//used with d4, d6, d8, d12, d20
cutout_size_offset = 0;
cutout_location_offset = [0,0]; // [-10:.001:10]
// pipe | between labels; face k uses token k (non-empty overrides Side k / default number)
comma_labels = "";
// Set from web/CLI for d100 etc.: one string per face; empty string = use default number
face_label_vector = [];
face_graphic_vector = [];
face_text_size_vector = [];
face_font_vector = [];
face_font_style_vector = [];
face_svg_file_vector = [];
face_svg_scale_vector = [];
face_offset_x_vector = [];
face_offset_y_vector = [];
face_rotation_vector = [];
$fn=128;


/*[Side1]*/
side1_graphic="text"; // [text, svg]
side1_text="default";
//only used if >=0
side1_text_size = -.1;
side1_font="default";
side1_font_style="default";
// if you don't see your graphic try adjusting the scale
side1_svg="default.svg";
side1_svg_scale=.025; 
side1_offset = [0,0]; // // [-10:.01:10]
side1_rotation=0;

/*[Side2]*/
side2_graphic="text"; // [text, svg]
side2_text="default";
//only used if >=0
side2_text_size = -.1;
side2_font="default";
side2_font_style="default";
// if you don't see your graphic try adjusting the scale
side2_svg="default.svg";
side2_svg_scale=.025;
side2_offset = [0,0]; // [-10:.01:10]
side2_rotation=0;

/*[Side3]*/
side3_graphic="text"; // [text, svg]
side3_text="default";
//only used if >=0
side3_text_size = -.1;
side3_font="default";
side3_font_style="default";
// if you don't see your graphic try adjusting the scale
side3_svg="default.svg";
side3_svg_scale=.025;
side3_offset = [0,0]; // [-10:.01:10]
side3_rotation=0;

/*[Side4]*/
side4_graphic="text"; // [text, svg]
side4_text="default";
//only used if >=0
side4_text_size = -.1;
side4_font="default";
side4_font_style="default";
// if you don't see your graphic try adjusting the scale
side4_svg="default.svg";
side4_svg_scale=.025;
side4_offset = [0,0]; // [-10:.01:10]
side4_rotation=0;

/*[Side5]*/
side5_graphic="text"; // [text, svg]
side5_text="default";
//only used if >=0
side5_text_size = -.1;
side5_font="default";
side5_font_style="default";
// if you don't see your graphic try adjusting the scale
side5_svg="default.svg";
side5_svg_scale=.025;
side5_offset = [0,0]; // [-10:.01:10]
side5_rotation=0;

/*[Side6]*/
side6_graphic="text"; // [text, svg]
side6_text="default";
//only used if >=0
side6_text_size = -.1;
side6_font="default";
side6_font_style="default";
// if you don't see your graphic try adjusting the scale
side6_svg="default.svg";
side6_svg_scale=.025;
side6_offset = [0,0]; // [-10:.01:10]
side6_rotation=0;

/*[Side7]*/
side7_graphic="text"; // [text, svg]
side7_text="default";
//only used if >=0
side7_text_size = -.1;
side7_font="default";
side7_font_style="default";
// if you don't see your graphic try adjusting the scale
side7_svg="default.svg";
side7_svg_scale=.025;
side7_offset = [0,0]; // [-10:.01:10]
side7_rotation=0;

/*[Side8]*/
side8_graphic="text"; // [text, svg]
side8_text="default";
//only used if >=0
side8_text_size = -.1;
side8_font="default";
side8_font_style="default";
// if you don't see your graphic try adjusting the scale
side8_svg="default.svg";
side8_svg_scale=.025;
side8_offset = [0,0]; // [-10:.01:10]
side8_rotation=0;

/*[Side9]*/
side9_graphic="text"; // [text, svg]
side9_text="default";
//only used if >=0
side9_text_size = -.1;
side9_font="default";
side9_font_style="default";
// if you don't see your graphic try adjusting the scale
side9_svg="default.svg";
side9_svg_scale=.025;
side9_offset = [0,0]; // [-10:.01:10]
side9_rotation=0;

/*[Side10]*/
side10_graphic="text"; // [text, svg]
side10_text="default";
//only used if >=0
side10_text_size = -.1;
side10_font="default";
side10_font_style="default";
// if you don't see your graphic try adjusting the scale
side10_svg="default.svg";
side10_svg_scale=.025;
side10_offset = [0,0]; // [-10:.01:10]
side10_rotation=0;

/*[Side11]*/
side11_graphic="text"; // [text, svg]
side11_text="default";
//only used if >=0
side11_text_size = -.1;
side11_font="default";
side11_font_style="default";
// if you don't see your graphic try adjusting the scale
side11_svg="default.svg";
side11_svg_scale=.025;
side11_offset = [0,0]; // [-10:.01:10]
side11_rotation=0;

/*[Side12]*/
side12_graphic="text"; // [text, svg]
side12_text="default";
//only used if >=0
side12_text_size = -.1;
side12_font="default";
side12_font_style="default";
// if you don't see your graphic try adjusting the scale
side12_svg="default.svg";
side12_svg_scale=.025;
side12_offset = [0,0]; // [-10:.01:10]
side12_rotation=0;

/*[Side13]*/
side13_graphic="text"; // [text, svg]
side13_text="default";
//only used if >=0
side13_text_size = -.1;
side13_font="default";
side13_font_style="default";
// if you don't see your graphic try adjusting the scale
side13_svg="default.svg";
side13_svg_scale=.025;
side13_offset = [0,0]; // [-10:.01:10]
side13_rotation=0;

/*[Side14]*/
side14_graphic="text"; // [text, svg]
side14_text="default";
//only used if >=0
side14_text_size = -.1;
side14_font="default";
side14_font_style="default";
// if you don't see your graphic try adjusting the scale
side14_svg="default.svg";
side14_svg_scale=.025;
side14_offset = [0,0]; // [-10:.01:10]
side14_rotation=0;

/*[Side15]*/
side15_graphic="text"; // [text, svg]
side15_text="default";
//only used if >=0
side15_text_size = -.1;
side15_font="default";
side15_font_style="default";
// if you don't see your graphic try adjusting the scale
side15_svg="default.svg";
side15_svg_scale=.025;
side15_offset = [0,0]; // [-10:.01:10]
side15_rotation=0;

/*[Side16]*/
side16_graphic="text"; // [text, svg]
side16_text="default";
//only used if >=0
side16_text_size = -.1;
side16_font="default";
side16_font_style="default";
// if you don't see your graphic try adjusting the scale
side16_svg="default.svg";
side16_svg_scale=.025;
side16_offset = [0,0]; // [-10:.01:10]
side16_rotation=0;

/*[Side17]*/
side17_graphic="text"; // [text, svg]
side17_text="default";
//only used if >=0
side17_text_size = -.1;
side17_font="default";
side17_font_style="default";
// if you don't see your graphic try adjusting the scale
side17_svg="default.svg";
side17_svg_scale=.025;
side17_offset = [0,0]; // [-10:.01:10]
side17_rotation=0;

/*[Side18]*/
side18_graphic="text"; // [text, svg]
side18_text="default";
//only used if >=0
side18_text_size = -.1;
side18_font="default";
side18_font_style="default";
// if you don't see your graphic try adjusting the scale
side18_svg="default.svg";
side18_svg_scale=.025;
side18_offset = [0,0]; // [-10:.01:10]
side18_rotation=0;

/*[Side19]*/
side19_graphic="text"; // [text, svg]
side19_text="default";
//only used if >=0
side19_text_size = -.1;
side19_font="default";
side19_font_style="default";
// if you don't see your graphic try adjusting the scale
side19_svg="default.svg";
side19_svg_scale=.025;
side19_offset = [0,0]; // [-10:.01:10]
side19_rotation=0;

/*[Side20]*/
side20_graphic="text"; // [text, svg]
side20_text="default";
//only used if >=0
side20_text_size = -.1;
side20_font="default";
side20_font_style="default";
// if you don't see your graphic try adjusting the scale
side20_svg="default.svg";
side20_svg_scale=.025;
side20_offset = [0,0]; // [-10:.01:10]
side20_rotation=0;


/*[Hidden]*/
// Constants / Conditional Variables --------------------------------------------------------------
cutout_depth = default_graphic_depth;
cutout_rounding=cutout_depth/2;
d10_height = die_diameter*d10_height_ratio;
face_count =
    die=="d4"?4: die=="d6"?6: die=="d8"?8: die=="d10"?10: die=="d12"?12: die=="d20"?20:
    die=="d100"?100: die=="d30"?30: die=="d24"?24: die=="d12_rhombic"?12: die=="d48"?48: 20;

die_diameter_true = in_list(die, ["d8", "d10", "d12", "d20", "d4", "d100", "d30", "d24", "d12_rhombic", "d48"])? die_diameter/2: die_diameter;
shape_faces= (die == "d10") ? 10: (die == "d100") ? 100: undef;
shape_height = in_list(die, ["d10", "d100"]) ? d10_height: undef;
sides_final = (in_list(die, ["d8", "d10", "d12", "d20", "d4", "d100", "d30", "d24", "d12_rhombic", "d48"]))? undef: die_diameter_true;
rad_final = (in_list(die, ["d8", "d10", "d12", "d20", "d100", "d30", "d24", "d12_rhombic", "d48"]))? die_diameter_true: undef;
mid_rad_final = (die=="d4")? die_diameter_true: undef;
// not perfect
d10_base_rotation_75 = [32.5, -32.5, -110.5, -32.5, -110.5, -110.5, 32.5, -110.5, -32.5,-32.5];
d10_base_rotation_66 = [30, -30, -112.5, -30, -112.5, -112.5, 30, -112.5, -30, -30];
d10_base_rotation_5 = [25.5, -25.5, -115.5, -25.5, -115.5, -115.5, 25.5, -115.5, -25,-25.5];
d10_base_rotation = (d10_height_ratio==.5)? d10_base_rotation_5:(d10_height_ratio==.75)? d10_base_rotation_75: d10_base_rotation_66;
d8_base_rotation = [0,0,0,0,120,-120,-120,0];
base_rotation = (die == "d10")? d10_base_rotation:(die == "d8")? d8_base_rotation: repeat(0, face_count);

die_name = 
    (die == "d20")? "icosahedron":
    (die == "d12")? "dodecahedron":
    (die == "d10")? "trapezohedron":
    (die == "d8")? "octahedron":
    (die == "d6")? "cube":
    (die == "d4")? "tetrahedron":
    (die == "d100")? "trapezohedron":
    (die == "d30")? "rhombic triacontahedron":
    (die == "d24")? "deltoidal icositetrahedron":
    (die == "d12_rhombic")? "rhombic dodecahedron":
    (die == "d48")? "disdyakis dodecahedron":
    undef;

standard_order = 
    (die == "d20")? (numerically_balanced_d20)?
        [1,11,13,15,12,5,17,19,2,18,4,14, 9,8,7,3,10,6,16,20]:
        [1,19,11,13,9,7,17,3,18,5,4,15,12,10,6,16,2,8,14,20]:
    (die == "d12")? [1,4,6,5,11,10,3,2,9,8,12,7]:
    (die == "d10")? [1,5,8,7,2,3,10,9,6,4]:
    (die == "d8")? [1,7,3,5,4,6,8,2]:
    (die == "d6")? [1,3,2,4,6,5]:
    (die == "d4")? [1,2,3,4]:
    in_list(die, ["d100","d30","d24","d12_rhombic","d48"]) ? [for (i=[1:1:face_count]) i] :
    undef;

graphic_list = 
    [side1_graphic, side2_graphic, side3_graphic, side4_graphic, side5_graphic, side6_graphic, side7_graphic, side8_graphic, side9_graphic, side10_graphic,
    side11_graphic, side12_graphic, side13_graphic, side14_graphic, side15_graphic, side16_graphic, side17_graphic, side18_graphic, side19_graphic, side20_graphic];

svg_scale_list = 
    [side1_svg_scale, side2_svg_scale, side3_svg_scale, side4_svg_scale, side5_svg_scale, side6_svg_scale, side7_svg_scale, side8_svg_scale, side9_svg_scale, side10_svg_scale,
    side11_svg_scale, side12_svg_scale, side13_svg_scale, side14_svg_scale, side15_svg_scale, side16_svg_scale, side17_svg_scale, side18_svg_scale, side19_svg_scale, side20_svg_scale];

side_text_list =
    [side1_text, side2_text, side3_text, side4_text, side5_text, side6_text, side7_text, side8_text, side9_text, side10_text,
    side11_text, side12_text, side13_text, side14_text, side15_text, side16_text, side17_text, side18_text, side19_text, side20_text];

side_text_size_list =
    [side1_text_size, side2_text_size, side3_text_size, side4_text_size, side5_text_size, side6_text_size, side7_text_size, side8_text_size, side9_text_size, side10_text_size,
    side11_text_size, side12_text_size, side13_text_size, side14_text_size, side15_text_size, side16_text_size, side17_text_size, side18_text_size, side19_text_size, side20_text_size];

side_font_list =
    [side1_font, side2_font, side3_font, side4_font, side5_font, side6_font, side7_font, side8_font, side9_font, side10_font,
    side11_font, side12_font, side13_font, side14_font, side15_font, side16_font, side17_font, side18_font, side19_font, side20_font];

side_font_style_list =
    [side1_font_style, side2_font_style, side3_font_style, side4_font_style, side5_font_style, side6_font_style, side7_font_style, side8_font_style, side9_font_style, side10_font_style,
    side11_font_style, side12_font_style, side13_font_style, side14_font_style, side15_font_style, side16_font_style, side17_font_style, side18_font_style, side19_font_style, side20_font_style];

side_svg_list =
    [side1_svg, side2_svg, side3_svg, side4_svg, side5_svg, side6_svg, side7_svg, side8_svg, side9_svg, side10_svg,
    side11_svg, side12_svg, side13_svg, side14_svg, side15_svg, side16_svg, side17_svg, side18_svg, side19_svg, side20_svg];

side_offset_list=
    [side1_offset, side2_offset, side3_offset, side4_offset, side5_offset, side6_offset, side7_offset, side8_offset, side9_offset, side10_offset,
    side11_offset, side12_offset, side13_offset, side14_offset, side15_offset, side16_offset, side17_offset, side18_offset, side19_offset, side20_offset];

side_rotation_list=
    [side1_rotation, side2_rotation, side3_rotation, side4_rotation, side5_rotation, side6_rotation, side7_rotation, side8_rotation, side9_rotation, side10_rotation,
    side11_rotation, side12_rotation, side13_rotation, side14_rotation, side15_rotation, side16_rotation, side17_rotation, side18_rotation, side19_rotation, side20_rotation];

label_tokens = (comma_labels != "") ? str_split(comma_labels, "|", keep_nulls=true) : [];
function vec_ok(v, slot) = len(v) >= slot && slot >= 1;
function safe_side_text(slot) = (slot >= 1 && slot <= 20) ? side_text_list[slot-1] : "default";
function safe_graphic_slot(slot) =
    vec_ok(face_graphic_vector, slot) ? face_graphic_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? graphic_list[slot-1] : "text";
function safe_text_size_slot(slot) =
    vec_ok(face_text_size_vector, slot) ? face_text_size_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? side_text_size_list[slot-1] : -0.1;
function safe_font_slot(slot) =
    vec_ok(face_font_vector, slot) ? face_font_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? side_font_list[slot-1] : "default";
function safe_font_style_slot(slot) =
    vec_ok(face_font_style_vector, slot) ? face_font_style_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? side_font_style_list[slot-1] : "default";
function safe_offset_slot(slot) =
    vec_ok(face_offset_x_vector, slot) && vec_ok(face_offset_y_vector, slot)
        ? [face_offset_x_vector[slot-1], face_offset_y_vector[slot-1]] :
    (slot >= 1 && slot <= 20) ? side_offset_list[slot-1] : [0,0];
function safe_rotation_slot(slot) =
    vec_ok(face_rotation_vector, slot) ? face_rotation_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? side_rotation_list[slot-1] : 0;
function safe_svg_scale_slot(slot) =
    vec_ok(face_svg_scale_vector, slot) ? face_svg_scale_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? svg_scale_list[slot-1] : 0.025;
function safe_svg_file_slot(slot) =
    vec_ok(face_svg_file_vector, slot) ? face_svg_file_vector[slot-1] :
    (slot >= 1 && slot <= 20) ? side_svg_list[slot-1] : "default.svg";

// Approximate max glyph height so text stays inside the face (fixed mm size blows up on d100, d48, etc.)
function adaptive_text_cap() =
    in_list(die, ["d6"]) ? die_diameter_true * 0.42 :
    (die == "d4") ? die_diameter_true * 0.38 :
    // rad_final ~ circumradius; chord ~ 2*r*sin(pi/n); OpenSCAD sin() uses degrees
    die_diameter_true * sin(180 / max(face_count, 4)) * 1.7;


// functions --------------------------------------------------------------------------------------
minus_1 = function(x) (d10_0_indexed)? str(parse_int(x)-1): x;
times_10 = function(x) (d10_multiples_of_10) ? format_int(parse_int(x)*10, 2): x;

// modules ----------------------------------------------------------------------------------------

module determine_cutout_shape(){

    if (die=="d20"){
            linear_extrude(height = cutout_depth) 
                regular_ngon(n=3, d=(die_diameter/2)+cutout_size_offset, spin=90);
    }
    else if (die=="d12"){
            linear_extrude(height = cutout_depth) 
                regular_ngon(n=5, d=(die_diameter/2)+cutout_size_offset, spin=90);
    }
    else if (die=="d8"){
            linear_extrude(height = cutout_depth) 
                regular_ngon(n=3, d=(die_diameter/1.75)+cutout_size_offset, spin=90);
    }
    else if (die=="d6"){
            linear_extrude(height = cutout_depth) 
                regular_ngon(n=4, d=(die_diameter)+cutout_size_offset, spin=45);
    }
    else if (die=="d4"){
            linear_extrude(height = cutout_depth) 
                regular_ngon(n=3, d=(die_diameter)+cutout_size_offset, spin=90);
    }
    else if (in_list(die, ["d10", "d100"])){
        adjustment = (d10_height_ratio==.5)? die_diameter/9:(d10_height_ratio==.75)? 0: die_diameter/30;

        linear_extrude(height = cutout_depth) 
            scale(cutout_scale)       
            rotate(270)      
            projection(cut = true)
            up(-d10_height/75)
            left(adjustment)  
            regular_polyhedron(die_name, facedown=true, r=die_diameter/2, repeat=true, draw=true, rounding=die_rounding, faces=shape_faces, height=shape_height, anchor=BOT); 
    }
    else if (in_list(die, ["d30", "d24", "d12_rhombic"])){
        linear_extrude(height = cutout_depth)
            regular_ngon(n=4, d=(die_diameter/2.5)+cutout_size_offset, spin=45);
    }
    else if (die=="d48"){
        linear_extrude(height = cutout_depth)
            regular_ngon(n=3, d=(die_diameter/2.2)+cutout_size_offset, spin=90);
    }
}

module determine_graphic(cutout=false){

    slot = standard_order[$faceindex];
    side_font = safe_font_slot(slot);
    side_font_style = safe_font_style_slot(slot);
    side_font_style_true = 
        (side_font_style == "default")? default_font_style:
        in_list(side_font_style, ["None", "none", ""])? "":
        side_font_style;
    side_font_true = in_list(side_font, ["None", "none", "", "default"])? default_font:side_font;
    side_font_final = in_list(side_font_style_true, [""])? side_font: str(side_font_true,":style=",side_font_style_true);
    
    vl = (len(face_label_vector) >= slot && slot >= 1) ? face_label_vector[slot-1] : "";
    vec_txt = (vl != "" && !in_list(vl, ["default"])) ? vl : undef;
    pipe_txt = (slot >= 1 && slot <= len(label_tokens) && label_tokens[slot-1] != "") ? label_tokens[slot-1] : undef;
    sv = safe_side_text(slot);
    default_text_adjusted = (die == "d10") ? times_10(minus_1(str(slot))) : str(slot);
    true_text =
        vec_txt != undef ? vec_txt :
        pipe_txt != undef ? pipe_txt :
        (!in_list(sv, ["default", ""])) ? sv :
        default_text_adjusted;
    side_ts = safe_text_size_slot(slot);
    raw_text_size = (side_ts >= 0) ? side_ts : default_text_size;
    final_adjusted_text = (indicator_for_6_and_9 && in_list(die, ["d20", "d12", "d10"]) && in_list(str(true_text), ["6", "9"])) ? str_join([str(true_text), "."]) : str(true_text);
    cap = adaptive_text_cap();
    // Long strings (e.g. "100") are wider; shrink slightly vs single digits
    len_scale = 1 / (0.72 + 0.11 * len(final_adjusted_text));
    true_text_size = min(raw_text_size, cap) * len_scale;
    
    indicator_adjustment = (indicator_for_6_and_9 && in_list(die, ["d20", "d12", "d10"]) && in_list(str(true_text), ["6", "9"]))? [offset_for_indicated_6_and_9,0]: [0,0];
    
    loc = (in_list(graphic_type, ["debossed", "flush"]))? default_graphic_depth :(graphic_type=="cutout")? default_graphic_depth:0;

    down(loc)
        color(graphic_color)
        rotate(base_rotation[$faceindex])
        if (graphic_type=="cutout" && cutout) {
            translate(cutout_location_offset)
            determine_cutout_shape();
        }
        
        else{
            linear_extrude(default_graphic_depth)
                move(safe_offset_slot(slot)+indicator_adjustment)      
                rotate(safe_rotation_slot(slot))
                if (safe_graphic_slot(slot) ==  "text"){
                    #text(final_adjusted_text, size=true_text_size, anchor=CENTER, font=side_font_final, valign="center", halign="center");
                }
                else {
                    scale(safe_svg_scale_slot(slot))
                        import(safe_svg_file_slot(slot), center=true);  
                }
        } 
}


module graphics(die_name=die_name, diameter=die_diameter, cutout=false){

    regular_polyhedron(die_name, facedown=true, mr=mid_rad_final, r=rad_final, side=sides_final, repeat=true, draw=false, rounding=die_rounding, faces=shape_faces, height=shape_height, anchor=BOT) {
            determine_graphic(cutout);
    }
}

// main -------------------------------------------------------------------------------------------
difference(){
    color(die_color)
        regular_polyhedron(die_name, facedown=true, mr=mid_rad_final, r=rad_final, side=sides_final, repeat=true, draw=true, rounding=die_rounding, faces=shape_faces, height=shape_height, anchor=BOT); 

    recolor(graphic_color)
        if (graphic_type!="embossed"){graphics(cutout=true);}
}

color(graphic_color)
    if (graphic_type=="embossed"|| graphic_type=="flush"){graphics();}

color(die_color)
     if (graphic_type =="cutout"){graphics();}

