clear; clc;

fprintf('\n============================\n');
fprintf('VERDANT PROJECT DEFINITION\n');
fprintf('============================\n');

% --- Define Project ---
project.antennas = {
    struct('type','spiral','quantity',40)
    struct('type','horn','quantity',8)
};

project.enclosure_required = true;

% --- Build Workflow ---
[names, preds, durs] = buildProjectWorkflow(project);

% --- Run PERT ---
[totalDuration, ES, EF] = pertEngine(names, preds, durs);

% compute slack
[LS, LF, slack] = computeSlackPERT(names,preds,durs,ES,EF);

% extract critical path
criticalNodes = extractCriticalPath(names,preds,durs);

% extract near critical path
nearCriticalNodes = extractNearCriticalPath(slack,2);

% extract milestones
milestones = extractMilestones(names,EF);

fprintf('\n============================\n');
fprintf('PROJECT SCHEDULE SUMMARY\n');
fprintf('============================\n');
fprintf('Total Duration: %.1f days\n\n', totalDuration);

for i = 1:length(names)

    fprintf('%2d. %-35s | ES: %5.1f | EF: %5.1f | Dur: %5.1f\n', ...
        i, names{i}, ES(i), EF(i), durs(i));

end
fprintf('\nSlack (Float)\n');
fprintf('-----------------------------\n');

for i = 1:length(names)

fprintf('%-35s | Slack: %.1f\n',names{i},slack(i));

end

fprintf('\n============================\n');
fprintf('CRITICAL PATH\n');
fprintf('============================\n');

for i = criticalNodes
    fprintf('%s\n', names{i});
end

fprintf('\n============================\n');
fprintf('NEAR CRITICAL TASKS\n');
fprintf('============================\n');

for i = nearCriticalNodes
    fprintf('%s\n', names{i});
end

fprintf('\n============================\n');
fprintf('PROJECT MILESTONES\n');
fprintf('============================\n');

fields = fieldnames(milestones);

% collect milestone times
times = zeros(length(fields),1);

for i = 1:length(fields)
    times(i) = milestones.(fields{i});
end

% sort milestones by date
[timesSorted, idx] = sort(times);
fieldsSorted = fields(idx);

for i = 1:length(fieldsSorted)

    fprintf('%-25s : Day %.1f\n', ...
        fieldsSorted{i}, timesSorted(i));

end
% --- Build Graph ---
[s,t] = convertToEdges(preds);
G = digraph(s,t);

figure

h = plot(G,'Layout','layered','Direction','right');

h.NodeLabel = names;

% --- Highlight critical tasks ---
highlight(h, criticalNodes, ...
    'NodeColor',[1 0.3 0.3], ...
    'MarkerSize',7)

% --- Highlight near critical tasks ---
highlight(h, nearCriticalNodes, ...
    'NodeColor',[1 0.7 0.3], ...
    'MarkerSize',7)

title('Verdant PERT Network')


% --- Gantt Chart ---
figure

n = length(names);

for i = 1:n

    if ismember(i,criticalNodes)

        color = [1 0.4 0.4]; % red

    elseif ismember(i,nearCriticalNodes)

        color = [1 0.7 0.3]; % orange

    else

        color = [0.6 0.8 1]; % blue

    end

    patch([ES(i) EF(i) EF(i) ES(i)], ...
          [i-0.4 i-0.4 i+0.4 i+0.4], ...
          color)

    hold on

end

set(gca,'YDir','reverse')
xlim([0 max(EF)+10])

yticks(1:n)
yticklabels(names)

xlabel('Days')
title('Project Gantt Chart')

% --- Milestone Markers ---

fields = fieldnames(milestones);

for i = 1:length(fields)

    t = milestones.(fields{i});

    plot(t,0,'kd','MarkerSize',8,'MarkerFaceColor','k')

    text(t, -0.8, fields{i}, ...
        'Rotation',45, ...
        'FontSize',8)

end

hold off