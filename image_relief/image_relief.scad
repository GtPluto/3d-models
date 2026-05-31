/*
================================================================================
   Parametric 3D Image Relief & Badge Generator (PNG/Grayscale to 3D)
   Designed by Antigravity
   
   This script turns any black & white or grayscale PNG image into a 
   3D printable relief, badge, or coin using OpenSCAD's surface() engine.
================================================================================
*/

/* [Image Configuration] */
// Path to the black & white or grayscale PNG file (relative or absolute).
image_file = "logo.png"; 

// The width of the image in pixels (open the image properties to check this).
image_width_pixels = 256; // [50:10:4000]

// The height of the image in pixels.
image_height_pixels = 256; // [50:10:4000]

// Invert colors: Enabled = black areas stick out; Disabled = white areas stick out.
invert_colors = false;

/* [Physical Size (mm)] */
// The desired physical width of your 3D print (in mm). Height scales proportionally.
target_width_mm = 60; // [10:1:250]

// How much the image features should protrude/stick out (in mm).
relief_height_mm = 2.0; // [0.2:0.1:10.0]

// Thickness of the backing plate/base (in mm).
base_thickness_mm = 2.0; // [0.5:0.1:15.0]

/* [Badge Style] */
// Shape of the backing plate.
badge_style = "circle"; // [rectangle, round_rect, circle]

// Rounding radius (only applies to "round_rect" style, in mm).
corner_radius = 5; // [1:1:30]

/* [Resolution] */
// Quality of circles and fillets (higher = smoother, slower render).
$fn = 60; // [30:5:150]


// =============================================================================
// MAIN 3D RELIEF GENERATOR MODULE
// =============================================================================

module image_relief(
    file,
    img_w,
    img_h,
    target_w,
    relief_h,
    base_t,
    style = "rectangle",
    r_corner = 5,
    invert = false
) {
    // Calculate aspect ratio and target height in mm
    aspect = img_h / img_w;
    target_h = target_w * aspect;
    
    // Scale factors
    // 1. XY scaling maps pixel coordinates (1px = 1mm) to target physical size
    scale_xy = target_w / img_w;
    
    // 2. Z scaling: surface() maps 8-bit pixels (0-255) to Z heights (0-255mm).
    scale_z = relief_h / 255;

    // A small offset (in mm) to sink the surface background slightly below the base top.
    // This completely eliminates Z-fighting in the renderer, keeping the base perfectly clean!
    z_offset = 0.05;

    union() {
        // ---------------------------------------------------------------------
        // 1. Backing Plate (Base) - Light Gray
        // ---------------------------------------------------------------------
        color("#E6E6E6") // Sleek light gray for the backing plate
        translate([0, 0, -base_t]) {
            if (style == "rectangle") {
                // Flat rectangle base
                cube([target_w, target_h, base_t]);
            } 
            else if (style == "round_rect") {
                // Rounded rectangle base
                linear_extrude(height = base_t) {
                    hull() {
                        translate([r_corner, r_corner]) circle(r = r_corner);
                        translate([target_w - r_corner, r_corner]) circle(r = r_corner);
                        translate([r_corner, target_h - r_corner]) circle(r = r_corner);
                        translate([target_w - r_corner, target_h - r_corner]) circle(r = r_corner);
                    }
                }
            } 
            else if (style == "circle") {
                // Circular base centered on the image
                translate([target_w / 2, target_h / 2, 0])
                    cylinder(h = base_t, r = max(target_w, target_h) / 2);
            }
        }

        // ---------------------------------------------------------------------
        // 2. The 3D Image Relief Surface - Dark Gray/Black
        // ---------------------------------------------------------------------
        color("#1A1A1A") // Contrasting dark gray/black for the relief artwork
        intersection() {
            // Clamping Volume: We clip the square surface to match the base shape!
            // This prevents the square corners of the image from sticking out.
            translate([0, 0, -z_offset]) {
                if (style == "rectangle") {
                    cube([target_w, target_h, relief_h + z_offset]);
                } 
                else if (style == "round_rect") {
                    linear_extrude(height = relief_h + z_offset) {
                        hull() {
                            translate([r_corner, r_corner]) circle(r = r_corner);
                            translate([target_w - r_corner, r_corner]) circle(r = r_corner);
                            translate([r_corner, target_h - r_corner]) circle(r = r_corner);
                            translate([target_w - r_corner, target_h - r_corner]) circle(r = r_corner);
                        }
                    }
                } 
                else if (style == "circle") {
                    translate([target_w / 2, target_h / 2, 0])
                        cylinder(h = relief_h + z_offset, r = max(target_w, target_h) / 2);
                }
            }

            // The actual image surface, sunk slightly by z_offset to hide the background inside the base.
            translate([0, 0, -z_offset])
                scale([scale_xy, scale_xy, scale_z]) {
                    surface(file = file, center = false, invert = invert);
                }
        }
    }
}

// =============================================================================
// MODEL INSTANTIATION
// =============================================================================

// Instantiate the module with our parameters
image_relief(
    file = image_file,
    img_w = image_width_pixels,
    img_h = image_height_pixels,
    target_w = target_width_mm,
    relief_h = relief_height_mm,
    base_t = base_thickness_mm,
    style = badge_style,
    r_corner = corner_radius,
    invert = invert_colors
);
