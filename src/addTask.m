function [names,preds,durs,id] = addTask(names,preds,durs,name,duration,predecessorList)

names{end+1} = name;
durs(end+1) = duration;
preds{end+1} = predecessorList;

id = length(names);

end