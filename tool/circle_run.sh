#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cd mobx
pub get
dartanalyzer --fatal-infos --fatal-warnings .
dart --enable_asserts --enable-vm-service test/all.dart