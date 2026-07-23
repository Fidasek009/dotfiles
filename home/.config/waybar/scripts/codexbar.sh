#!/usr/bin/env bash
"${CODEXBAR_BIN:-${HOME}/.local/bin/codexbar}" usage --provider codex --source oauth --format json --no-color 2>/dev/null |
    jq -ce '
        def color: if . >= 90 then "#f38ba8" elif . >= 70 then "#fab387" else "#a6e3a1" end;
        def countdown:
            (try (.resetsAt | fromdateiso8601) catch null) as $reset
            | if $reset == null then "—" else (($reset - now) | if . < 0 then 0 else . end | floor) as $seconds
              | if $seconds < 3600 then "\(($seconds / 60) | ceil)m" elif $seconds < 86400 then "\(($seconds / 3600) | ceil)h" else "\(($seconds / 86400) | ceil)d" end end;
        .[0].usage.secondary | (.usedPercent | floor) as $pct | ("<span foreground=\"\($pct | color)\">\(countdown)</span> <span foreground=\"\($pct | color)\">\("█" * ($pct / 10 | floor))</span><span foreground=\"#585b70\">\("█" * (10 - ($pct / 10 | floor)))</span> <span foreground=\"\($pct | color)\">\($pct)%</span>") as $text
        | {text: "  \($text)", tooltip: "Codex weekly: \($pct)%" + (if .resetDescription then " — resets \(.resetDescription)" else "" end), class: (if $pct >= 90 then "critical" elif $pct >= 70 then "warning" else "ok" end), percentage: $pct}' ||
    printf '{"text":"  —","tooltip":"Codex weekly usage unavailable","class":"stale","percentage":0}\n'
