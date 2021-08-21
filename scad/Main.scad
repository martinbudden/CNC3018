//!# 3018 CNC with linear rails
//
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
