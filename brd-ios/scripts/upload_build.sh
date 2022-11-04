#!/bin/bash
scheme="wallet"
archive_path="$PWD/build/"$scheme".xcarchive"
export_path="$PWD/build"

# Upload if on a release branch
if [[ $1 == releases* ]]; then
  echo "Release build detected . Will upload to TestFlight.  Branch is " $1
  xcrun altool --upload-app --type ios --file "$export_path/"$scheme".ipa" --username "$APPLE_BUILD_USER" --password "$APPLE_BUILD_PASSWORD"
else
  echo "Not a releases build.  Will NOT upload. Branch is " $1
fi
