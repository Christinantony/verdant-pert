function [names,preds,durs,arrayTest] = ...
    buildEnclosureStream(names,preds,durs,sched,geometryLocks,start,project)

if project.enclosure_required

    [names,preds,durs,enclosureDesign] = addTask(names,preds,durs,...
        'Enclosure Design',sched('Enclosure Design'),geometryLocks);

    [names,preds,durs,enclosureFab] = addTask(names,preds,durs,...
        'Enclosure Fabrication',sched('Enclosure Fabrication'),enclosureDesign);

    [names,preds,durs,arrayTest] = addTask(names,preds,durs,...
        'Prototype Array Test',sched('Prototype Array Test'),enclosureFab);

else

    arrayTest = start;

end

end