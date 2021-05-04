//!Displays the base.

include <NopSCADlib/core.scad>

use <../scad/CNC3018.scad>
use <../scad/base.scad>


//$explode = 1;
//$pose = 1;
module Base_test() {
    base_assembly();
    base2_assembly();
}

if ($preview)
    Base_test();
