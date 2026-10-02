classdef VerdantPERTApp < handle

properties

    UIFigure
    ScrollPanel
    MainGrid

    ProjectPanel
    AntennaPanel
    ArrayPanel
    StructurePanel
    ManufacturingPanel
    WorkflowPanel
    TestingPanel
    ButtonPanel

    AntennaDB

    % Project
    ProjectNameField
    ClientField
    ManagerField
    StartDatePicker

    % Antennas
    AntennaTable

    % Array
    ArrayRequiredCheckBox
    ArrayCountField
    MixedTypesCheckBox

    % Structure
    EnclosureCheckBox
    CompositeCheckBox
    MountingCheckBox

    % Manufacturing
    OutsourceCheckBox
    VendorCapacityField
    PCBVendorField

    % Workflow
    PrototypeIterationsField
    SkipPrototypeCheckBox
    DesignIterationsField

    % Testing
    RFCheckBox
    ArrayTestCheckBox
    EnvTestCheckBox

    GenerateButton

end


methods

function app = VerdantPERTApp()

app.AntennaDB = getAntennaDB();

buildUI(app)

end


function buildUI(app)

app.UIFigure = uifigure( ...
'Name','VerdantPERT Project Builder', ...
'Position',[100 100 1100 650]);

%% SCROLL PANEL

app.ScrollPanel = uipanel(app.UIFigure);
app.ScrollPanel.Scrollable = 'on';

app.ScrollPanel.Position = [0 0 1100 1000];

%% MAIN GRID

app.MainGrid = uigridlayout(app.ScrollPanel,[5 2]);

app.MainGrid.RowHeight = {170,210,190,140,'fit'};
app.MainGrid.ColumnWidth = {'1x','1x'};

app.MainGrid.RowSpacing = 10;
app.MainGrid.ColumnSpacing = 10;
app.MainGrid.Padding = [10 10 10 10];


%% PROJECT PANEL

app.ProjectPanel = uipanel(app.MainGrid);
app.ProjectPanel.Title = 'Project Information';

grid = uigridlayout(app.ProjectPanel,[4 2]);

uilabel(grid,'Text','Project Name');
app.ProjectNameField = uieditfield(grid,'text');

uilabel(grid,'Text','Client');
app.ClientField = uieditfield(grid,'text');

uilabel(grid,'Text','Project Manager');
app.ManagerField = uieditfield(grid,'text');

uilabel(grid,'Text','Start Date');
app.StartDatePicker = uidatepicker(grid);


%% ANTENNA PANEL

app.AntennaPanel = uipanel(app.MainGrid);
app.AntennaPanel.Title = 'Antenna Configuration';

grid = uigridlayout(app.AntennaPanel,[2 2]);
grid.RowHeight = {'1x','fit'};
grid.ColumnWidth = {'3x','1x'};

types = fieldnames(app.AntennaDB);
types = reshape(types,1,[]);

app.AntennaTable = uitable(grid);

app.AntennaTable.ColumnName = {'Antenna Type','Quantity','Prototype'};
app.AntennaTable.ColumnEditable = [true true true];
app.AntennaTable.ColumnFormat = {types,'numeric','logical'};
app.AntennaTable.Data = {types{1},1,true};

buttonGrid = uigridlayout(grid,[2 1]);
buttonGrid.Layout.Column = 2;

uibutton(buttonGrid,'Text','Add Antenna', ...
'ButtonPushedFcn',@(src,event)addAntennaRow(app));

uibutton(buttonGrid,'Text','Remove Antenna', ...
'ButtonPushedFcn',@(src,event)removeAntennaRow(app));


%% ARRAY PANEL

app.ArrayPanel = uipanel(app.MainGrid);
app.ArrayPanel.Title = 'Array Configuration';

grid = uigridlayout(app.ArrayPanel,[3 2]);

app.ArrayRequiredCheckBox = uicheckbox(grid,'Text','Array Required');
app.ArrayRequiredCheckBox.Layout.Column = [1 2];
app.ArrayRequiredCheckBox.ValueChangedFcn = @(s,e)arrayToggle(app);

uilabel(grid,'Text','Number of Arrays');
app.ArrayCountField = uieditfield(grid,'numeric');
app.ArrayCountField.Value = 1;

app.MixedTypesCheckBox = uicheckbox(grid,'Text','Mixed Antenna Types');
app.MixedTypesCheckBox.Layout.Column = [1 2];


