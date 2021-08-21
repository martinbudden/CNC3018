_variant = "CNC3018LR";

// 3018 CNC uses [360, 330, 220]
// need [400, 290, 220] to give same size as 3018 CNC
__extrusionLengths = [390, 300, 250];
eX = __extrusionLengths.x;
eY = __extrusionLengths.y;
eZ = __extrusionLengths.z;

eSize = 20;

_basePlateSize = [eX, eY + 2*eSize, 3];

_xLeadScrewLength = 350;
_yLeadScrewLength = 300;

_xRailLength = floor((eX - 2*eSize)/50)*50;
_yRailLength = eY;
_endBoltLength = 12;
