#!/bin/bash
set -eux
OUTPUT="$1"

dump_header() {
  local first_source_line_number=$1
  head -n $((first_source_line_number - 1)) ship.sh
}

last_header_line_number() {
  local first_source_line_number
  first_source_line_number=$(grep -n '^source' ship.sh | cut -f1 -d':' | head -n1)

  echo $((first_source_line_number - 1))
}

dump_scripts() {
  grep '^source' ship.sh | sed 's#^source \$(dirname \$0)/##g' | while IFS= read -r script; do
    echo ""
    cat "$script"
    echo ""
  done
}

first_footer_line_number() {
  local last_source_line_number
  last_source_line_number=$(grep -n '^source' ship.sh | cut -f1 -d':' | tail -n1)

  echo $((last_source_line_number + 1))
}

dump_footer() {
  local last_source_line_number=$1
  awk "{if(NR>=$((last_source_line_number + 1))) print \$0}" ship.sh
}

dump_header "$(last_header_line_number)" >"$OUTPUT"
dump_scripts >>"$OUTPUT"
dump_footer "$(first_footer_line_number)" >>"$OUTPUT"
