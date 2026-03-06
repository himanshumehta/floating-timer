import SwiftUI
import Combine

enum TimerMode: String, CaseIterable {
    case stopwatch = "Stopwatch"
    case countdown = "Countdown"
}

class TimerState: ObservableObject {
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var isRunning = false
    @Published var mode: TimerMode = .stopwatch
    @Published var countdownTotal: TimeInterval = 300 // 5 minutes default
    @Published var isClickThrough = false
    @Published var isEditing = false
    @Published var editMinutes: String = "5"
    @Published var editSeconds: String = "00"

    private var timer: AnyCancellable?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0

    var displayTime: TimeInterval {
        switch mode {
        case .stopwatch:
            return elapsedSeconds
        case .countdown:
            return max(countdownTotal - elapsedSeconds, 0)
        }
    }

    var isCountdownFinished: Bool {
        mode == .countdown && elapsedSeconds >= countdownTotal
    }

    var formattedTime: String {
        let total = displayTime
        let hours = Int(total) / 3600
        let minutes = (Int(total) % 3600) / 60
        let seconds = Int(total) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var progress: Double {
        guard mode == .countdown, countdownTotal > 0 else { return 0 }
        return min(elapsedSeconds / countdownTotal, 1.0)
    }

    func startStop() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func start() {
        guard !isRunning else { return }
        if mode == .countdown && isCountdownFinished {
            reset()
        }
        isRunning = true
        startDate = Date()
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let start = self.startDate else { return }
                self.elapsedSeconds = self.accumulatedTime + Date().timeIntervalSince(start)

                if self.isCountdownFinished {
                    self.pause()
                    self.flashWindow()
                }
            }
    }

    func pause() {
        isRunning = false
        if let start = startDate {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        startDate = nil
        timer?.cancel()
        timer = nil
    }

    func reset() {
        pause()
        elapsedSeconds = 0
        accumulatedTime = 0
    }

    func setCountdown(minutes: Int, seconds: Int) {
        countdownTotal = TimeInterval(minutes * 60 + seconds)
        reset()
    }

    func confirmEdit() {
        let mins = Int(editMinutes) ?? 0
        let secs = Int(editSeconds) ?? 0
        setCountdown(minutes: mins, seconds: secs)
        isEditing = false
    }

    private func flashWindow() {
        NSApp.requestUserAttention(.criticalRequest)
    }
}
