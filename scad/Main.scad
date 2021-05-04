include <global_defs.scad>
include <NopSCADlib/core.scad>

include <CNC3018.scad>

include <Parameters_Main.scad>


module main_assembly()
assembly("main", big=true) {
    assert(!is_undef(_variant));

    FinalAssembly();
}

if ($preview)
    main_assembly();
