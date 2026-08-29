#!/usr/bin/env bash
set -euo pipefail

CSV_FILE="tosses.csv"
README_FILE="README.md"
BINDIR="./bin"

if [[ ! -f "$CSV_FILE" ]]; then
    printf 'timestamp,outcome\n' > "$CSV_FILE"
fi

timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
outcome="$($BINDIR/coin)"

if [[ "$outcome" != "0" && "$outcome" != "1" ]]; then
    echo "Invalid RNG output: $outcome" >&2
    exit 1
fi

printf '%s,%s\n' "$timestamp" "$outcome" >> "$CSV_FILE"

read -r tosses ones probability < <(
    gawk -F',' '
        NR > 1 {
            tosses++;
            ones += $2;
        }

        END {
            if (tosses == 0) {
                printf "0 0 0.00000000\n";
            } else {
                printf "%d %d %.8f\n",
                       tosses,
                       ones,
                       ones / tosses;
            }
        }
    ' "$CSV_FILE"
)

percentage="$(
    gawk -v p="$probability" 'BEGIN {
        printf "%.6f%%", p * 100
    }'
)"

if [[ ! -f "$README_FILE" ]]; then
    echo "[!] $README_FILE not found"
    exit 1
fi

gawk \
    -v tosses="$tosses" \
    -v ones="$ones" \
    -v probability="$probability" \
    -v percentage="$percentage" '
BEGIN {
    # Read the entire README as one record.
    RS = "\0"
    ORS = ""

    start_marker = "<!-- COIN_STATS_START -->"
    end_marker   = "<!-- COIN_STATS_END -->"

    statistics = \
        start_marker "\n" \
        "## Current Results\n\n" \
        "- Total tosses: " tosses "\n" \
        "- Number of ones: " ones "\n" \
        "- Current probability estimate: " probability "\n" \
        "- Current percentage of ones: " percentage "\n\n" \
        "The current estimate is calculated as:\n\n" \
        "```text\n" \
        "number of ones / total tosses\n" \
        "```\n" \
        end_marker
}
{
    text = $0

    start_position = index(text, start_marker)
    end_position   = index(text, end_marker)

    if (start_position > 0 && end_position > start_position) {
        # Preserve everything before and after the marked section.
        prefix = substr(text, 1, start_position - 1)
        suffix = substr(text, end_position + length(end_marker))

        print prefix statistics suffix
    }
    else {
        # If the markers do not exist, append the generated section.
        print text
        print "\n\n" statistics "\n"
    }
}
' "$README_FILE" > "$README_FILE.tmp" &&
mv "$README_FILE.tmp" "$README_FILE"

echo "Timestamp:          $timestamp"
echo "Outcome:            $outcome"
echo "Total tosses:       $tosses"
echo "Number of ones:     $ones"
echo "Probability estimate: $probability"
