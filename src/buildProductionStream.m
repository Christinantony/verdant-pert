function [names,preds,durs,nodeList,compositeRequired] = ...
    buildProductionStream(names,preds,durs,qa,compList,dbComp,ant)

machiningDur = [];
compositeDur = [];
procureDur = [];
pcbDur = [];

compositeRequired = false;

for j = 1:length(compList)

    comp = dbComp.(compList{j});
    dur = computeComponentDuration(comp, ant.quantity);

    switch comp.process

        case 'machining'
            machiningDur = [machiningDur dur];

        case 'composite'
            compositeDur = [compositeDur dur];
            compositeRequired = true;

        case 'procurement'
            procureDur = [procureDur dur];

        case 'pcb'
            pcbDur = [pcbDur dur];

    end

end

nodeList = [];

if ~isempty(machiningDur)
    [names,preds,durs,node] = addTask(names,preds,durs,...
        ['Machining - ' ant.type],max(machiningDur),qa);
    nodeList = [nodeList node];
end

if ~isempty(compositeDur)
    [names,preds,durs,node] = addTask(names,preds,durs,...
        ['Composite - ' ant.type],max(compositeDur),qa);
    nodeList = [nodeList node];
end

if ~isempty(procureDur)
    [names,preds,durs,node] = addTask(names,preds,durs,...
        ['Procurement - ' ant.type],max(procureDur),qa);
    nodeList = [nodeList node];
end

if ~isempty(pcbDur)
    [names,preds,durs,node] = addTask(names,preds,durs,...
        ['Production PCB Fabrication - ' ant.type],max(pcbDur),qa);
    nodeList = [nodeList node];
end

end