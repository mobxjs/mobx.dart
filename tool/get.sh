#!/bin/bash

set -x

if [[ "${FLUTTER}" = true ]]
then
  $FLUTTER_CMD packages get
else
  pub get
fi
