%% VERDANT PERT AUTO SETUP SCRIPT
% Run this once in MATLAB Online

clc;
disp('Setting up VerdantPERT project structure...');

baseFolder = 'VerdantPERT';

if ~exist(baseFolder, 'dir')
    mkdir(baseFolder);
end

%% ===============================
% FILE 1: getComponentDB.m
%% ===============================

componentCode = [
"function compDB = getComponentDB()"
""
"compDB.spiral_cavity = struct( ..."
"    'manufacturing','outsourced', ..."
"    'process','machining', ..."
"    'tooling_required',false, ..."
"    'duration_model','hybrid', ..."
"    'per_unit_time',2, ..."
"    'vendor_lead_time',30);"
""
"compDB.spiral_insert = struct( ..."
"    'manufacturing','inhouse', ..."
"    'process','machining', ..."
"    'tooling_required',false, ..."
"    'duration_model','linear', ..."
"    'per_unit_time',0.5, ..."
"    'vendor_lead_time',0);"
""
"compDB.mounting_bracket = struct( ..."
"    'manufacturing','outsourced', ..."
"    'process','machining', ..."
"    'tooling_required',false, ..."
"    'duration_model','hybrid', ..."
"    'per_unit_time',1, ..."
"    'vendor_lead_time',20);"
""
"compDB.horn_body = struct( ..."
"    'manufacturing','outsourced', ..."
"    'process','machining', ..."
"    'tooling_required',false, ..."
"    'duration_model','hybrid', ..."
"    'per_unit_time',3, ..."
"    'vendor_lead_time',40);"
""
"compDB.composite_panel = struct( ..."
"    'manufacturing','inhouse', ..."
"    'process','composite', ..."
"    'tooling_required',true, ..."
"    'duration_model','linear', ..."
"    'per_unit_time',4, ..."
"    'vendor_lead_time',0);"
""
"compDB.array_enclosure = struct( ..."
"    'manufacturing','outsourced', ..."
"    'process','fabrication', ..."
"    'tooling_required',false, ..."
"    'duration_model','fixed', ..."
"    'per_unit_time',0, ..."
"    'vendor_lead_time',25);"
""
"end"
];

writeFile(baseFolder, 'getComponentDB.m', componentCode);

%% ===============================
% FILE 2: getAntennaDB.m
%% ===============================

antennaCode = [
"function antDB = getAntennaDB()"
""
"antDB.spiral = {"
"    'spiral_cavity'"
"    'spiral_insert'"
"    'mounting_bracket'"
"};"
""
"antDB.horn = {"
"    'horn_body'"
"    'mounting_bracket'"
"};"
""
"end"
];

writeFile(baseFolder, 'getAntennaDB.m', antennaCode);

%% ===============================
% FILE 3: computeComponentDuration.m
%% ===============================

durationCode = [
"function duration = computeComponentDuration(comp, quantity)"
""
"switch comp.duration_model"
"    case 'linear'"
"        duration = comp.per_unit_time * quantity;"
"    case 'fixed'"
"        duration = comp.vendor_lead_time;"
"    case 'hybrid'"
"        linear_time = comp.per_unit_time * quantity;"
"        duration = min(linear_time, comp.vendor_lead_time);"
"    otherwise"
"        error('Unknown duration model');"
"end"
""
"end"
];

writeFile(baseFolder, 'computeComponentDuration.m', durationCode);

%% ===============================
% FILE 4: pertEngine.m
%% ===============================

pertCode = [
"function [totalDuration, ES, EF] = pertEngine(names, preds, durs)"
"[s, t] = convertToEdges(preds);"
"G = digraph(s, t);"
"order = toposort(G);"
"n = length(names);"
"ES = zeros(n,1);"
"EF = zeros(n,1);"
"for i = 1:length(order)"
"    u = order(i);"
"    parents = predecessors(G, u);"
"    if isempty(parents)"
"        ES(u) = 0;"
"    else"
"        ES(u) = max(EF(parents));"
"    end"
"    EF(u) = ES(u) + durs(u);"
"end"
"totalDuration = max(EF);"
"end"
""
"function [s, t] = convertToEdges(preds)"
"s = []; t = [];"
"for i = 1:length(preds)"
"    for p = preds{i}"
"        s(end+1) = p;"
"        t(end+1) = i;"
"    end"
"end"
"end"
];

