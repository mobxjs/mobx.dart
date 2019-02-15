#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

cd $PACKAGE

if [[ "${FLUTTER}" = true ]]
then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
  FLUTTER_CMD=./flutter/bin/flutter
  FLUTTER_CMD doctor
  FLUTTER_CMD packages get
  FLUTTER_CMD analyze
  FLUTTER_CMD test --coverage --coverage-path coverage/lcov.info
else
  pub get
  dartanalyzer --fatal-infos --fatal-warnings .
  pub run test_coverage
fi

# Upload coverage results to codecov.io
bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
