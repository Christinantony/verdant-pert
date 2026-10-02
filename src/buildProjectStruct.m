function project = buildProjectStruct(app)

data = app.AntennaTable.Data;

project.antennas = {};

for i = 1:size(data,1)

ant.type = data{i,1};
ant.quantity = data{i,2};
ant.prototype_required = data{i,3};

project.antennas{i} = ant;

end

project.enclosure_required = true;

end
