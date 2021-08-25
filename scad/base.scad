include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pillow_blocks.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/shaft_couplings.scad>
include <NopSCADlib/vitamins/sheet.scad>
include <NopSCADlib/vitamins/sk_brackets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

use <../../MaybeCube/scad/vitamins/bolts.scad>
use <../../MaybeCube/scad/utils/FrameBolts.scad>
use <../../MaybeCube/scad/vitamins/extrusion.scad>
use <../../MaybeCube/scad/vitamins/leadscrew.scad>

use <cornerBracket.scad>
use <nemaMountingPlate.scad>

include <Parameters_Main.scad>

SKtype = SK8;
KPtype = KP08_15;

AL3 = [ "AL3", "Aluminium plate", 3, [0.9, 0.9, 0.9, 1], false];

module sheetBoltHoles(size) {
    for (x = [eSize/2, size.x - eSize/2], y = [eSize/2, size.y - eSize/2])
        translate([x, y])
            children();
}
//!drilledSheet([100, 50]);
module drilledSheet(size) {
    color("silver")
        difference() {
            sheet(AL3, size.x, size.y);
            sheetBoltHoles(size)
                boltHoleM4(3);
        }
    *sheetBoltHoles(size)
        boltM4ButtonheadTNut(8);
}

module baseCutouts(size, cncSides=undef, radius=undef) {
    sheetBoltHoles(size)
        poly_circle(is_undef(radius) ? M4_clearance_radius : radius, sides=cncSides);
}

module BaseAL_dxf() {
    size = _basePlateSize;

    dxf("BaseAL")
        color(silver)
            difference() {
                sheet_2D(AL3, size.x, size.y, corners=2);
                translate([-size.x/2, -size.y/2])
                    baseCutouts(size, cncSides=0);
            }
}

module BaseAL() {
    size = _basePlateSize;

    translate([size.x/2, size.y/2, -size.z/2])
        render_2D_sheet(AL3, w=size.x, d=size.y)
            BaseAL_dxf();
}

module baseMotorAssembly(leadScrewOffset) {
    translate([eX/2, eY + nema17MountingPlateSize().z/2, eSize + leadScrewOffset]) {
        rotate([90, 90, 0]) {
            NEMA_type = NEMA17M;
            NEMA(NEMA_type);
            translate_z(NEMA_shaft_length(NEMA_type)) {
                shaft_coupling(SC_5x8_rigid, colour = grey(30));
                translate_z(2)
                    leadscrewX(diameter=8, length=_yLeadScrewLength, center=false);
            }
            //nema17MountingPlate_assembly();
        }
    }
}

module Base_assembly(explodeBase=-50)
assembly("Base", big=true) {
    if (is_undef(_xRodLength))
        base3Assembly(explodeBase=explodeBase);
    else
        base1Assembly();
}

module base1Assembly() {

    translate([eSize, 0, 0])
        extrusionOX(eX, eSize);
    translate([eSize, eY - eSize, 0])
        extrusionOX(eX, eSize);
    translate([eSize, _gantryOffsetY, 0])
        extrusionOX(eX, eSize);
    extrusionOY(eY, eSize);
    translate([eX + eSize, 0, 0])
        extrusionOY(eY, eSize);

    BaseAL();

    baseMotorAssembly(leadScrewOffset);

    translate([eSize + eX/2, eSize/2, eSize + kp_hole_offset(KPtype)])
        rotate([90, 0, 0])
            kp_pillow_block_assembly(KPtype);

