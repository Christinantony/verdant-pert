function [names,preds,durs,geometryLocks,lastNode] = ...
    buildPrototypeStream(names,preds,durs,ant,dbAnt,sched,start)

geometryLocks = [];

workflow = dbAnt.(ant.type).workflow;
previousNode = start;

for k = 1:length(workflow)

    stepName = workflow{k};

    if strcmp(stepName,'Prototype Fabrication')

        toolDur = sched('Prototype Tooling');

        [names,preds,durs,toolNode] = addTask(names,preds,durs,...
            ['Prototype Tooling - ' ant.type],toolDur,previousNode);

        duration = sched(stepName);

        [names,preds,durs,node] = addTask(names,preds,durs,...
            [stepName ' - ' ant.type],duration,toolNode);

    else

        duration = sched(stepName);

        [names,preds,durs,node] = addTask(names,preds,durs,...
            [stepName ' - ' ant.type],duration,previousNode);

    end

    previousNode = node;

    if strcmp(stepName,'Geometry Lock')
        geometryLocks = [geometryLocks node];
    end

end

[names,preds,durs,draw] = addTask(names,preds,durs,...
    ['Drawing Update - ' ant.type],sched('Drawing Update'),previousNode);

[names,preds,durs,qa] = addTask(names,preds,durs,...
    ['QA Approval - ' ant.type],sched('QA Approval'),draw);

lastNode = qa;

end