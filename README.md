# Floating Timer

Always-on-top floating timer for macOS. Inspired by [Buoyant Timer](https://apps.apple.com/app/buoyant-timer/id1480446547).

## Features

- Always-on-top — floats above all windows, even full-screen apps
- Stopwatch and countdown modes
- Preset timers: 5m, 10m, 30m, 45m (or set custom)
- Sound alert when countdown finishes
- Click-through mode (interact with windows behind it)
- Draggable, no dock icon, lives in menu bar

## Quick Start

```bash
git clone https://github.com/himanshumehta/floating-timer.git
cd floating-timer
./run.sh
```

That's it. The timer will appear in the top-right corner of your screen.

> Requires macOS 13+ and Xcode (free from the App Store). If you don't have Xcode command line tools, the script will prompt you to install them.

## Usage

- **Start/Pause** — click the green Start button
- **Switch modes** — click Stopwatch or Countdown tabs
- **Set time** — use preset buttons or tap the pencil icon for custom
- **Move** — drag the dots at the top
- **Menu bar** — click the timer icon for Show/Hide/Reset/Click-Through/Quit

## First Launch Note

macOS may show a security warning since the app isn't from the App Store. If that happens, right-click the app and select **Open**.

## License

MIT
