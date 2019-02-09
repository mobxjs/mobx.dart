#!/bin/bash

set -x

if [[ "${FLUTTER}" = true ]]
then
  $FLUTTER_CMD test --coverage --coverage-path coverage/lcov.info
else
  pub run test_coverage
fi
