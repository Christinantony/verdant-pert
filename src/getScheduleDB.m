function sched = getScheduleDB()

sched = containers.Map();

% --- Prototype phase ---
sched('EM Simulation')           = 20;
sched('Prototype Fabrication')   = 25;
sched('RF Test')                 = 5;
sched('Cavity Tuning')           = 3;
sched('Spiral Tuning')           = 3;
sched('Tolerance Verification')  = 3;
sched('Radome Integration')      = 4;
sched('Impedance Matching')      = 3;
sched('Structural Validation')   = 4;
sched('Prototype PCB Fabrication') = 10;
sched('Geometry Lock')           = 0;
sched('Prototype Tooling') = 5;

% --- Design phase ---
sched('Drawing Update')          = 7;
sched('QA Approval')             = 5;

% --- Enclosure ---
sched('Enclosure Design')        = 15;
sched('Enclosure Fabrication')   = 25;
sched('Prototype Array Test')    = 7;

% --- Production ---
sched('Production Tooling')     = 30;
sched('Material Procurement')    = 20;
sched('Composite Manufacturing') = 15;
sched('Production PCB Fabrication') = 18;

% --- Final ---
sched('Final Assembly Completion') = 10;
sched('Final System Test')         = 5;

end
