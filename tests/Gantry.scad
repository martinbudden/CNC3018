//!Displays the gantry.

include <NopSCADlib/core.scad>

use <../scad/gantry.scad>


//$explode = 1;
//$pose = 1;
module Gantry_test() {
    gantry();
}

if ($preview)
    Gantry_test();
