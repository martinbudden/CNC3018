include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../../MaybeCube/scad/vitamins/bolts.scad>
use <../../MaybeCube/scad/utils/FrameBolts.scad>
use <../../MaybeCube/scad/vitamins/extrusion.scad>
use <../../MaybeCube/scad/vitamins/leadscrew.scad>

use <cornerBracket.scad>
use <nemaMountingPlate.scad>

include <Parameters_Main.scad>


module Gantry_assembly()
assembly("Gantry", big=true) {

    translate([0, _gantryOffsetY, eSize])
        gantry();
}

module gantry() {
    zOffset = verticalOffsetZ;//2*(eSize+cbSize)+4;
    explode = 100;

    for (x = [0, eX - eSize])
        translate([x, 0, 0])
            explode([x == 0 ? -explode : explode, 0, 0], true) {
                color(_frameColor)
                    render(convexity=2)
                        difference() {
                            extrusionOZ2080Y(eZ);
                            for (z = [0 : eSize : 5*eSize])
                                translate([eSize, 5*eSize/2, eZ -eSize/2 - z])
                                    rotate([0, -90, 0])
                                        jointBoltHole();
                            for (z = [0, 5*eSize])
                                translate([eSize, 3*eSize/2, eZ -eSize/2 - z])
                                    rotate([0, -90, 0])
                                        jointBoltHole();
                            translate([eSize, eSize + rail_height(MGN12), eZ -6*eSize/2])
                                rotate([0, -90, 0])
                                    cylinder(h=eSize, r=8);
                        }
                extrusionOZ2080YEndBoltPositions(eZ, bothEnds=false)
                    boltM5Buttonhead(_endBoltLength);
            }

    _xRailSeparation = 100;
    if (_xRailSeparation == 60) {
        translate([eSize, 0, eZ - 4*eSize])
            extrusionOX2080V(eX);
        xRailsAssembly(_xRailSeparation);
    } else {
        sizeX = eX - 2*eSize;
        for (z = [0, _xRailSeparation])
            explode(z == 0 ? 40 : -40, true)
                translate([eSize, eSize, eZ - eSize - z]) {
                    extrusionOX2040HEndBolts(sizeX);
                    explode([0, -50, 0])
                        translate([eX/2 - eSize, 0, eSize/2])
                            rotate([90, 0, 0]) {
                                pos = 40;
                                rail_assembly(MGN12C_carriage, _xRailLength, pos, carriage_end_colour="green", carriage_wiper_colour="red");
                                translate([pos + 80, 0])
                                    carriage(MGN12C_carriage, end_colour="green", wiper_colour="red");
                            }
                }
        translate([eSize, 2*eSize, eZ - 5*eSize])
            extrusionOX2080VEndBolts(sizeX);
        explode([-300, 0, 0])
            translate([0, eSize, eZ - eSize/2 - _xRailSeparation/2])
                xMotorAssembly();

    }
}

module GantryOld_assembly()
assembly("GantryOld") {

    offsetY = 0;//eY - _gantryOffsetY - eSize;
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
    if (is_undef(_xRodLength))
        xRailsAssembly(eZ - verticalOffsetZ);
    else
        xRods_assembly();
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


module xMotorAssembly() {
    translate([0, rail_height(MGN12), 0]) {
        //translate([eX + 2*eSize + nema17MountingPlateSize().z/2, 0, 0])
            rotate([0, 90, 0]) {
                NEMA_type = NEMA17M;
                NEMA(NEMA_type);
                translate_z(NEMA_shaft_length(NEMA_type)) {
                    shaft_coupling(SC_5x8_rigid, colour = grey(30));
                    translate_z(2)
                        leadscrewX(diameter=8, length=_xLeadScrewLength, center=false);
                }
                *rotate(90)
                    nema17MountingPlate_assembly(boltLength=0);
            }
    }
    *translate([eSize/2, -kp_hole_offset(KPtype), 0]) {
        rotate([180, 90, 0]) kp_pillow_block_assembly(KPtype);
    }
}

module xRods_assembly()
assembly("xRods") {

    SKSize = sk_size(SKtype);
    skHoleOffset = sk_hole_offset(SKtype);

    translate([(eX + 2*eSize)/2, -skHoleOffset, eZ - SKSize.x/2]) {
        for (z = [0, -xRodSeparation])
            translate_z(z)
                rotate([0, 90, 0])
                    rod(d=_xRodDiameter, l=_xRodLength);
    }
    translate_z(eZ - SKSize.x/2 - _xRodSeparation/2)
        xMotorAssembly();

    translate([eSize/2, 0, -SKSize.x/2]) {
        translate([0, -sk_hole_offset(SKtype), 0]) {
            translate([0, 0, eZ])
                rotate([180, 90, 0])
                    sk_bracket_assembly(SKtype);
            translate([0, 0, eZ - _xRodSeparation])
                rotate([180, 90, 0])
                    sk_bracket_assembly(SKtype);
            translate([eX+eSize, 0, eZ])
                rotate([180, 90, 0])
                    sk_bracket_assembly(SKtype);
            translate([eX+eSize, 0, eZ - _xRodSeparation])
                rotate([180, 90, 0])
                    sk_bracket_assembly(SKtype);
        }
    }
}

LM8Size = [24, 15]; // length, diameter
LM10Size = [29, 19]; // length, diameter
LM12Size = [30, 21]; // length, diameter
module xRailsAssembly(xRailSeparation) {
    translate([eX/2, 0, eZ - eSize/2]) {
        rotate([90, 0, 0])
            rail_assembly(MGN12H_carriage, _xRailLength, 20);
        translate_z(-xRailSeparation)
            rotate([90, 0, 0])
                rail_assembly(MGN12H_carriage, _xRailLength, 20);
    }
    translate_z(eZ - eSize/2 - xRailSeparation/2)
        xMotorAssembly();
}
