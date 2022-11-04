#!/bin/bash
scheme="wallet"
export_path="$PWD/build"
archive_path="$PWD/build/"$scheme".xcarchive"

# Export the build
xcodebuild -exportArchive -archivePath "$archive_path" -exportOptionsPlist $PWD/build/exportOptions.plist -exportPath $export_path
