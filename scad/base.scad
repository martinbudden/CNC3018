include <global_defs.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rails.scad>
include <NopSCADlib/vitamins/sheet.scad>

use <../../MaybeCube/scad/vitamins/bolts.scad>
use <../../MaybeCube/scad/vitamins/extrusion.scad>
use <../../MaybeCube/scad/vitamins/extrusionBracket.scad>
use <../../MaybeCube/scad/vitamins/leadscrew.scad>

include <Parameters_Main.scad>


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

module base2_assembly()
assembly("base2") {

//__extrusionLengths = [360, 330, 220];
    eX = 400;
    eY = 290;

    yRailLength = eY;
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
        translate([3*eSize/2, yRailLength/2, eSize])
            rotate(90)
                rail_assembly(MGN12H_carriage, yRailLength, 100);
    }
    translate([eX - 2*eSize - yRailOffsetX + eSize/2, eSize, 0]) {
        extrusionOY2040H(eY);
        translate([eSize/2, yRailLength/2, eSize])
            rotate(90)
                rail_assembly(MGN12H_carriage, yRailLength, 100);
    }
    BaseAL();
}
