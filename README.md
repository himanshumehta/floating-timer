# Floating Timer

Always-on-top floating timer for macOS with stopwatch and countdown modes. Inspired by [Buoyant Timer](https://apps.apple.com/app/buoyant-timer/id1480446547).

## Features

- **Always-on-top** - Floats above all windows, including full-screen apps
- **Stopwatch mode** - Count up from zero
- **Countdown mode** - Set a timer with presets (5m, 10m, 30m, 45m) or custom duration
- **Sound alert** - Plays a sound when countdown finishes
- **Click-through mode** - Toggle from menu bar so clicks pass through to windows below
- **Draggable** - Drag the dot handle at the top to reposition
- **Menu bar controls** - Show/Hide, Reset, Click-Through, Quit
- **No dock icon** - Runs as a lightweight menu bar app

## Requirements

- **macOS 13.0 (Ventura)** or later
- **Xcode 15+** with Command Line Tools installed

> This is a native macOS app. It does not run on Windows or Linux.

To install Xcode Command Line Tools (if not already installed):

```bash
xcode-select --install
```

## How to Run

### Option 1: Build and run from Xcode

```bash
git clone https://github.com/himanshumehta/floating-timer.git
cd floating-timer
open FloatingTimer.xcodeproj
```

Then press `Cmd + R` to build and run.

### Option 2: Build from command line

```bash
git clone https://github.com/himanshumehta/floating-timer.git
cd floating-timer

# Build (output goes to ./build)
xcodebuild -project FloatingTimer.xcodeproj \
  -scheme FloatingTimer \
  -configuration Release \
  SYMROOT="$(pwd)/build" \
  build

# Run
open build/Release/FloatingTimer.app
```

### Option 3: Install to Applications

```bash
git clone https://github.com/himanshumehta/floating-timer.git
cd floating-timer

# Build release
xcodebuild -project FloatingTimer.xcodeproj \
  -scheme FloatingTimer \
  -configuration Release \
  SYMROOT="$(pwd)/build" \
  build

# Copy to Applications
cp -r build/Release/FloatingTimer.app /Applications/

# Launch
open /Applications/FloatingTimer.app
```

## Code Signing

The app is configured to sign with "Sign to Run Locally" (ad-hoc signing). This means:

- It builds and runs on any Mac without an Apple Developer account
- macOS Gatekeeper may show a warning on first launch — right-click the app and select **Open** to bypass it
- If you want to distribute the app, you'll need to sign it with a valid Developer ID

## Usage

1. **Stopwatch** - Click the Stopwatch tab, then hit **Start**
2. **Countdown** - Click the Countdown tab, pick a preset (5m/10m/30m/45m) or tap the pencil icon to set a custom time, then hit **Start**
3. **Move** - Drag the three dots at the top of the window
4. **Menu bar** - Click the timer icon in the menu bar for Show/Hide/Reset/Click-Through/Quit

## License

MIT
