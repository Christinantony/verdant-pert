function [s, t] = convertToEdges(preds)

s = [];
t = [];

for i = 1:length(preds)
    for p = preds{i}
        s(end+1) = p;
        t(end+1) = i;
    end
end

end
