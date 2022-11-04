#!/bin/bash

# check for config file
if [ ! -f $PWD/build/exportOptions.plist ]; then
	mkdir -pv $PWD/build
	cp $PWD/../.circleci/config/exportOptions.plist $PWD/build/exportOptions.plist
fi

# use xcquiet if available for improved build output formatting
xcquiet="xcquiet.sh"
scheme=$1

if [[ -n "$scheme" ]]; then
  # clean and archive the specified scheme
  set -o pipefail
  xcodebuild -workspace breadwallet.xcworkspace -scheme "$scheme" clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
  rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
else
    echo "Usage: archive.sh <scheme>"
    echo "Available schemes:"
    #xcodebuild -workspace breadwallet.xcworkspace -list
    xcodebuild -project breadwallet.xcodeproj -list
fi
