import SwiftUI

struct DragHandle: View {
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 4, height: 4)
            }
        }
        .padding(.vertical, 4)
    }
}

struct TimerView: View {
    @ObservedObject var timerState: TimerState
    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle area
            DragHandle()
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.001)) // invisible but draggable

            // Mode tabs
            HStack(spacing: 0) {
                modeTab(.stopwatch, label: "Stopwatch", icon: "stopwatch")
                modeTab(.countdown, label: "Countdown", icon: "timer")
            }
            .padding(.horizontal, 12)

            Spacer().frame(height: 6)

            // Timer display
            if timerState.mode == .countdown && timerState.isEditing {
                countdownEditor
            } else {
                timerDisplay
            }

            Spacer().frame(height: 8)

            // Controls
            HStack(spacing: 16) {
                // Reset button
                Button(action: { timerState.reset() }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(Color.white.opacity(0.15))
                        )
                }
                .buttonStyle(.plain)

                // Start/Pause button
                Button(action: { timerState.startStop() }) {
                    Label(
                        timerState.isRunning ? "Pause" : "Start",
                        systemImage: timerState.isRunning ? "pause.fill" : "play.fill"
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(
                        Capsule().fill(timerState.isRunning ? Color.orange : Color.green)
                    )
                }
                .buttonStyle(.plain)

                // Edit countdown (only in countdown mode, when stopped)
                if timerState.mode == .countdown && !timerState.isRunning {
                    Button(action: {
                        timerState.editMinutes = String(Int(timerState.countdownTotal) / 60)
                        timerState.editSeconds = String(format: "%02d", Int(timerState.countdownTotal) % 60)
                        timerState.isEditing.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 28, height: 28)
                            .background(
                                Circle().fill(Color.white.opacity(0.15))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            // Preset buttons for countdown
            if timerState.mode == .countdown && !timerState.isRunning && !timerState.isEditing {
                HStack(spacing: 8) {
                    ForEach([5, 10, 30, 45], id: \.self) { mins in
                        Button("\(mins)m") {
                            timerState.setCountdown(minutes: mins, seconds: 0)
                        }
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .buttonStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(Color.blue.opacity(0.3))
                        )
                    }
                }
                .padding(.top, 6)
            }

            Spacer().frame(height: 8)

            // Countdown progress bar
            if timerState.mode == .countdown && timerState.countdownTotal > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: geo.size.width * timerState.progress)
                            .animation(.linear(duration: 0.05), value: timerState.progress)
                    }
                }
                .frame(height: 3)
                .clipShape(Capsule())
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
        .frame(width: 300, height: timerState.mode == .countdown ? 180 : 150)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(white: 0.15), Color(white: 0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.5), radius: 10, y: 5)
        )
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private func modeTab(_ mode: TimerMode, label: String, icon: String) -> some View {
        Button(action: {
            if timerState.mode != mode {
                timerState.mode = mode
                timerState.reset()
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                Text(label)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(timerState.mode == mode ? .white : .white.opacity(0.4))
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(timerState.mode == mode ? Color.blue.opacity(0.5) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }

    private var timerDisplay: some View {
        Text(timerState.formattedTime)
            .font(.system(size: 52, weight: .thin, design: .monospaced))
            .foregroundColor(timerColor)
            .contentTransition(.numericText())
            .animation(.default, value: timerState.formattedTime)
    }

    private var countdownEditor: some View {
        HStack(spacing: 4) {
            TextField("mm", text: $timerState.editMinutes)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .light, design: .monospaced))

            Text(":")
                .font(.system(size: 24, weight: .light, design: .monospaced))
                .foregroundColor(.white)

            TextField("ss", text: $timerState.editSeconds)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .light, design: .monospaced))

            Button("Set") {
                timerState.confirmEdit()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(.horizontal, 16)
    }

    private var timerColor: Color {
        if timerState.isCountdownFinished {
            return .red
        }
        if timerState.mode == .countdown && timerState.progress > 0.8 {
            return .orange
        }
        return .white
    }

    private var borderColor: Color {
        if timerState.isCountdownFinished {
            return .red.opacity(0.5)
        }
        return .white.opacity(0.1)
    }

    private var progressColor: Color {
        if timerState.progress > 0.8 {
            return .red
        }
        if timerState.progress > 0.5 {
            return .orange
        }
        return .blue
    }
}
