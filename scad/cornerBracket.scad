include <global_defs.scad>

include <NopSCADlib/core.scad>

use <../../MaybeCube/scad/vitamins/extrusionBracket.scad>

include <Parameters_Main.scad>


module outerCornerBracket(color="silver") {
    baseThickness = 2;

    module base() {
        linear_extrude(baseThickness)
            difference() {
                translate([0, -eSize/2, 0])
                    square([cbSize, eSize]);
                hull() {
                    translate([cbSize-7, 0, 0])
                        circle(r=M5_clearance_radius);
                    translate([cbSize-10, 0, 0])
                        circle(r=M5_clearance_radius);
                }
            }
    }

    color(color) {
        rotate([90, 0, 90])
            base();
        translate([0, baseThickness, 0])
            rotate([90, 0, 0])
                base();
        sideThickness = 3;
        for (i = [-eSize/2, eSize/2 - sideThickness]) {
            translate_z(i) {
                right_triangle(cbSize, cbSize, sideThickness, center = false);
                cube([5, cbSize, sideThickness]);
                cube([cbSize, 5, sideThickness]);
            }
        }
    }
}

module cornerBracket(innerCornerBrackets=_innerCornerBrackets) {
    if (innerCornerBrackets) {
        extrusionInnerCornerBracket();
    } else {
        outerCornerBracket();
        translate([2.5, 20, 0]) rotate([0, 90, 0]){
            screw(M5_cap_screw, 10);
            translate_z(-0.5) washer(M5_washer);
            translate_z(-7) nut(M5_nut);
        }
        translate([20, 2.5, 0]) rotate([-90, 0, 0]){
            screw(M5_cap_screw, 10);
            translate_z(-0.5) washer(M5_washer);
            translate_z(-7) nut(M5_nut);
        }
    }
}
