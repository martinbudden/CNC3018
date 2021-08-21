//!Display the CNC machine

include <NopSCADlib/core.scad>

use <../scad/Main.scad>


//$explode = 1;
//$pose = 1;
module Main_test() {
    main_assembly();
}

if ($preview)
    Main_test();
