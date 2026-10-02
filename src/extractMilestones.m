function milestones = extractMilestones(names,EF)

milestones = struct();

for i = 1:length(names)

    task = names{i};

    if contains(task,'Geometry Lock')
        milestones.DesignFreeze = EF(i);
    end

    if contains(task,'RF Test')
        milestones.PrototypeValidation = EF(i);
    end

    if contains(task,'QA Approval')
        milestones.ProductionRelease = EF(i);
    end

    if strcmp(task,'Tooling Fabrication')
        milestones.ToolingReady = EF(i);
    end

    if strcmp(task,'Final Assembly Completion')
        milestones.ArrayIntegration = EF(i);
    end

    if strcmp(task,'Final System Test')
        milestones.FinalTest = EF(i);
        milestones.Delivery = EF(i);
    end

end

end
