function [names,preds,durs,composite] = ...
    buildCompositeStream(names,preds,durs,sched,geometryLocks,start,compositeRequired)

if compositeRequired

    [names,preds,durs,tooling] = addTask(names,preds,durs,...
        'Production Tooling',sched('Production Tooling'),geometryLocks);

    [names,preds,durs,material] = addTask(names,preds,durs,...
        'Material Procurement',sched('Material Procurement'),geometryLocks);

    [names,preds,durs,composite] = addTask(names,preds,durs,...
        'Composite Manufacturing',sched('Composite Manufacturing'),...
        [tooling material]);

else

    composite = start;

end

end