#!/bin/bash
MSG=${1:-Hello There}
curl -XPOST -H"Content-Type: application/json" \
  -w "\n" \
  -d "{\"message\": \"$MSG\"}" \
  https://hambot.rexroof.com/say/button
