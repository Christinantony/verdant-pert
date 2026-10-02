# Engineering assumptions and current limitations

## UI-to-engine wiring

`buildProjectStruct` transfers antenna type, quantity, and a prototype flag from the table, then sets `enclosure_required = true` unconditionally. `buildPrototypeStream` does not inspect the prototype flag. Project/client/manager/start date, array count, mixed types, enclosure checkbox, composite/mounting controls, outsourcing, vendor capacity, PCB vendor, iteration settings, and testing checkboxes are not wired into schedule generation. They demonstrate the intended interface, not implemented scheduling controls.

## Timing assumptions

Durations are modeled as days on an abstract timeline. There are no business-day calendars, holidays, resource leveling, capacity constraints, uncertainty estimates, or schedule baselines. Engineering database values are embedded assumptions and must be reviewed for a real project. RF and EM simulation are task names; this project does not invoke RF solvers or automate simulation itself.

## Graph and analysis limits

- Graphs constructed as `digraph(s,t)` omit isolated tasks not represented by an edge. This can produce wrong timing for an isolated node or mismatch labels and graph size.
- Critical-path extraction initializes root distance to zero; it assumes zero-duration roots. It returns one longest path, not all critical paths. The default workflow has a zero-duration Start Project node.
- `getCriticalPath.m` is an alternate tight-edge heuristic and is not used by the current entry points. Tight local dependencies do not guarantee membership in a global critical path.
- Milestones overwrite same-named fields when multiple antennas match. `Tooling Fabrication` is checked, while the current composite builder creates `Production Tooling`, so that milestone is missed.
- `displayPERT` draws both `barh` bars and scheduled patches; the GUI view may contain extra zero-origin bars. Critical colors are used in the console Gantt; the GUI Gantt currently uses blue patches.
- The composite dependency stream is modeled separately from per-antenna composite tasks; sequencing needs engineering review.
- Quantities, predecessor indices, durations and user input lack comprehensive validation; cycle handling is delegated to graph functions.

## Development history

`archive/setupVerdantPERT.m` is an older code generator with different database schemas and inline workflow code. It is retained as development material and excluded from normal source-path setup. Running it can generate incompatible alternatives. Similar-purpose extraction functions are retained with their differing behavior documented.