writeFile(baseFolder, 'pertEngine.m', pertCode);

%% ===============================
% FILE 5: buildProjectWorkflow.m
%% ===============================

workflowCode = [
"function [names, preds, durs] = buildProjectWorkflow(project)"
"dbComp = getComponentDB();"
"dbAnt = getAntennaDB();"
"names = {}; preds = {}; durs = [];"
"function id = addTask(name, duration, predecessorList)"
"    names{end+1} = name;"
"    durs(end+1) = duration;"
"    preds{end+1} = predecessorList;"
"    id = length(names);"
"end"
"start = addTask('Start Project', 0, []);"
"geometryLocks = []; antennaProductionNodes = [];"
"for i = 1:length(project.antennas)"
"    ant = project.antennas{i};"
"    compList = dbAnt.(ant.type);"
"    em = addTask(['EM - ' ant.type], 20, start);"
"    proto = addTask(['Prototype - ' ant.type], 25, em);"
"    rf = addTask(['RF Test - ' ant.type], 5, proto);"
"    tune = addTask(['Tuning - ' ant.type], 3, rf);"
"    lock = addTask(['Geometry Lock - ' ant.type], 0, tune);"
"    geometryLocks = [geometryLocks lock];"
"    draw = addTask(['Drawing Update - ' ant.type], 7, lock);"
"    qa = addTask(['QA Approval - ' ant.type], 5, draw);"
"    outsourcedDurations = []; inhouseDurations = [];"
"    for j = 1:length(compList)"
"        comp = dbComp.(compList{j});"
"        dur = computeComponentDuration(comp, ant.quantity);"
"        if strcmp(comp.manufacturing,'outsourced')"
"            outsourcedDurations = [outsourcedDurations dur];"
"        else"
"            inhouseDurations = [inhouseDurations dur];"
"        end"
"    end"
"    if isempty(outsourcedDurations)"
"        outsourcedTime = 0;"
"    else"
"        outsourcedTime = max(outsourcedDurations);"
"    end"
"    if isempty(inhouseDurations)"
"        inhouseTime = 0;"
"    else"
"        inhouseTime = max(inhouseDurations);"
"    end"
"    productionTime = max(outsourcedTime, inhouseTime);"
"    prod = addTask(['Production - ' ant.type], productionTime, qa);"
"    antennaProductionNodes = [antennaProductionNodes prod];"
"end"
"if project.enclosure_required"
"    enclosureDesign = addTask('Enclosure Design', 15, geometryLocks);"
"    enclosureFab = addTask('Enclosure Fabrication', 25, enclosureDesign);"
"    arrayTest = addTask('Prototype Array Test', 7, enclosureFab);"
"else"
"    arrayTest = start;"
"end"
"if project.tooling_required"
"    tooling = addTask('Tooling Fabrication', 30, geometryLocks);"
"    material = addTask('Material Procurement', 20, geometryLocks);"
"    composite = addTask('Composite Manufacturing', 15, [tooling material]);"
"else"
"    composite = start;"
"end"
"finalAssembly = addTask('Final Assembly Completion', 10, [antennaProductionNodes composite arrayTest]);"
"addTask('Final System Test', 5, finalAssembly);"
"end"
];

writeFile(baseFolder, 'buildProjectWorkflow.m', workflowCode);

%% ===============================
% FILE 6: main.m
%% ===============================

mainCode = [
"clear; clc;"
"project.antennas = {"
"    struct('type','spiral','quantity',40)"
"    struct('type','horn','quantity',8)"
"};"
"project.enclosure_required = true;"
"project.tooling_required = true;"
"[names, preds, durs] = buildProjectWorkflow(project);"
"[totalDuration, ES, EF] = pertEngine(names, preds, durs);"
"fprintf('\nTotal Duration: %.1f days\n', totalDuration);"
];

writeFile(baseFolder, 'main.m', mainCode);

disp('VerdantPERT setup complete.');
disp('Navigate into VerdantPERT folder and run main.m');

%% Helper function
function writeFile(folder, filename, content)
    filepath = fullfile(folder, filename);
    fid = fopen(filepath, 'w');
    for i = 1:length(content)
        fprintf(fid, '%s\n', content(i));
    end
    fclose(fid);
end