%% STRUCTURE PANEL

app.StructurePanel = uipanel(app.MainGrid);
app.StructurePanel.Title = 'Mechanical Structure';

grid = uigridlayout(app.StructurePanel,[3 1]);

app.EnclosureCheckBox = uicheckbox(grid,'Text','Enclosure Required');
app.CompositeCheckBox = uicheckbox(grid,'Text','Composite Structure');
app.MountingCheckBox = uicheckbox(grid,'Text','Mounting Structure');


%% MANUFACTURING PANEL

app.ManufacturingPanel = uipanel(app.MainGrid);
app.ManufacturingPanel.Title = 'Manufacturing Configuration';

grid = uigridlayout(app.ManufacturingPanel,[3 2]);

app.OutsourceCheckBox = uicheckbox(grid,'Text','Outsourcing Allowed');
app.OutsourceCheckBox.Layout.Column = [1 2];

uilabel(grid,'Text','Vendor Capacity');
app.VendorCapacityField = uieditfield(grid,'numeric');

uilabel(grid,'Text','PCB Vendor');
app.PCBVendorField = uieditfield(grid,'text');


%% WORKFLOW PANEL

app.WorkflowPanel = uipanel(app.MainGrid);
app.WorkflowPanel.Title = 'Workflow Options';

grid = uigridlayout(app.WorkflowPanel,[3 2]);

uilabel(grid,'Text','Prototype Iterations');
app.PrototypeIterationsField = uieditfield(grid,'numeric');

app.SkipPrototypeCheckBox = uicheckbox(grid,'Text','Skip Prototype');
app.SkipPrototypeCheckBox.Layout.Column = [1 2];
app.SkipPrototypeCheckBox.ValueChangedFcn = @(s,e)skipPrototypeToggle(app);

uilabel(grid,'Text','Design Iterations');
app.DesignIterationsField = uieditfield(grid,'numeric');


%% TESTING PANEL

app.TestingPanel = uipanel(app.MainGrid);
app.TestingPanel.Title = 'Testing Configuration';
app.TestingPanel.Layout.Column = [1 2];

grid = uigridlayout(app.TestingPanel,[1 3]);

app.RFCheckBox = uicheckbox(grid,'Text','RF Validation');
app.ArrayTestCheckBox = uicheckbox(grid,'Text','Array Testing');
app.EnvTestCheckBox = uicheckbox(grid,'Text','Environmental Testing');


%% BUTTON PANEL

app.ButtonPanel = uipanel(app.MainGrid);
app.ButtonPanel.Layout.Column = [1 2];

grid = uigridlayout(app.ButtonPanel,[1 3]);
grid.ColumnWidth = {'1x','fit','1x'};

app.GenerateButton = uibutton(grid,'Text','Generate PERT Schedule');
app.GenerateButton.Layout.Column = 2;
app.GenerateButton.ButtonPushedFcn = @(s,e)runPERT(app);

end


%% CALLBACKS

function addAntennaRow(app)

data = app.AntennaTable.Data;
types = fieldnames(app.AntennaDB);

data(end+1,:) = {types{1},1,true};
app.AntennaTable.Data = data;

end


function removeAntennaRow(app)

data = app.AntennaTable.Data;

if size(data,1) > 1
data(end,:) = [];
end

app.AntennaTable.Data = data;

end


function arrayToggle(app)

if app.ArrayRequiredCheckBox.Value
app.ArrayCountField.Enable = 'on';
app.MixedTypesCheckBox.Enable = 'on';
else
app.ArrayCountField.Enable = 'off';
app.MixedTypesCheckBox.Enable = 'off';
end

end


function skipPrototypeToggle(app)

if app.SkipPrototypeCheckBox.Value
app.PrototypeIterationsField.Enable = 'off';
else
app.PrototypeIterationsField.Enable = 'on';
end

end


function runPERT(app)

project = buildProjectStruct(app);

[names,preds,durs] = buildProjectWorkflow(project);

[totalDuration,ES,EF] = pertEngine(names,preds,durs);

criticalNodes = extractCriticalPath(names,preds,durs);

displayPERT(names,preds,durs,ES,EF,criticalNodes)

uialert(app.UIFigure, ...
sprintf("Estimated Project Duration: %.1f days",totalDuration), ...
"PERT Result");

end

end
end