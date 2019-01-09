#!/bin/bash

set -x

if [[ "${FLUTTER}" = true ]]
then
  $FLUTTER_CMD test test/all.dart
else
  pub run test test/all.dart
fi
