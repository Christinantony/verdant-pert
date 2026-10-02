% Synthetic hand-checkable scheduling example added for the portfolio.
% From the repository root, addpath('src'); run this script.
names = {'Start', 'Design', 'Procure', 'Assemble'};
preds = {[], 1, 2, [2 3]};
durs = [0 2 3 1];
[totalDuration, ES, EF] = pertEngine(names, preds, durs);
[LS, LF, slack] = computeSlackPERT(names, preds, durs, ES, EF);
disp(table(names(:), durs(:), ES, EF, LS, LF, slack, ...
    'VariableNames', {'Task','Duration','ES','EF','LS','LF','Slack'}));
fprintf('Expected total: 6 days. Calculated total: %.1f days.
', totalDuration);
