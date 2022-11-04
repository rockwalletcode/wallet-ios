#!/bin/bash

show_usage() {
	echo
	echo "Usage: ${0##/*} [version]"
	echo "       ${0##/*} <version> ci"
	echo
	echo "To make a ci build specify version followed by 'ci'."
	echo "Build number is handled automatically."
	echo
	exit
}

# main

# show usage if '-h' or  '--help' is the first argument
case $1 in
	"-h"|"--help") show_usage ;;
esac

# exit when any command fails
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 
echo determine environment
echo

branchname="$(git branch --show-current)"
if [[ $branchname == "mit"* ]]; then
backendEnvt="dev"
scheme="wallet-dev"
elif [[ $branchname == "staging"* ]]; then
backendEnvt="stage"
scheme="wallet-stg"
elif [[ $branchname == "release-"* ]]; then
backendEnvt="prod"
scheme="wallet"
else
echo "Unable to interpret current branch "
echo "Branch is " $branchname
exit 9
fi

echo "Branch is " $branchname
echo "Environment is " $backendEnvt
echo "Scheme is " $scheme

echo
echo "Restore build updated files"
echo
git restore breadwallet/Resources/currencies.json
git restore breadwallet/Resources/brd-tokens.tar
git restore breadwallet/Resources/brd-tokens-staging.tar

echo
echo "Set versioning"
echo
agvtool new-marketing-version $1
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

agvtool next-version -all
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

echo
echo "Download currencies and bundles"
echo

if [ ! -f .env ]; then
	echo ".env file not found or configured properly."
	exit 1
fi

source .env

json=$(curl -k -v -X POST -H 'Content-type: application/json' -d '{"deviceID": "b21f2253-51e1-4346-92b0-e32323733067", "pubKey": "rCxDp6qD8uGqK2Z3UgeQ5bvTCZegqGfVexyz5XkbvwfW"}'  https://$API_URL/blocksatoshi/wallet/token)

token="$(echo $json | sed "s/{.*\"token\":\"\([^\"]*\).*}/\1/g"):sig"
url=$API_URL/blocksatoshi

source ${script_dir}/download_bundles.sh $url
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

source ${script_dir}/download_currencylist.sh $url $token
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

echo
echo "Make $scheme version ${mainBundleShortVersionString} build ${mainBundleVersion} ..."
echo

source ${script_dir}/archive.sh "${scheme}"
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

echo
echo "Branch is " $branchname
echo "Environment is " $backendEnvt
echo "Scheme is " $scheme
echo
echo Build Copmlete
echo

# source ${script_dir}/export_build.sh "${scheme}"
# rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

# source ${script_dir}/upload_build.sh "${scheme}"
# rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
