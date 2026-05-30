#!/usr/bin/env bash
# Backdate 35 commits from 2026-02-05 to 2026-04-14 (~2‑day intervals)
START="2026-02-05"
TOTAL=35
INTERVAL_DAYS=2
# Convert start date to epoch seconds
START_EPOCH=$(date -j -f "%Y-%m-%d" "$START" +%s)
for i in $(seq 0 $((TOTAL-1)))
do
  # Compute timestamp for this commit
  TS_EPOCH=$((START_EPOCH + i * INTERVAL_DAYS * 86400))
  TS=$(date -r $TS_EPOCH "+%Y-%m-%d %H:%M:%S %z")
  export GIT_AUTHOR_DATE="$TS"
  export GIT_COMMITTER_DATE="$TS"
  git commit --allow-empty -m "Backdated commit $((i+1))"
done
