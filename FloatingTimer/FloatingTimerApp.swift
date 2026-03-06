import SwiftUI

@main
struct FloatingTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

// Custom window that allows dragging from any non-interactive area
class DraggableWindow: NSWindow {
    var initialMouseLocation: NSPoint = .zero

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func mouseDown(with event: NSEvent) {
        initialMouseLocation = event.locationInWindow
    }

    override func mouseDragged(with event: NSEvent) {
        let currentLocation = NSEvent.mouseLocation
        let newOrigin = NSPoint(
            x: currentLocation.x - initialMouseLocation.x,
            y: currentLocation.y - initialMouseLocation.y
        )
        setFrameOrigin(newOrigin)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var timerWindow: NSWindow?
    var timerState = TimerState()
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBarItem()
        createFloatingWindow()
        // Hide dock icon since we're a menu bar + floating window app
        NSApp.setActivationPolicy(.accessory)
    }

    func setupMenuBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Floating Timer")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Timer", action: #selector(showTimer), keyEquivalent: "s"))
        menu.addItem(NSMenuItem(title: "Hide Timer", action: #selector(hideTimer), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Reset", action: #selector(resetTimer), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())

        let clickThroughItem = NSMenuItem(title: "Click-Through Mode", action: #selector(toggleClickThrough), keyEquivalent: "t")
        menu.addItem(clickThroughItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    func createFloatingWindow() {
        let contentView = TimerView(timerState: timerState)

        let window = DraggableWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 180),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentView = NSHostingView(rootView: contentView)
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.isMovableByWindowBackground = false
        window.titlebarAppearsTransparent = true

        // Position at top-right of screen
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let x = screenRect.maxX - 320
            let y = screenRect.maxY - 200
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }

        window.orderFront(nil)
        self.timerWindow = window
    }

    @objc func showTimer() {
        timerWindow?.orderFront(nil)
    }

    @objc func hideTimer() {
        timerWindow?.orderOut(nil)
    }

    @objc func resetTimer() {
        timerState.reset()
    }

    @objc func toggleClickThrough(_ sender: NSMenuItem) {
        guard let window = timerWindow else { return }
        let isClickThrough = window.ignoresMouseEvents
        window.ignoresMouseEvents = !isClickThrough
        sender.state = !isClickThrough ? .on : .off
        timerState.isClickThrough = !isClickThrough
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
