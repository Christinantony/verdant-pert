# Verification record

Completed: inspected all 23 supplied MATLAB files; traced GUI inputs through workflow creation; checked scheduling and duration equations against source; documented unwired controls and graph assumptions; confirmed copied `.m` hashes against extracted originals; verified local documentation links.

Completed later, for the README figures: the console pipeline (`main.m`, the workflow builders, `pertEngine`, `computeSlackPERT`, the `extract*` helpers) was executed unchanged under GNU Octave 8.4 with `tools/octave-compat/` standing in for MATLAB's `digraph` family. The supplied scenario gives 27 tasks, a 123-day total, a critical path through the spiral prototype stream and the enclosure, and four near-critical spiral production tasks with two days of float; the four-task worked example reproduces its hand-calculated table. `assets/gantt.png` and `assets/network.png` are drawn by `tools/plot_schedule.py` from the numbers that run exported; `assets/console-output.png` is the captured console text.

Not performed: MATLAB parsing/execution, rendering of the `uifigure` GUI or of MATLAB's own graph and Gantt figures, release compatibility checks or real-project calibration. There are no fabricated application screenshots or performance claims; the only pictures are the Octave-derived figures above.

Suggested MATLAB acceptance cases: the six-day worked example; a fork/join graph with known slack; an isolated task; a nonzero-duration root; invalid/negative quantities; cycle detection; multiple antenna types; enclosure off via direct project struct; and milestone extraction across more than one antenna. These cases target the documented limits rather than simply confirming the default scenario.
