include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/washers.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/sheet.scad>
include <NopSCADlib/vitamins/pillow_blocks.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
include <NopSCADlib/vitamins/sk_brackets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../../MaybeCube/scad/vitamins/bolts.scad>
use <../../MaybeCube/scad/vitamins/extrusion.scad>
use <../../MaybeCube/scad/vitamins/extrusionBracket.scad>
use <../../MaybeCube/scad/vitamins/leadscrew.scad>

use <base.scad>
include <Parameters_Main.scad>


cbSize = 28; // corner bracket

_basePlateSize = [eX + 2*eSize, eY, 3];

//verticalOffsetY = 330 - 2*eSize - 2*cbSize - 4;
verticalOffsetY = 330 - 2*eSize - cbSize - 2;
verticalOffsetZ = 220 - eSize - 2*cbSize - 4;
xRodLength = 395;
xRodDiameter = 10;
yRodLength = 325;
yRodDiameter = 10;
leadScrewOffset = 18;
xLeadScrewLength = 380;
yLeadScrewLength = 310;
innerCornerBrackets = false;
yRodOffsetX = 90;

SKtype = SK8;
KPtype = KP08_15;

module FinalAssembly() {
    base_assembly();
    translate([0, verticalOffsetY, eSize])
        vertical_assembly();
}

