#!/bin/bash

if [[ "${ALLOW_FAILURE}" = true ]]
then
  set +e
else
  set -e
fi
set -x

export TOOL_DIR="$PWD/tool"
export FLUTTER_CMD="$PWD/flutter/bin/flutter"

cd $PACKAGE
$TOOL_DIR/get.sh
$TOOL_DIR/analyze.sh
$TOOL_DIR/test.sh

bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
