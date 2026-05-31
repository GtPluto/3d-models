/*
================================================================================
   Parameterizable Desk Schoolbag Hook (E-Shape Clamp with Curved Hook)
   Designed by Antigravity
   
   This model is fully parametric and optimized for 3D printing.
   It features rounded tips, structural reinforcement fillets, and is
   designed to print flat on its side for maximum tensile strength.
================================================================================
*/

/* [Desk Clamp Parameters] */
// Thickness of your desk/table (in mm).
desk_thickness = 27.15; // [5:1:50]

// How deep the clamp slides onto the desk surface (in mm).
clamp_depth = 40; // [20:1:80]

// The thickness of the hook structure (in mm). Controls overall strength.
material_thickness = 6; // [4:0.5:15]

// Width of the hook (in mm). The extrusion depth.
hook_width = 20; // [10:1:100]

/* [Hook Parameters] */
// Inner radius of the curved hook (in mm). Larger = fits wider straps.
hook_radius = 15; // [10:1:40]

// Vertical clearance gap between the clamp bottom and the hook top (in mm).
hook_gap = 20; // [10:1:60]

// Height of the front tip of the hook (in mm) to prevent the bag from slipping off.
hook_tip_height = 3; // [5:1:30]

/* [Strength & Aesthetics] */
// Radius of the inner fillets to reduce stress concentration (in mm).
fillet_radius = 2.5; // [0:0.5:5]

// Smoothness factor for circles and arcs (higher = smoother, slower render)
$fn = 80; // [30:5:150]


// =============================================================================
// HELPER MODULES
// =============================================================================

// Horizontal arm with a rounded end to prevent scratching and look premium
module rounded_horizontal_arm(length, thickness) {
    union() {
        square([length - thickness/2, thickness]);
        translate([length - thickness/2, thickness/2])
            circle(d = thickness);
    }
}

// Vertical arm with a rounded end
module rounded_vertical_arm(height, thickness) {
    union() {
        square([thickness, height - thickness/2]);
        translate([thickness/2, height - thickness/2])
            circle(d = thickness);
    }
}

// A standard 2D fillet to reinforce inner 90-degree corners
module corner_fillet(r) {
    if (r > 0) {
        difference() {
            square([r, r]);
            translate([r, r]) circle(r = r);
        }
    }
}

// =============================================================================
// 2D PROFILE GENERATION
// =============================================================================

module hook_2d_profile() {
    T = material_thickness;
    H = desk_thickness;
    L = clamp_depth;
    R = hook_radius;
    G = hook_gap;
    Tip = hook_tip_height;
    Rf = fillet_radius;
    Ro = Rf; // Use the fillet radius for outer corner rounding as well

    // y-coordinate of the hook's top surface
    y_hook_top = -T - G;

    difference() {
        union() {
            // 1. Top Clamp Arm (rests on top of the desk)
            translate([0, H]) 
                rounded_horizontal_arm(L, T);
            
            // 2. Middle Clamp Arm (clamps under the desk)
            translate([0, -T]) 
                rounded_horizontal_arm(L, T);
            
            // 3. Vertical Spine (connects top clamp, middle clamp, and hook)
            // Spans from the top of the top arm (H + T) down to the hook top (y_hook_top)
            translate([-T, y_hook_top]) 
                square([T, H + 2*T + G]);
            
            // 4. The Curved Hook (Semi-circle)
            // Centered at (R, y_hook_top) so the outer boundary aligns with the spine at x = -T
            translate([R, y_hook_top]) {
                difference() {
                    circle(r = R + T);
                    circle(r = R);
                    // Keep only the bottom half (y <= 0 in local space)
                    translate([-(R + T), 0]) 
                        square([2 * (R + T), R + T]);
                }
            }
            
            // 5. Hook Tip (vertical security block)
            translate([2*R, y_hook_top]) 
                rounded_vertical_arm(Tip, T);
                
            // 6. Structural Fillets (Reinforcements for strength under load)
            if (Rf > 0) {
                // Upper clamp inner corner fillet (smooth transition from spine to top arm)
                translate([0, H - Rf])
                    difference() {
                        square([Rf, Rf]);
                        translate([Rf, 0]) circle(r = Rf);
                    }
                
                // Lower clamp inner corner fillet (smooth transition from spine to middle arm)
                translate([0, 0])
                    corner_fillet(Rf);
            }
        }
        
        // 7. Outer Top-Left Corner Rounding (avoids sharp edges on the outside)
        if (Ro > 0) {
            translate([-T, H + T - Ro])
                difference() {
                    square([Ro + 0.1, Ro + 0.1]);
                    translate([Ro, 0]) circle(r = Ro);
                }
        }
    }
}

// =============================================================================
// 3D MODEL ASSEMBLY
// =============================================================================

// Extrude the 2D profile to the specified width and apply a premium color
color("#2B5C8F") // Elegant deep slate blue
    linear_extrude(height = hook_width, center = true)
        hook_2d_profile();
