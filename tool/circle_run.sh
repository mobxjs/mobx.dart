#!/bin/bash

set -x

cd mobx
pub get
dartanalyzer --fatal-infos --fatal-warnings .
dart --enable_asserts --enable-vm-service test/all.dart