#!/bin/bash
# Downlaods the latest currencies list to be embedded

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BREAD_TOKEN=$2
filename="currencies.json"
echo "Downloading $filename from $1/wallet/currencies"
echo $1
curl -H "Authorization: bread $BREAD_TOKEN" --silent --show-error --output "$SCRIPT_DIR/../breadwallet/Resources/$filename" "https://$1/wallet/currencies"
