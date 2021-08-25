//!Display an exploded view of the CNC machine

include <NopSCADlib/core.scad>

use <../scad/base.scad>
use <../scad/gantry.scad>


$explode = 1;
module Exploded_View_test() {
    Base_assembly(explodeBase=0);

    explode(100, true)
        Gantry_assembly();
}

if ($preview)
    Exploded_View_test();
