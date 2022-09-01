#!/bin/bash

# See http://stackoverflow.com/questions/14434549/how-to-expand-shell-variables-in-a-text-file
expand_template() {
  local template=${1}; shift
  local options=${*}

  tmp_file=$(mktemp)
  cat > ${tmp_file} << END_OF_TMP_FILE
${options}
cat <<END_OF_TEXT
$(cat ${template})
END_OF_TEXT
END_OF_TMP_FILE
  bash ${tmp_file}
  rm ${tmp_file}
}