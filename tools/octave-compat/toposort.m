function order = toposort(G)
  A = G.A; n = G.n; indeg = sum(A, 1); order = [];
  queue = find(indeg == 0);
  while ~isempty(queue)
    u = queue(1); queue(1) = []; order(end+1) = u;
    for v = find(A(u, :))
      indeg(v) = indeg(v) - 1;
      if indeg(v) == 0, queue(end+1) = v; end
    end
  end
  if numel(order) ~= n, error('graph has a cycle'); end
end
