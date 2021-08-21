include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <Parameters_Main.scad>


function nema17MountingPlateSize() = [NEMA_width(NEMA17M) + 16.8, NEMA_width(NEMA17M), 3];


module nema17MountingPlate() {
    vitamin(str("nema17MountingPlate() : NEMA17 mounting plate"));
    //NEMA(NEMA17M);
    type = NEMA17M;
    size = nema17MountingPlateSize();
    //echo("size=", size);
    //echo("tt=", (size.x-NEMA_width(type))/2);
    size2d = [size.x, size.y];

    translate([-NEMA_width(type)/2, -NEMA_width(type)/2, -size.z/2])
    linear_extrude(size.z) difference() {
        rounded_square(size2d, 3, center=false);
        translate([NEMA_width(type)/2, NEMA_width(type)/2]) {
            circle(r=NEMA_boss_radius(type) + 1.5);
            holePos = NEMA_hole_pitch(type)/2;
            for (i = [ [1, 1], [1, -1], [-1, -1], [-1, 1] ])
                translate(i*holePos)
                    circle(r=M3_clearance_radius);
        }
        translate([NEMA_width(type)/2+leadScrewOffset + eSize/2, size.y/2, 0]) {
            translate([0, 15])
                circle(r=M5_clearance_radius);
            translate([0, -15])
                circle(r=M5_clearance_radius);
        }
    }
}

//!nema17MountingPlate_assembly();
module nema17MountingPlate_assembly(boltLength=10)
assembly("NEMA 17 mounting plate") {
    nema17MountingPlate();
    size = nema17MountingPlateSize();
    type = NEMA17M;

    holePos = NEMA_hole_pitch(type)/2;
    translate_z(size.z/2) {
        for (i = [ [1, 1, 0], [1, -1, 0], [-1, -1, 0], [-1, 1, 0] ]) {
            translate(i*holePos)
                screw(M3_cap_screw, 8);
        }
    }

    *if (boltLength) {
        translate([leadScrewOffset + eSize/2, (size.y - NEMA_width(type))/2, -size.z/2]) {
            translate([0, 15, 0])
                boltM4ButtonheadTNut(boltLength, 90);
            translate([0, -15, 0])
                boltM4ButtonheadTNut(boltLength, 90);
        }
    }
}