    translate([eSize, eSize/2, eSize + sk_hole_offset(SKtype)]) {
        translate([_yRodOffsetX, 0, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([eX - _yRodOffsetX, 0, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([_yRodOffsetX, eY - eSize, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
        translate([eX - _yRodOffsetX, eY - eSize, 0]) rotate([90, 0, 0]) sk_bracket_assembly(SKtype);
    }

    translate([eSize, _yRodLength/2, eSize + sk_hole_offset(SKtype)]) {
        translate([_yRodOffsetX, 0, 0]) rotate([90, 0, 0]) rod(d=_yRodDiameter, l=_yRodLength);
        translate([eX - _yRodOffsetX, 0, 0]) rotate([90, 0, 0]) rod(d=_yRodDiameter, l=_yRodLength);
    }

    translate([eSize, eSize, eSize/2]) cornerBracket();
    translate([eX + eSize, eSize, eSize/2]) rotate(90) cornerBracket();
    translate([eSize, _gantryOffsetY, eSize/2]) rotate(-90) cornerBracket();
    translate([eX + eSize, _gantryOffsetY, eSize/2]) rotate(180) cornerBracket();
    translate([eSize, eY - eSize, eSize/2]) rotate(-90) cornerBracket();
    translate([eX + eSize, eY - eSize, eSize/2]) rotate(180) cornerBracket();
}


module base2Assembly() {

    yRailOffsetX = 100;

    extrusionOX(eX, eSize);
    translate([0, eY+eSize, 0])
        extrusionOX(eX);
    translate([0, eSize, 0])
        extrusionOY(eY);
    translate([eX - eSize, eSize, 0])
        extrusionOY(eY);
    translate([yRailOffsetX - eSize/2, eSize, 0]) {
        extrusionOY2040H(eY);
        translate([3*eSize/2, _yRailLength/2, eSize])
            rotate(90)
                rail_assembly(MGN12H_carriage, _yRailLength, 100);
    }
    translate([eX - 2*eSize - yRailOffsetX + eSize/2, eSize, 0]) {
        extrusionOY2040H(eY);
        translate([eSize/2, _yRailLength/2, eSize])
            rotate(90)
                rail_assembly(MGN12H_carriage, _yRailLength, 100);
    }
    BaseAL();
    baseMotorAssembly(leadScrewOffset);
}

module base3Assembly(explodeBase=-50) {

    yRailOffsetX = 50;
    xBoltHoles = [eSize/2, 3*eSize/2, 5*eSize/2, 7*eSize/2, eX - eSize/2, eX - 3*eSize/2, eX - 5*eSize/2, eX - 7*eSize/2];
    yBoltHoles = [eSize/2, 3*eSize/2, 5*eSize/2, 7*eSize/2];

    explode = 100;
    for (y = [0, eY + eSize])
        explode([0, y == 0 ? -explode : explode, 0])
            translate([0, y, 0])
                color(_frameColor)
                    render(convexity=2)
                        difference() {
                            extrusionOX(eX, eSize);
                            for (x = xBoltHoles)
                                translate([x, 0, eSize/2])
                                    rotate([-90, 0, 0])
                                        jointBoltHole();
                        }

    for (x = [0, eX - 4*eSize])
        explode([x == 0 ? -explode : explode, 0, 0], true)
            translate([x, eSize, 0]) {
                color(_frameColor)
                    render(convexity=2)
                        difference() {
                            extrusionOY2080H(eY);
                            for (y = yBoltHoles)
                                translate([x == 0 ? eSize/2 : 7*eSize/2, y + _gantryOffsetY - eSize, 0])
                                    jointBoltHole();
                        }
                extrusionOY2080HEndBoltPositions(eY)
                    boltM5Buttonhead(_endBoltLength);
            }

    for (x = [yRailOffsetX + eSize, eX - eSize - yRailOffsetX])
        translate([x, _yRailLength/2 + eSize, eSize])
            explode([x < eX/2 ? -explode : explode, 0, 30])
                rotate(90) {
                    pos = -20;
                    rail_assembly(MGN12H_carriage, _yRailLength, pos, carriage_end_colour="green", carriage_wiper_colour="red");
                    translate([pos + 120, 0])
                        carriage(MGN12H_carriage, end_colour="green", wiper_colour="red");
                }

    explode(explodeBase)
        BaseAL();
    explode([0, explode + 50, 0])
        translate([0, 2*eSize, 0])
            baseMotorAssembly(rail_height(MGN12));
}
