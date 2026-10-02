% Minimal stand-in for MATLAB's digraph, enough for VerdantPERT under GNU Octave.
function G = digraph(s, t)
  n = max([s(:); t(:)]);
  A = zeros(n, n);
  for k = 1:numel(s)
    A(s(k), t(k)) = 1;
  end
  G = struct('A', A, 'n', n, 'isdigraph', true);
end
