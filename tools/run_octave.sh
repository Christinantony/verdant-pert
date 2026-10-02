#!/bin/sh
# Runs the recovered MATLAB sources under GNU Octave and exports the computed
# schedule for tools/plot_schedule.py. Octave has no digraph; the small
# stand-ins in tools/octave-compat/ provide the few graph calls the code
# makes (digraph, toposort, predecessors, successors, adjacency, contains).
# The plotting section of src/main.m needs MATLAB's graph plot, so the script
# runs main.m up to that section and leaves the figures to plot_schedule.py.
#
#   sh tools/run_octave.sh out_dir
#   python3 tools/plot_schedule.py out_dir assets
set -e
out="${1:-/tmp/verdant-out}"
mkdir -p "$out"
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
octave --no-gui --quiet --eval "
addpath('$root/tools/octave-compat'); addpath('$root/src');
diary('$out/main_console.txt'); diary on;
src = fileread('src/main.m');
cut = strfind(src, '% --- Build Graph ---');
eval(src(1:cut-1));
diary off;
fid = fopen('$out/schedule.csv','w');
fprintf(fid,'id,name,duration,ES,EF,LS,LF,slack,critical,nearCritical\n');
for i=1:length(names)
  fprintf(fid,'%d,\"%s\",%g,%g,%g,%g,%g,%g,%d,%d\n',i,names{i},durs(i),ES(i),EF(i),LS(i),LF(i),slack(i),ismember(i,criticalNodes),ismember(i,nearCriticalNodes));
end
fclose(fid);
[s,t] = convertToEdges(preds);
fid = fopen('$out/edges.csv','w'); fprintf(fid,'from,to\n'); fprintf(fid,'%d,%d\n',[s;t]); fclose(fid);
fid = fopen('$out/milestones.csv','w'); fprintf(fid,'milestone,day\n');
f = fieldnames(milestones); for i=1:numel(f), fprintf(fid,'%s,%g\n',f{i},milestones.(f{i})); end; fclose(fid);
"
echo "wrote $out/main_console.txt, schedule.csv, edges.csv, milestones.csv"
