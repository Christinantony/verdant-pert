function [LS, LF, slack] = computeSlackPERT(names,preds,durs,ES,EF)

[s,t] = convertToEdges(preds);
G = digraph(s,t);

order = flip(toposort(G));

n = length(names);

LF = zeros(n,1);
LS = zeros(n,1);

projectEnd = max(EF);

% initialize terminal nodes
for i = 1:n
    LF(i) = projectEnd;
end

for k = 1:length(order)

    u = order(k);

    succ = successors(G,u);

    if isempty(succ)
        LF(u) = projectEnd;
    else
        LF(u) = min(LS(succ));
    end

    LS(u) = LF(u) - durs(u);

end

slack = LS - ES;

end
