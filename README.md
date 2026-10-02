![VerdantPERT](assets/overview.svg)

# VerdantPERT

**A MATLAB engineering-planning prototype that generates task dependencies from antenna and manufacturing configuration, then calculates schedule timing.**

Engineering projects repeat similar phases, but the dependencies change with the product, process, and quantity. VerdantPERT represents those rules as databases and modular workflow builders so a schedule can be generated from configuration.

## Implemented capabilities

- Six antenna workflow definitions: spiral, horn, biconical, conformal, blade, and planar.
- Separate prototype, production, enclosure, composite, and final-integration builders.
- Component duration models driven by quantity or vendor lead time.
- Directed task graph, topological traversal, earliest start/finish, backward-pass latest start/finish, and slack.
- Longest-path extraction, near-critical tasks with positive slack up to a default two-day threshold, and name-based milestones.
- MATLAB configuration UI, network plot, and Gantt-style visualization.

**Status:** recovered prototype with 23 MATLAB files. Algorithms and UI were inspected, but MATLAB runtime execution has not been verified in this portfolio build. Some UI controls are present without affecting scheduling; see [limitations](docs/limitations.md).

## Workflow and architecture

```mermaid
flowchart TD
    A[MATLAB configuration UI or project struct] --> B[buildProjectStruct]
    B --> C[buildProjectWorkflow]
    D[Antenna, component and duration databases] --> C
    C --> E[Prototype and production streams]
    C --> F[Enclosure and composite streams]
    E --> G[Integration task dependencies]
    F --> G
    G --> H[pertEngine: forward schedule pass]
    H --> I[Slack, critical path and milestones]
    I --> J[Network and Gantt views]
```

The console entry point computes the full reporting pipeline. The GUI entry point currently computes duration, one critical path, and plots; it does not call every console analysis module.

| Layer | Source |
| :--- | :--- |
| Application and UI | [VerdantPERTApp.m](src/VerdantPERTApp.m), [buildProjectStruct.m](src/buildProjectStruct.m) |
| Engineering rules | [getAntennaDB.m](src/getAntennaDB.m), [getComponentDB.m](src/getComponentDB.m), [getScheduleDB.m](src/getScheduleDB.m) |
| Orchestration | [buildProjectWorkflow.m](src/buildProjectWorkflow.m) and `build*Stream.m` modules |
| Timing and float | [pertEngine.m](src/pertEngine.m), [computeSlackPERT.m](src/computeSlackPERT.m) |
| Analysis and presentation | `extract*.m`, [displayPERT.m](src/displayPERT.m), [main.m](src/main.m) |

## Run in MATLAB

Download the repository and open its root folder in MATLAB. The code uses modern MATLAB UI functions and `digraph`; the minimum supported release has not been established.

```matlab
addpath(fullfile(pwd, 'src'));
app = VerdantPERTApp;  % configuration UI
```

For the supplied console scenario, run the following in a separate session if needed; `main` clears workspace variables:

```matlab
addpath(fullfile(pwd, 'src'));
main                  % 40 spiral and 8 horn antennas, enclosure required
```

The older `archive/setupVerdantPERT.m` generates different versions of key files and should not be used to initialize this repository.

## Scheduling equations

For each task `i`, `ES(i) = max(EF(predecessors))`, or zero for a root task; `EF(i) = ES(i) + duration(i)`. The backward pass uses the minimum successor latest start; `slack(i) = LS(i) - ES(i)`.

Duration models in the supplied code:

| Model | Formula |
| :--- | :--- |
| Linear | `per_unit_time × quantity` |
| Fixed | `vendor_lead_time` |
| Hybrid | `min(per_unit_time × quantity, vendor_lead_time)` |

The hybrid formula selects the shorter duration; it does not add lead time or enforce vendor capacity. Production categories use the longest component duration within each process group, implying parallel availability.

Despite the project name, this is currently **deterministic critical-path scheduling**. It does not use optimistic/most-likely/pessimistic PERT estimates or uncertainty simulation.

See the [worked scheduling example](examples/README.md), [engineering assumptions and known limitations](docs/limitations.md), and [verification record](docs/validation.md).

## Provenance and rights

The MATLAB source is the owner's supplied project, attributed to **Christinantony**, preserved byte-for-byte. Only repository layout, documentation, and clearly marked synthetic examples were added. The old setup generator is archived separately. File hashes are in [source-manifest.json](docs/source-manifest.json). No open-source license has been selected; see [rights notice](NOTICE.md).
