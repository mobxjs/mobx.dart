#!/bin/bash

# Fast fail the script on failures.
set -e

# Run Dart tests and output them at directory `./coverage`.
echo "Starting tests..."
dart run test --coverage=./coverage test/all_tests.dart

## Format collected coverage to LCOV (only for directory "lib").
echo "Generating LCOV report..."
dart run coverage:format_coverage \
  --lcov \
  --in=coverage/coverage.json \
  --out=coverage/lcov.info \
  --packages=.dart_tool/package_config.json \
  --report-on=lib
