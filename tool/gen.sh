#!/bin/bash

set -x

BASE_DIR=$PWD

EXAMPLE_DIR=(
$BASE_DIR/mobx_examples
$BASE_DIR/flutter_mobx/example
$BASE_DIR/mobx_codegen/example
)

for dir in ${EXAMPLE_DIR[@]};
do
    cd $dir
    flutter packages pub run build_runner build --delete-conflicting-outputs
done
