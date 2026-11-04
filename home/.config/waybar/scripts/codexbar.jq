def color:
    if . >= 90 then "#f38ba8" elif . >= 70 then "#fab387" else "#a6e3a1" end;

def countdown:
    (try (.resetsAt | fromdateiso8601) catch null) as $reset
    | if $reset == null then "—"
      else ([$reset - now, 0] | max | floor) as $seconds
        | if $seconds < 3600 then "\(($seconds / 60) | ceil)m"
          elif $seconds < 86400 then "\(($seconds / 3600) | ceil)h"
          else "\(($seconds / 86400) | ceil)d" end
      end;

def window_text:
    (.usedPercent | floor) as $pct
    | ([$pct, 0] | max | [., 100] | min | . / 10 | floor) as $filled
    | "<span foreground=\"\($pct | color)\">\(countdown)</span> "
      + "<span foreground=\"\($pct | color)\">\("█" * $filled)</span>"
      + "<span foreground=\"#585b70\">\("█" * (10 - $filled))</span> "
      + "<span foreground=\"\($pct | color)\">\($pct)%</span>";

.[0].usage
| [.primary + {label: "5h"}, .secondary + {label: "weekly"}]
| map(select(.usedPercent | type == "number"))
| if length == 0 then error("No Codex usage windows") else . end
| (map(.usedPercent | floor) | max) as $pct
| {
    text: ("  " + (map(window_text) | join("  "))),
    tooltip: (map("Codex \(.label): \(.usedPercent | floor)%"
        + (if .resetDescription then " — resets \(.resetDescription)" else "" end))
        | join("\n")),
    class: (if $pct >= 90 then "critical" elif $pct >= 70 then "warning" else "ok" end),
    percentage: $pct
}
