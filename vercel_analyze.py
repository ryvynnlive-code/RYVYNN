#!/usr/bin/env python3
import json, sys, os, csv, glob, re
from datetime import datetime

def read_json(p):
    try:
        with open(p, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return None

def write_csv(fp, rows, headers):
    os.makedirs(os.path.dirname(fp), exist_ok=True)
    with open(fp, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(headers)
        for r in rows: w.writerow([r.get(h,"") for h in headers])

def newest_deployment(info):
    arr = info if isinstance(info, list) else (info.get("deployments", []) if isinstance(info, dict) else [])
    latest = None
    for d in arr:
        created = d.get("created") or d.get("createdAt") or 0
        try: created = int(created)
        except: created = 0
        if latest is None or created > latest[0]:
            latest = (created, d)
    return latest[1] if latest else None

def ts(ms):
    try:
        return datetime.utcfromtimestamp(int(ms)/1000).strftime("%Y-%m-%d %H:%M:%S")
    except: return ""

root = sys.argv[1] if len(sys.argv)>1 else "."
proj_json = os.path.join(root, "projects", "projects.json")
projects = read_json(proj_json) or []
if isinstance(projects, dict):
    projects = projects.get("projects", [])

perdir = os.path.join(root, "per-project")
entries, by_domain, by_proj = [], {}, {}

for p in projects:
    name = p.get("name","")
    safe = re.sub(r"[ /]", "__", name)
    pdir = os.path.join(perdir, safe)
    aliases = read_json(os.path.join(pdir, f"aliases-{safe}.json")) or {}
    envs = read_json(os.path.join(pdir, f"env-{safe}.json")) or {}
    deps = read_json(os.path.join(pdir, f"deployments-{safe}.json")) or {}

    env_list = envs.get("envs", []) if isinstance(envs, dict) else envs if isinstance(envs, list) else []
    env_keys = sorted({e.get("key","") for e in env_list if e.get("key")})

    alias_list = []
    if isinstance(aliases, dict) and "aliases" in aliases:
        alias_list = [a.get("alias","") for a in aliases.get("aliases", []) if a.get("alias")]
    elif isinstance(aliases, list):
        alias_list = [a.get("alias","") if isinstance(a, dict) else "" for a in aliases]
    alias_list = [a for a in alias_list if a]

    latest = newest_deployment(deps) or {}
    state = latest.get("state","")
    url = latest.get("url","")
    created = latest.get("created") or latest.get("createdAt")
    ref = (latest.get("meta") or {}).get("githubCommitRef","")
    sha = (latest.get("meta") or {}).get("githubCommitSha","")

    rec = {
        "project": name,
        "framework": p.get("framework",""),
        "prod_url_candidate": url,
        "latest_state": state,
        "latest_created": ts(created) if created else "",
        "latest_commit_ref": ref,
        "latest_commit_sha": sha,
        "alias_count": len(alias_list),
        "env_count": len(env_keys),
        "aliases": ",".join(sorted(alias_list)),
        "env_keys": ",".join(env_keys)
    }
    entries.append(rec)
    by_proj[name]=rec
    for a in alias_list:
        by_domain.setdefault(a, []).append(name)

collisions = [{"domain":d, "projects": ",".join(sorted(ps))} for d,ps in by_domain.items() if len(ps)>1]

def looks_prod(alias):
    return not any(x in alias for x in [".vercel.app", "-git-", "-preview-","--"]) and "." in alias

prod_weight = {}
for e in entries:
    w = 0
    als = [a.strip() for a in e["aliases"].split(",") if a.strip()]
    w += sum(2 for a in als if looks_prod(a))
    w += 1 if e["latest_state"] in ("READY","SUCCEEDED") else 0
    w += min(3, len(als))
    w += min(3, e["env_count"])
    prod_weight[e["project"]] = w

sorted_projects = sorted(entries, key=lambda r: (-prod_weight.get(r["project"],0), r["project"]))
norm = lambda s: re.sub(r"[-_ ]+","", s.lower())
groups = {}
for e in sorted_projects:
    key = norm(e["project"])
    groups.setdefault(key, []).append(e)

canonicals, dups = [], []
for key, arr in groups.items():
    canonicals.append(arr[0])
    for x in arr[1:]:
        dups.append({"duplicate": x["project"], "canonical": arr[0]["project"]})

env_gaps = []
for key, arr in groups.items():
    if not arr: continue
    can = arr[0]
    can_keys = set(can["env_keys"].split(",")) if can["env_keys"] else set()
    for x in arr[1:]:
        x_keys = set(x["env_keys"].split(",")) if x["env_keys"] else set()
        missing = sorted(list(can_keys - x_keys))
        if missing:
            env_gaps.append({"duplicate": x["project"], "canonical": can["project"], "missing_env_keys": ",".join(missing)})

write_csv(os.path.join(root, "project-matrix.csv"), entries,
          ["project","framework","alias_count","env_count","latest_state","latest_created","latest_commit_ref","latest_commit_sha","aliases","env_keys"])
write_csv(os.path.join(root, "canonicals.csv"), canonicals,
          ["project","framework","alias_count","env_count","latest_state","latest_created","aliases"])
write_csv(os.path.join(root, "duplicates.csv"), dups, ["duplicate","canonical"])
write_csv(os.path.join(root, "domain-collisions.csv"), collisions, ["domain","projects"])
write_csv(os.path.join(root, "env-gaps.csv"), env_gaps, ["duplicate","canonical","missing_env_keys"])

latest_rows = [{"project":e["project"], "state":e["latest_state"], "created":e["latest_created"], "url":e["prod_url_candidate"]} for e in entries]
write_csv(os.path.join(root, "deployments-latest.csv"), latest_rows, ["project","state","created","url"])

md = []
md.append(f"# RYVYNN — Phase-0 Dry-Run Report\n")
md.append(f"_Generated: {datetime.utcnow().isoformat()}Z_\n")
md.append("## Key Findings\n")
md.append(f"- Projects discovered: **{len(entries)}**")
md.append(f"- Canonical candidates: **{len(canonicals)}** (see `canonicals.csv`)")
md.append(f"- Duplicate candidates: **{len(dups)}** (see `duplicates.csv`)")
md.append(f"- Domain collisions: **{len(collisions)}** (see `domain-collisions.csv`)\n")
md.append("## Decision Heuristics Used\n")
md.append("- Production domain presence\n- Recent successful deployment\n- Alias and env richness\n- Name normalization\n")
md.append("## Action Items\n")
md.append("1. Resolve any domain mapped to multiple projects (cutover plan needed).\n2. For duplicates, copy missing env keys (from `env-gaps.csv`) into the canonical project.\n3. Confirm canonical repo/branch linkage.\n4. Schedule decommission windows once staging checks pass.\n")
open(os.path.join(root, "phase0-report.md"), "w", encoding="utf-8").write("\n".join(md))
print(f"✅ Analysis complete. See Markdown/CSV outputs in: {root}")


