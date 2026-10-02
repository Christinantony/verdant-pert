function criticalNodes = getCriticalPath(names, preds, ES, EF)

% Build graph
[s,t] = convertToEdges(preds);
G = digraph(s,t);

A = adjacency(G);   % adjacency matrix

n = length(names);
projectEnd = max(EF);

criticalNodes = [];

for i = 1:n
    
    % Find successors using adjacency matrix
    succ = find(A(i,:) > 0);
    
    if isempty(succ)
        % If no successors, check if it finishes at project end
        if abs(EF(i) - projectEnd) < 1e-6
            criticalNodes(end+1) = i;
        end
        
    else
        
        for j = succ
            
            if abs(ES(j) - EF(i)) < 1e-6
                criticalNodes(end+1) = i;
                break
            end
            
        end
        
    end
    
end

criticalNodes = unique(criticalNodes);

end
