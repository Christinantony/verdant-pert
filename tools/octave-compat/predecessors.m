function p = predecessors(G, u)
  p = find(G.A(:, u))';  p = p(:);
end
