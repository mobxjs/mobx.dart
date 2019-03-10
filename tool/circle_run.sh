#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

cd $PACKAGE

if [[ "${FLUTTER}" = true ]]
then
  flutter packages get
  flutter analyze
  flutter test --coverage --coverage-path coverage/lcov.info
else
  pub get
  dartanalyzer --fatal-infos --fatal-warnings .
  pub run test # have to run this explicitly as test_coverage is NOT showing exceptions correctly
  pub run test_coverage
fi

# Upload coverage results to codecov.io
bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
