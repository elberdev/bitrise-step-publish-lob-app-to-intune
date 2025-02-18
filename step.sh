#!/bin/bash
set -e

echo "Starting Intune Step"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    echo "Running on Linux"

    # Update the list of packages
    sudo apt-get update
    # Install pre-requisite packages.
    sudo apt-get install -y wget apt-transport-https software-properties-common
    # Download the Microsoft repository GPG keys
    wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
    # Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb
    # Update the list of packages after we added packages.microsoft.com
    sudo apt-get update
    # Install PowerShell
    sudo apt-get install -y powershell
fi

if [[ "$OSTYPE" == "darwin"* ]]; then 
    echo "Running on MacOS"
fi

if [ -z "$android_apk_path" ]; 
    then echo "Skipping APK upload. No APK path provided"; 
else 
    echo "Android APK to be uploaded: '$android_apk_path'"; 
    if [ -z "$android_publisher" ] || [ -z "$android_description" ] || [ -z "$android_identity_name" ] || [ -z "$android_identity_version" ] || [ -z "$android_version_name" ]; then
        echo "Error: APK provided without necessary metadata. The step requires: publisher, description, identity name, identity version, and version name" >&2
        exit 1
    fi
fi

if [ -z "$ios_ipa_path" ]; 
    then echo "Skipping IPA upload. No IPA path provided"; 
else 
    echo "iOS IPA to be uploaded: '$ios_ipa_path'"; 
    if [ -z "$ios_publisher" ] || [ -z "$ios_description" ] || [ -z "$ios_display_name" ] || [ -z "$ios_identity_version" ] || [ -z "$ios_version_number" ] || [ -z "$ios_bundle_id" ] || [ -z "$ios_expiration" ]; then
        echo "Error: iOS IPA provided without necessary metadata. The step requires: display name, publisher, description, identity version, version number, bundle id, and expiration." >&2
        exit 1
    fi
fi

TMP_CURRENT_DIR="$( pwd )"
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $THIS_SCRIPT_DIR

echo '$' "npm i @azure/identity"
npm i @azure/identity
echo '$' "npm i @microsoft/microsoft-graph-client"
npm i @microsoft/microsoft-graph-client
echo '$' "npm i isomorphic-fetch"
npm i isomorphic-fetch


echo '$' "node "$THIS_SCRIPT_DIR/src/msft_auth.js""

export MSFT_TOKEN=$(node "$THIS_SCRIPT_DIR/src/msft_auth.js")

echo "pwsh $THIS_SCRIPT_DIR/src/Application_LOB_Add.ps1"

pwsh $THIS_SCRIPT_DIR/src/Application_LOB_Add.ps1
