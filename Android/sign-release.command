#!/bin/zsh

set -euo pipefail

ANDROID_DIR="${0:A:h}"
DEFAULT_KEYSTORE="$HOME/Documents/PrepNexus Signing/prepnexus-upload-key.jks"
JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
KEYTOOL="$JAVA_HOME/bin/keytool"
JARSIGNER="$JAVA_HOME/bin/jarsigner"

if [[ ! -x "$KEYTOOL" || ! -x "$JARSIGNER" ]]; then
  echo "Android Studio's Java signing tools were not found."
  echo "Expected them under: $JAVA_HOME/bin"
  exit 1
fi

read "PREPNEXUS_KEYSTORE_PATH?Keystore path [$DEFAULT_KEYSTORE]: "
PREPNEXUS_KEYSTORE_PATH="${PREPNEXUS_KEYSTORE_PATH:-$DEFAULT_KEYSTORE}"

if [[ ! -f "$PREPNEXUS_KEYSTORE_PATH" ]]; then
  echo "Keystore not found: $PREPNEXUS_KEYSTORE_PATH"
  exit 1
fi

read -s "PREPNEXUS_KEYSTORE_PASSWORD?Keystore password: "
echo

export PREPNEXUS_KEYSTORE_PASSWORD
echo "Available key aliases:"
if ! "$KEYTOOL" -list \
  -keystore "$PREPNEXUS_KEYSTORE_PATH" \
  -storepass:env PREPNEXUS_KEYSTORE_PASSWORD; then
  unset PREPNEXUS_KEYSTORE_PASSWORD
  echo "The keystore password was not accepted. No bundle was created."
  exit 1
fi

read "PREPNEXUS_KEY_ALIAS?Key alias: "
if [[ -z "$PREPNEXUS_KEY_ALIAS" ]]; then
  unset PREPNEXUS_KEYSTORE_PASSWORD
  echo "A key alias is required."
  exit 1
fi

if ! "$KEYTOOL" -list \
  -alias "$PREPNEXUS_KEY_ALIAS" \
  -keystore "$PREPNEXUS_KEYSTORE_PATH" \
  -storepass:env PREPNEXUS_KEYSTORE_PASSWORD >/dev/null; then
  unset PREPNEXUS_KEYSTORE_PASSWORD
  echo "Alias '$PREPNEXUS_KEY_ALIAS' was not found in this keystore."
  exit 1
fi

read -s "PREPNEXUS_KEY_PASSWORD?Key password (press Return if it matches the keystore password): "
echo
PREPNEXUS_KEY_PASSWORD="${PREPNEXUS_KEY_PASSWORD:-$PREPNEXUS_KEYSTORE_PASSWORD}"

export PREPNEXUS_KEYSTORE_PATH
export PREPNEXUS_KEY_ALIAS
export PREPNEXUS_KEY_PASSWORD

cleanup() {
  unset PREPNEXUS_KEYSTORE_PATH
  unset PREPNEXUS_KEYSTORE_PASSWORD
  unset PREPNEXUS_KEY_ALIAS
  unset PREPNEXUS_KEY_PASSWORD
}
trap cleanup EXIT

cd "$ANDROID_DIR"
JAVA_HOME="$JAVA_HOME" ./gradlew \
  --no-configuration-cache \
  :app:clean \
  :app:testDebugUnitTest \
  :app:lintDebug \
  :app:bundleRelease

BUNDLE="$ANDROID_DIR/app/build/outputs/bundle/release/app-release.aab"
"$JARSIGNER" -verify "$BUNDLE" >/dev/null

echo
echo "Signed release bundle created:"
echo "$BUNDLE"
shasum -a 256 "$BUNDLE"
