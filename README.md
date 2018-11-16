fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### fastlane_test
```
fastlane fastlane_test
```
Test lane

----

## iOS
### ios dev
```
fastlane ios dev
```
iOS development build
### ios staging
```
fastlane ios staging
```
iOS staging build
### ios release
```
fastlane ios release
```
iOS release build, upload to App Store

----

## Android
### android dev
```
fastlane android dev
```
Android development build
### android staging
```
fastlane android staging
```
Android staging build
### android release
```
fastlane android release
```
Android release build, upload to Play Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
