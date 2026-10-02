function criticalNodes = extractCriticalPath(names,preds,durs)

[s,t] = convertToEdges(preds);
G = digraph(s,t);

order = toposort(G);

n = length(names);

dist = zeros(n,1);      % longest distance to node
parent = zeros(n,1);    % predecessor tracking

for k = 1:length(order)

    u = order(k);

    succ = successors(G,u);

    for v = succ'

        if dist(v) < dist(u) + durs(v)

            dist(v) = dist(u) + durs(v);
            parent(v) = u;

        end

    end

end

% find node with maximum distance
[~,finish] = max(dist);

% backtrack critical path
criticalNodes = finish;

while parent(finish) ~= 0
    finish = parent(finish);
    criticalNodes = [finish criticalNodes];
end

end
