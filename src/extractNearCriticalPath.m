function nearCriticalNodes = extractNearCriticalPath(slack,threshold)

% Detect tasks that are close to becoming critical

if nargin < 2
    threshold = 2; % days
end

nearCriticalNodes = find(slack <= threshold & slack > 0);

end