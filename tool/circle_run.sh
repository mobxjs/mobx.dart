
#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

cd $PACKAGE
pub get
dartanalyzer --fatal-infos --fatal-warnings .
pub run test_coverage