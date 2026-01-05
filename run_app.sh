#!/bin/bash
set -e

# Set correct NDK path
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/27.0.12077973
export PATH="$PATH:/Users/user/tools/flutter/bin"

echo "Using ANDROID_NDK_HOME: $ANDROID_NDK_HOME"

# Check if native folder exists
if [ ! -d "native/agent_dart" ]; then
    echo "Error: native/agent_dart not found!"
    exit 1
fi

# Build Rust lib for all architectures
echo "Building native Rust libraries..."
cd native/agent_dart
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../jniLibs build --release

cd ../../

# Continue with flutter run
echo "Starting flutter run..."
flutter run
