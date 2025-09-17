#!/bin/bash

# Switch to the script folder
cd "$(dirname "$0")"

# 
export EXPO_NO_GIT_STATUS=1

# Paths
PROJECT_DIR="react-native-project"
APK_PATH="../builds/android.apk"
IPA_PATH="../builds/ios.ipa"
WEB_PATH="../builds/web"

# Git configuration
USE_GIT="true"
GIT_BRANCH="development"

# Switch to the project dir
cd "$PROJECT_DIR"

# Git checkout
if [ "$USE_GIT" == "true" ]; then
    git restore . --staged --worktree
    git pull
    git checkout $GIT_BRANCH
fi

# Clean
rm -rf android/*
rm -rf ios/*
rm -rf dist/*
rm -rf ../builds/*

# Create buids/web dir
mkdir $WEB_PATH

# Install Node packages and prebuild android/ios projects
npm install
npx expo prebuild --clean

# Copy credentials
cp ../credentials/credentials.preview.json ./credentials.json

# Build Android
eas build --platform android --local --profile preview --output "$APK_PATH"

# Build iOS
eas build --platform ios --local --profile preview --output "$IPA_PATH"

# Build Web
npx expo export -p web

# Move web build to buids/web
mv dist/* "$WEB_PATH"

# Remove changes
if [ "$USE_GIT" == "true" ]; then
    git restore . --staged --worktree
fi

# Install .apk on all connected Android devices
adb devices | grep "device$" | while read -r line; do
    DEVICE_ID=$(echo "$line" | awk '{print $1}')
    if [ "$DEVICE_ID" != "List" ]; then
        adb -s "$DEVICE_ID" install "$APK_PATH"
    fi
done

# Install .ipa on all connected iOS devices
cfgutil --foreach install-app "$IPA_PATH"

# Launch docker container with web build
sh ../docker/Up.sh
