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

- macOS 13.0+
- Xcode 15+

## How to Run

### Option 1: Build and run from Xcode

```bash
open FloatingTimer.xcodeproj
```

Then press `Cmd + R` to build and run.

### Option 2: Build from command line

```bash
# Clone the repo
git clone https://github.com/himanshumehta/floating-timer.git
cd floating-timer

# Build
xcodebuild -project FloatingTimer.xcodeproj -scheme FloatingTimer -configuration Release build

# Run (the app will be in DerivedData)
open ~/Library/Developer/Xcode/DerivedData/FloatingTimer-*/Build/Products/Release/FloatingTimer.app
```

### Option 3: Install to Applications

```bash
# Build release
xcodebuild -project FloatingTimer.xcodeproj -scheme FloatingTimer -configuration Release build

# Copy to Applications
cp -r ~/Library/Developer/Xcode/DerivedData/FloatingTimer-*/Build/Products/Release/FloatingTimer.app /Applications/

# Launch
open /Applications/FloatingTimer.app
```

## Usage

1. **Stopwatch** - Click the Stopwatch tab, then hit **Start**
2. **Countdown** - Click the Countdown tab, pick a preset (5m/10m/30m/45m) or tap the pencil icon to set a custom time, then hit **Start**
3. **Move** - Drag the three dots at the top of the window
4. **Menu bar** - Click the timer icon in the menu bar for Show/Hide/Reset/Click-Through/Quit

## License

MIT
