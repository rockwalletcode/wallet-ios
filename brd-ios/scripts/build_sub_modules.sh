REPO=wallet-ios
BRANCH=mit
DEV_DIR=~/Dev/

echo $DEV_DIR/$REPO
echo
echo Building Repo $REPO : Branch $BRANCH
echo

echo
echo Switching to Home
echo
cd ~

echo
echo Backup .zshrc
echo
sudo cp .zshrc .bakzshrc

echo
echo Removing JDK
echo
brew uninstall temurin8

echo
echo Installing JDK
echo
brew install --cask temurin8

echo
echo Setting JAVA_HOME
echo
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home
# echo 'export JAVA_HOME=$JAVA_HOME' >>~/.zshrc

echo
echo removing ~/.gradle and $DEV_DIR/$REPO
echo
rm -rf ~/.gradle
rm -rf $DEV_DIR/$REPO

echo
echo Switching to $DEV_DIR
echo
cd $DEV_DIR

echo
echo cloning
echo
git clone git@github.com:atmcoin/$REPO.git

echo
echo switching to $REPO
echo
cd $DEV_DIR/$REPO

echo
echo checking out $BRANCH
echo
git checkout $BRANCH

echo
echo updating submodules
echo
git submodule update --init --recursive

echo
echo copy local.properties

echo
pwd
cd $DEV_DIR/$REPO
pwd

BRD_ENV=$DEV_DIR/$REPO/brd-ios/.env
echo
echo Checkinf for env settings $BRD_ENV
echo
if [ ! -f $BRD_ENV ]; then
  echo Env configuration does not exist.
  echo
  echo Creating $BRD_ENV
  touch $BRD_ENV

  echo "// PRODUCTION" >> $BRD_ENV
  echo "API_URL=$PROD_URL" >> $BRD_ENV
  echo "API_TOKEN=$PROD_TOKEN" >> $BRD_ENV
  echo "" >> $BRD_ENV

  echo "// DEVELOPMENT" >> $BRD_ENV
  echo "DEBUG_URL=$DEV_URL" >> $BRD_ENV
  echo "DEBUG_TOKEN=$DEV_TOKEN" >> $BRD_ENV
  echo "IS_TEST=true" >> $BRD_ENV
  echo "" >> $BRD_ENV

  echo "// STAGING" >> $BRD_ENV
  echo "STAGING_URL=$STAGING_URL" >> $BRD_ENV
  echo "STAGING_TOKEN=$STAGING_TOKEN" >> $BRD_ENV
  echo "" >> $BRD_ENV
  echo Please configure $BRD_ENV
  echo
  exit 1
fi

cd $DEV_DIR/$REPO
echo "sdk.dir=$HOME/Library/Android/Sdk" > ./local.properties
cp ./local.properties ./external/walletKit/walletKitJava/local.properties

# echo
# echo partying on the generated file
# echo
sed -i '' '18i\'$'\n        ndkVersion \'21.1.6352462\'\n\n' external/walletkit/WalletKitJava/corenative-android/build.gradle

echo
echo Open in Android Studio
echo
exit 1

echo
echo Building
echo
# emulator build   ../gradlew linkDebugFrameworkIosX64 linkReleaseFrameworkIosX64
./gradlew cosmos-bundled:createXCFramework

echo
echo end of build
echo
