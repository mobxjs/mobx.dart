#!/bin/bash

set -e
set -x

export TOOL_DIR="$PWD/tool"
export FLUTTER_CMD="$PWD/flutter/bin/flutter"

cd $PACKAGE
$TOOL_DIR/get.sh
$TOOL_DIR/analyze.sh
$TOOL_DIR/test.sh

bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
