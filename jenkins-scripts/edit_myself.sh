#!/bin/bash
TAG=${1}
MSG=${2}


JSON="{\"message\": \"$MSG\", \"channel\":\"button\"}"

curl -XPOST -H"Content-Type: application/json" \
  -w "\n" \
  -d "${JSON}" \
  https://hambot.rexroof.com/status-post/${TAG}
