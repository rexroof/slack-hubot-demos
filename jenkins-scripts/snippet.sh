#!/bin/bash

FILE=${1:-/etc/shells}
FILENAME=$(basename $FILE)

JSON=$(jq -Rs "{ filename: \"$FILENAME\", content: . }" $FILE)

curl -XPOST -H"Content-Type: application/json" \
  -w "\n" \
  -d "${JSON}" \
  https://hambot.rexroof.com/snippet/button
