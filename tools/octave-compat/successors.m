function s = successors(G, u)
  s = find(G.A(u, :)); s = s(:);
end