module base_assembly()
assembly("base") {

    translate([eSize, 0, 0]) extrusionOX(eX, eSize);
    translate([eSize, eY - eSize, 0]) extrusionOX(eX, eSize);
    translate([eSize, verticalOffsetY, 0]) extrusionOX(eX, eSize);
    extrusionOY(eY, eSize);
    translate([eX + eSize, 0, 0]) extrusionOY(eY, eSize);

    BaseAL();

    translate([eX/2 + eSize, eY + nema17MountingPlateSizeFn().z/2, eSize + leadScrewOffset]) {
        rotate([90, 90, 0]) {
            NEMA_type = NEMA17M;
            NEMA(NEMA_type);
            translate_z(NEMA_shaft_length(NEMA_type)) {
                shaft_coupling(SC_5x8_rigid, colour = grey(30));
                translate_z(2)
                    leadscrewX(diameter=8, length=yLeadScrewLength, center=false);
            }
            nema17MountingPlate_assembly();
        }
    }
    translate([eSize + eX/2, eSize/2, eSize + kp_hole_offset(KPtype)])
        rotate([90, 0, 0])
            kp_pillow_block_assembly(KPtype);

    translate([eSize, eSize/2, eSize + sk_hole_offset(SKtype)]) {
        translate([yRodOffsetX, 0, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([eX - yRodOffsetX, 0, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([yRodOffsetX, eY - eSize, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([eX - yRodOffsetX, eY - eSize, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
    }

    translate([eSize, yRodLength/2, eSize + sk_hole_offset(SKtype)]) {
        translate([yRodOffsetX, 0, 0]) rotate([90, 0, 0]) rod(d=yRodDiameter, l=yRodLength);
        translate([eX - yRodOffsetX, 0, 0]) rotate([90, 0, 0]) rod(d=yRodDiameter, l=yRodLength);
    }

    translate([eSize, eSize, eSize/2]) cornerBracket();
    translate([eX + eSize, eSize, eSize/2]) rotate(90) cornerBracket();
    translate([eSize, verticalOffsetY, eSize/2]) rotate(-90) cornerBracket();
    translate([eX + eSize, verticalOffsetY, eSize/2]) rotate(180) cornerBracket();
    translate([eSize, eY - eSize, eSize/2]) rotate(-90) cornerBracket();
    translate([eX + eSize, eY - eSize, eSize/2]) rotate(180) cornerBracket();
}

module vertical_assembly()
assembly("vertical") {

    offsetY = 0;//eY - verticalOffsetY - eSize;
    verticalExtrusion(useSheet=!true);
    if (offsetY) {
        translate([0, offsetY, 0]) verticalExtrusion(useSheet=false);
        sheetSize = [eZ+eSize, offsetY+eSize, 3];
        translate([-sheetSize.z/2, sheetSize.y/2, sheetSize.x/2-eSize])
            rotate([0, 90, 0])
                drilledSheet(sheetSize);
        translate([eX+2*eSize+sheetSize.z/2, sheetSize.y/2, sheetSize.x/2-eSize])
            rotate([0, -90, 0])
                drilledSheet(sheetSize);
    }
    if (_variant=="RODS")
        yRods_assembly();
    else
        yRails_assembly();
}

module verticalExtrusion(useSheet=true) {

    zOffset = verticalOffsetZ;//2*(eSize+cbSize)+4;
    extrusionOZ(eZ, eSize);
    translate([eX + eSize, 0, 0]) extrusionOZ(eZ, eSize);
    translate([eSize, 0, eZ - eSize]) extrusionOX(eX, eSize);
    translate([eSize, 0, zOffset - eSize]) extrusionOX(eX, eSize);
    sheetSize = [eX + 2*eSize, eZ - zOffset + eSize, 3];
    if (useSheet)
        translate([sheetSize.x/2, eSize + sheetSize.z/2, eZ - sheetSize.y/2])
            rotate([90, 0, 0])
                drilledSheet(sheetSize);
    translate([eSize, eSize/2, eZ - eSize]) rotate([-90, 0, 0]) cornerBracket();
    translate([eSize + eX, eSize/2, eZ - eSize]) rotate([-90, 90, 0]) cornerBracket();
    translate([eSize + eX, eSize/2, zOffset]) rotate([90, -90, 0]) cornerBracket();
    translate([eSize, eSize/2, zOffset]) rotate([90, 0, 0]) cornerBracket();
    translate([eSize + eX, eSize/2, 0]) rotate([90, -90, 0]) cornerBracket();
    translate([eSize, eSize/2, 0]) rotate([90, 0, 0]) cornerBracket();

    translate([3*eSize/2 + eX, 0, 0]) rotate([90, 0, -90]) cornerBracket();
    translate([eSize/2, 0, 0]) rotate([90, 0, -90]) cornerBracket();

}


module yMotor_assembly()
assembly("yMotor") {
    translate([0, -eSize + 2, 0]) {
        translate([eX + 2*eSize + nema17MountingPlateSizeFn().z/2, 0, 0]) {
            rotate([0, -90, 0]) {
                NEMA_type = NEMA17M;
                NEMA(NEMA_type);
                translate_z(NEMA_shaft_length(NEMA_type)) {
                    shaft_coupling(SC_5x8_rigid, colour = grey(30));
                    translate_z(2)
                        leadscrewX(diameter=8, length=xLeadScrewLength, center=false);
                }
                rotate(90)
                    nema17MountingPlate_assembly(boltLength=0);
            }
        }
    }
    *translate([eSize/2, -kp_hole_offset(KPtype), 0]) {
        rotate([180, 90, 0]) kp_pillow_block_assembly(KPtype);
    }
}

module yRods_assembly()
assembly("yRods") {

    yRodSeparation = 72;

    SKSize = sk_size(SKtype);
    skHoleOffset = sk_hole_offset(SKtype);
    translate([(eX + 2*eSize)/2, -skHoleOffset, eZ - SKSize.x/2]) {
        for (z=[0, -yRodSeparation])
            translate_z(z)
                rotate([0, 90, 0])
                    rod(d=xRodDiameter, l=xRodLength);
    }
    translate_z(eZ-SKSize.x/2-yRodSeparation/2)
            yMotor_assembly();

    translate([eSize/2, 0, -SKSize.x/2]) {
        translate([0, -sk_hole_offset(SKtype), 0]) {
            translate([0, 0, eZ]) rotate([180, 90, 0]) sk_bracket_assembly(SKtype);
            translate([0, 0, eZ-yRodSeparation]) rotate([180, 90, 0]) sk_bracket_assembly(SKtype);
            translate([eX+eSize, 0, eZ]) rotate([180, 90, 0]) sk_bracket_assembly(SKtype);
            translate([eX+eSize, 0, eZ-yRodSeparation]) rotate([180, 90, 0]) sk_bracket_assembly(SKtype);
        }
    }
}

LM8Size = [24, 15]; // length, diameter
LM10Size = [29, 19]; // length, diameter
LM12Size = [30, 21]; // length, diameter
module yRails_assembly()
assembly("yRails") {

    yRailLength = 400;
    yRailSeparation = eZ - verticalOffsetZ;
    translate([eX/2 + eSize, 0, eZ - eSize/2]) {
        rotate([90, 0, 0])
            rail_assembly(MGN12H_carriage, yRailLength, 20);
        translate_z(-yRailSeparation)
            rotate([90, 0, 0])
                rail_assembly(MGN12H_carriage, yRailLength, 20);
    }
    translate_z(eZ - eSize/2 - railSeparation/2)
        yMotor_assembly();
}

module outerCornerBracket(color="silver") {
    eSize = 20;
    cbSize = 28;
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

module cornerBracket() {
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

//!translate_z(0)nema17MountingPlate();
module nema17MountingPlate() {
    vitamin(str("nema17MountingPlate() : NEMA17 mounting plate"));
    //NEMA(NEMA17M);
    eSize = 20;
    type = NEMA17M;
    size = nema17MountingPlateSizeFn();
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
function nema17MountingPlateSizeFn() = [NEMA_width(NEMA17M)+16.8, NEMA_width(NEMA17M), 3];

//!nema17MountingPlate_assembly();
module nema17MountingPlate_assembly(boltLength=10)
assembly("NEMA 17 mounting plate") {
    nema17MountingPlate();
    size = nema17MountingPlateSizeFn();
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
