#!/bin/bash
# Do you find `xcodebuild` too verbose but don't want `xcpretty`
# to swallow ALL the output, including sometimes useful output,
# all so that you can have more sane logs for your iOS builds?
# You also think using `-quiet` hides way too much info as well?
#
# This little snippet hides a lot of the verbosity of xcodebuild
# without accidentally hiding unexpected log lines.
#
# Usage: xcodebuild ... | xcquiet.sh
#
# Sample iOS full log size: ~7.5MB
# Sample iOS xcquiet trimmed log size: ~650KB

grep -v \
  -e '^\s*export\|cd\|builtin-\|write-file' \
  -e '/s\?bin/'
