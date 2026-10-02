function antDB = getAntennaDB()

% ===============================
% SPIRAL ANTENNA
% ===============================

antDB.spiral.components = {
    'spiral_cavity'
    'spiral_insert'
    'mounting_bracket'
};

antDB.spiral.workflow = {
    'EM Simulation'
    'Prototype Fabrication'
    'RF Test'
    'Cavity Tuning'
    'Spiral Tuning'
    'Geometry Lock'
};

% ===============================
% HORN ANTENNA
% ===============================

antDB.horn.components = {
    'horn_body'
    'mounting_bracket'
};

antDB.horn.workflow = {
    'EM Simulation'
    'Prototype Fabrication'
    'RF Test'
    'Tolerance Verification'
    'Geometry Lock'
};

% ===============================
% BICONICAL ANTENNA
% ===============================

antDB.biconical.components = {
    'biconical_arm'
    'mounting_bracket'
};

antDB.biconical.workflow = {
    'EM Simulation'
    'Prototype Fabrication'
    'RF Test'
    'Impedance Matching'
    'Geometry Lock'
};

% ===============================
% CONFORMAL ANTENNA
% ===============================

antDB.conformal.components = {
    'conformal_patch'
    'conformal_cover'
    'mounting_bracket'
};

antDB.conformal.workflow = {
    'EM Simulation'
    'Prototype Fabrication'
    'RF Test'
    'Radome Integration'
    'Geometry Lock'
};

% ===============================
% BLADE ANTENNA
% ===============================

antDB.blade.components = {
    'composite_shell'
    'base_plate'
};

antDB.blade.workflow = {
    'EM Simulation'
    'Prototype Fabrication'
    'RF Test'
    'Structural Validation'
    'Geometry Lock'
};

% ===============================
% PLANAR ANTENNA
% ===============================

antDB.planar.components = {
    'composite_shell'
    'base_plate'
    'pcb_layer'
};

antDB.planar.workflow = {
    'EM Simulation'
    'Prototype PCB Fabrication'
    'RF Test'
    'Impedance Matching'
    'Geometry Lock'
};

end
