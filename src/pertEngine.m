function [totalDuration, ES, EF] = pertEngine(names, preds, durs)
[s, t] = convertToEdges(preds);
G = digraph(s, t);
order = toposort(G);
n = length(names);
ES = zeros(n,1);
EF = zeros(n,1);
for i = 1:length(order)
    u = order(i);
    parents = predecessors(G, u);
    if isempty(parents)
        ES(u) = 0;
    else
        ES(u) = max(EF(parents));
    end
    EF(u) = ES(u) + durs(u);
end
totalDuration = max(EF);
end

