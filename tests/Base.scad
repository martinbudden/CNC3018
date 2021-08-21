//!Displays the base.

include <NopSCADlib/core.scad>

use <../scad/base.scad>


//$explode = 1;
//$pose = 1;
module Base_test() {
    Base_assembly();
}

if ($preview)
    Base_test();
