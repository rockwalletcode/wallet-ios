#!/bin/bash
# Downlaods the latest app resource bundles to be embedded
API_URL=$1

function downloadBundle() {
    echo "Downloading $1.tar from ${API_URL}/wallet..."
    curl --silent --show-error --output "$SCRIPT_DIR/../breadwallet/Resources/$1.tar" "https://${API_URL}/wallet/assets/bundles/$1/download"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
plistBuddy="/usr/libexec/PlistBuddy"
plist="$SCRIPT_DIR/../breadwallet/Resources/AssetBundles.plist"
bundleNames=($("${plistBuddy}" -c "print" "${plist}" | sed -e 1d -e '$d'))

for bundleName in "${bundleNames[@]}"
do
  downloadBundle "${bundleName}-staging"
  downloadBundle ${bundleName}
done
