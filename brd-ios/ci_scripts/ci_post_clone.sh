#!/bin/bash

#  ci_post_clone.sh
#  breadwallet
#
#  Created by Gardner von Holt on 9/6/22.

# Set the -e flag to stop running the script in case a command returns
# a nonzero exit code.
set -e

# Create the .env file
BRD_ENV=../.env
touch $BRD_ENV

# The environment variables go here
echo "API_URL=$API_URL" >> $BRD_ENV
echo "API_TOKEN=$API_TOKEN" >> $BRD_ENV
echo "CHECKOUT_API_TOKEN=$CHECKOUT_API_TOKEN" >> $BRD_ENV

echo "DEBUG_URL=$DEBUG_URL" >> $BRD_ENV
echo "DEBUG_TOKEN=$DEBUG_TOKEN" >> $BRD_ENV
echo "DEBUG_CHECKOUT_TOKEN=$DEBUG_CHECKOUT_TOKEN" >> $BRD_ENV
echo "IS_TEST=true" >> $BRD_ENV


echo "STAGING_URL=$STAGING_URL" >> $BRD_ENV
echo "STAGING_TOKEN=$STAGING_TOKEN" >> $BRD_ENV
echo "STAGING_CHECKOUT_TOKEN=$STAGING_CHECKOUT_TOKEN" >> $BRD_ENV

echo "" >> $BRD_ENV
