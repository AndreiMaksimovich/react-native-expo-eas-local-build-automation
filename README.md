# Automated local builds of React Native Expo projects for Android, iOS, and Web

This repository contains an example setup for automating local React Native Expo builds with EAS.

**The workflow is configured to:**
* Build platform-specific apps (.apk, .ipa, web)
* Install .apk files on all connected Android devices
* Deploy .ipa files to all connected iOS devices
* Run the web build inside a Docker container


**Requirements**
* MacOS with Docker, Git, Android SDK, Xcode + CLI tools, cfgutil
* React Native Expo project configured for EAS builds (placed in ./react-native-project/)
* Eas credentials stored in ./credentials/credentials.preview.json
