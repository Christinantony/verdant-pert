"""Draw the Gantt chart and dependency network for a VerdantPERT schedule.

Input: the CSV files written by tools/run_octave.sh (schedule.csv, edges.csv,
milestones.csv), i.e. the numbers computed by the recovered MATLAB code.
Output: assets/gantt.png and assets/network.png. The colours follow
src/main.m: red for critical tasks, orange for near-critical, blue otherwise.

    python tools/plot_schedule.py <out_dir_with_csvs> assets
"""
import csv
import sys
from collections import defaultdict
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch

src = Path(sys.argv[1])
out = Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)

rows = list(csv.DictReader(open(src / "schedule.csv")))
edges = [(int(r["from"]), int(r["to"])) for r in csv.DictReader(open(src / "edges.csv"))]
milestones = [(r["milestone"], float(r["day"])) for r in csv.DictReader(open(src / "milestones.csv"))]
for r in rows:
    for k in ("id", "critical", "nearCritical"):
        r[k] = int(r[k])
    for k in ("duration", "ES", "EF", "LS", "LF", "slack"):
        r[k] = float(r[k])

RED, ORANGE, BLUE = "#e4572e", "#f3a712", "#8fbfe0"
colour = lambda r: RED if r["critical"] else ORANGE if r["nearCritical"] else BLUE
total = max(r["EF"] for r in rows)

# ---------------- Gantt (same layout as the patch loop in src/main.m) ----------------
fig, ax = plt.subplots(figsize=(13, 9.5), dpi=110)
for r in rows:
    ax.barh(r["id"], r["EF"] - r["ES"], left=r["ES"], height=0.8, color=colour(r), edgecolor="#333", linewidth=0.5)
    if r["slack"] > 0:
        ax.barh(r["id"], r["slack"], left=r["EF"], height=0.3, color="none", edgecolor="#777", linewidth=0.8, linestyle="--")
ax.set_yticks([r["id"] for r in rows])
ax.set_yticklabels([r["name"] for r in rows], fontsize=8.5)
ax.set_ylim(len(rows) + 0.8, -2.2)
ax.set_xlim(0, total + 10)
ax.set_xlabel("Days")
ax.set_title(f"Project Gantt Chart  (total duration {total:.0f} days)", pad=48)
ax.grid(axis="x", color="#ddd", linewidth=0.6)
ax.set_axisbelow(True)
seen = {}
for name, day in milestones:
    seen.setdefault(day, []).append(name)
for day, names in seen.items():
    ax.axvline(day, color="#444", linewidth=0.7, linestyle=":")
    ax.plot(day, -0.2, "kd", markersize=7, clip_on=False)
    ax.text(day + 0.4, -0.8, " / ".join(names), rotation=30, fontsize=7.5, ha="left", va="bottom", clip_on=False)
from matplotlib.patches import Patch
ax.legend(handles=[Patch(color=RED, label="Critical path (slack 0)"),
                   Patch(color=ORANGE, label="Near-critical (slack ≤ 2 days)"),
                   Patch(color=BLUE, label="Other tasks"),
                   Patch(facecolor="none", edgecolor="#777", linestyle="--", label="Slack / float")],
          loc="upper right", bbox_to_anchor=(0.995, 0.80), fontsize=8.5, framealpha=0.95)
fig.text(0.01, 0.005, "Computed by the recovered src/*.m files run under GNU Octave (main.m scenario: 40 spiral + 8 horn antennas, enclosure required).", fontsize=7.5, color="#555")
fig.tight_layout(rect=(0, 0.02, 1, 1))
fig.savefig(out / "gantt.png")

# ---------------- Network (layered left-to-right, like plot(G,'Layout','layered')) ----------------
succ, pred = defaultdict(list), defaultdict(list)
for s, t in edges:
    succ[s].append(t)
    pred[t].append(s)
by_id = {r["id"]: r for r in rows}
layer = {}
for r in rows:  # ids are already in topological order (addTask appends after predecessors)
    layer[r["id"]] = 0 if not pred[r["id"]] else 1 + max(layer[p] for p in pred[r["id"]])
cols = defaultdict(list)
for i, l in layer.items():
    cols[l].append(i)
pos = {}
for l, ids in cols.items():
    n = len(ids)
    for k, i in enumerate(sorted(ids)):
        pos[i] = (l, (k - (n - 1) / 2) * 1.6)

fig, ax = plt.subplots(figsize=(17, 8), dpi=110)
for s, t in edges:
    crit = by_id[s]["critical"] and by_id[t]["critical"]
    ax.add_patch(FancyArrowPatch(pos[s], pos[t], arrowstyle="-|>", mutation_scale=10,
                                 color=RED if crit else "#999", linewidth=1.6 if crit else 0.8,
                                 shrinkA=9, shrinkB=9, zorder=1))
for r in rows:
    x, y = pos[r["id"]]
    ax.scatter(x, y, s=260, color=colour(r), edgecolor="#333", zorder=3)
    ax.text(x, y - 0.42, r["name"].replace(" - ", "\n"), ha="center", va="top", fontsize=6.6, zorder=4)
    ax.text(x, y, str(r["id"]), ha="center", va="center", fontsize=6.5, zorder=5)
ax.set_xlim(-0.6, max(layer.values()) + 0.6)
ys = [p[1] for p in pos.values()]
ax.set_ylim(min(ys) - 1.4, max(ys) + 0.9)
ax.axis("off")
ax.set_title("Verdant PERT Network  (node number = task index; red = critical path)")
ax.legend(handles=[Patch(color=RED, label="Critical"), Patch(color=ORANGE, label="Near-critical"), Patch(color=BLUE, label="Other")],
          loc="upper left", fontsize=8.5)
fig.tight_layout()
fig.savefig(out / "network.png")
print("wrote", out / "gantt.png", out / "network.png")
