//!Displays the corner brackets.

include <NopSCADlib/core.scad>

use <../scad/cornerbracket.scad>


//$explode = 1;
//$pose = 1;
module CornerBracket_test() {
    cornerBracket(innerCornerBrackets=false);
    translate([40, 0, 0])
        cornerBracket(innerCornerBrackets=true);
}

if ($preview)
    CornerBracket_test();
