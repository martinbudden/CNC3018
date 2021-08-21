//!# 3018 CNC with linear rails
//!
//!This is just a rough sketch of the frame using linear rails and hidden joints.

include <global_defs.scad>
include <NopSCADlib/core.scad>

use <base.scad>
use <gantry.scad>

module main_assembly()
assembly("main", big=true) {

    Base_assembly();
    Gantry_assembly();
}

if ($preview)
    main_assembly();
