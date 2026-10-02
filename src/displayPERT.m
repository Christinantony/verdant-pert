function displayPERT(names,preds,durs,ES,EF,criticalNodes)

[s,t] = convertToEdges(preds);
G = digraph(s,t);

figure
h = plot(G,'Layout','layered','Direction','right');
h.NodeLabel = names;

highlight(h,criticalNodes,'NodeColor','red','MarkerSize',7)

title('Verdant PERT Network')

figure

n = length(names);

for i = 1:n

barh(i,durs(i))
hold on

patch([ES(i) EF(i) EF(i) ES(i)],[i-0.4 i-0.4 i+0.4 i+0.4],[0.6 0.8 1])

end

yticks(1:n)
yticklabels(names)

xlabel('Days')
title('Project Gantt Chart')

hold off

end
