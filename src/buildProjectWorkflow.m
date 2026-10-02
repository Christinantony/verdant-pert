function [names, preds, durs] = buildProjectWorkflow(project)

dbComp = getComponentDB();
sched = getScheduleDB();
dbAnt = getAntennaDB();

names = {};
preds = {};
durs = [];

% --------------------------------------------------
% TASK CREATOR
% --------------------------------------------------

[names,preds,durs,start] = addTask(names,preds,durs,'Start Project',0,[]);

geometryLocks = [];
antennaProductionNodes = [];
compositeRequired = false;

% --------------------------------------------------
% ANTENNA STREAMS
% --------------------------------------------------

for i = 1:length(project.antennas)

    ant = project.antennas{i};

    % ---------------------------
    % PROTOTYPE STREAM
    % ---------------------------

    [names,preds,durs,geom,lastNode] = ...
buildPrototypeStream(names,preds,durs,ant,dbAnt,sched,start);

    geometryLocks = [geometryLocks geom];

    % ---------------------------
% PRODUCTION STREAM
% ---------------------------

compList = dbAnt.(ant.type).components;

[names,preds,durs,nodeList,compFlag] = ...
    buildProductionStream(names,preds,durs,lastNode,compList,dbComp,ant);

compositeRequired = compositeRequired || compFlag;

% ---------------------------
% ANTENNA ASSEMBLY
% ---------------------------

if isempty(nodeList)
    nodeList = lastNode;
end

assemblyTime = 3;

[names,preds,durs,assemblyNode] = addTask(names,preds,durs,...
    ['Assembly - ' ant.type],assemblyTime,nodeList);

antennaProductionNodes = [antennaProductionNodes assemblyNode];

end

% --------------------------------------------------
% ENCLOSURE STREAM
% --------------------------------------------------

[names,preds,durs,arrayTest] = ...
    buildEnclosureStream(names,preds,durs,sched,geometryLocks,start,project);

% --------------------------------------------------
% COMPOSITE STRUCTURE STREAM
% --------------------------------------------------

[names,preds,durs,composite] = ...
    buildCompositeStream(names,preds,durs,sched,geometryLocks,start,compositeRequired);

% --------------------------------------------------
% FINAL SYSTEM INTEGRATION
% --------------------------------------------------

[names,preds,durs] = ...
    buildIntegrationStream(names,preds,durs,sched,antennaProductionNodes,composite,arrayTest);

end