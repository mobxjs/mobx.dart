#!/bin/bash

set -x

if [[ "${FLUTTER}" = true ]]
then
  $FLUTTER_CMD analyze
else
  dartanalyzer --fatal-infos --fatal-warnings .
fi
