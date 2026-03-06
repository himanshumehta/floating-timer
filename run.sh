#!/bin/bash
set -e

# Check for Xcode command line tools
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please re-run this script after installation completes."
    exit 1
fi

echo "Building Floating Timer..."
xcodebuild -project FloatingTimer.xcodeproj \
  -scheme FloatingTimer \
  -configuration Release \
  SYMROOT="$(pwd)/build" \
  build -quiet

echo "Launching..."
open build/Release/FloatingTimer.app
