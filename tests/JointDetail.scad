//!Display an the detail of a hidden joint

include <../scad/global_defs.scad>

include <NopSCADlib/core.scad>

use <../../MaybeCube/scad/vitamins/bolts.scad>
use <../../MaybeCube/scad/utils/FrameBolts.scad>
use <../../MaybeCube/scad/vitamins/extrusion.scad>

include <../scad/Parameters_Main.scad>


module Joint_test() {

    xBoltHoles = [eSize/2, 3*eSize/2, 5*eSize/2, 7*eSize/2, eX - eSize/2, eX - 3*eSize/2, eX - 5*eSize/2, eX - 7*eSize/2];
    yBoltHoles = [eSize/2, 3*eSize/2, 5*eSize/2, 7*eSize/2];

    color(_frameColor)
        render(convexity=2)
            difference() {
                extrusionOX(eX, eSize);
                for (x = xBoltHoles)
                    translate([x, 0, eSize/2])
                        rotate([-90, 0, 0])
                            jointBoltHole();
            }

    translate([0, eSize, 0]) {
        extrusionOY2080H(eY);
        extrusionOY2080HEndBoltPositions(eY)
            boltM5Buttonhead(_endBoltLength);
    }
}

if ($preview)
    Joint_test();
