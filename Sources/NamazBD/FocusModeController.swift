import AppKit
import SwiftUI
import PrayerKit

final class FullScreenOverlayWindow: NSWindow {
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        frameRect
    }

    override var canBecomeKey: Bool { true }
}

@MainActor
final class FocusModeController {
    private var windows: [NSWindow] = []
    private var dismissWork: DispatchWorkItem?

    func present(prayer: Prayer, prayerTime: Date, duration: TimeInterval) {
        dismiss(animated: false)
        let screens = NSScreen.screens
        guard !screens.isEmpty else { return }
        let endDate = Date().addingTimeInterval(duration)

        for screen in screens {
            windows.append(makeWindow(for: screen, prayer: prayer, prayerTime: prayerTime, endDate: endDate))
        }
        NSApp.activate(ignoringOtherApps: true)
        scheduleAutoDismiss(after: duration)
    }

    func dismiss(animated: Bool) {
        dismissWork?.cancel()
        dismissWork = nil
        let closing = windows
        windows = []
        guard !closing.isEmpty else { return }

        guard animated else {
            closing.forEach { $0.close() }
            return
        }

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.35
            closing.forEach { $0.animator().alphaValue = 0 }
        }, completionHandler: {
            closing.forEach { $0.close() }
        })
    }

    private func makeWindow(for screen: NSScreen, prayer: Prayer, prayerTime: Date, endDate: Date) -> NSWindow {
        let overlay = FocusOverlayView(prayer: prayer, prayerTime: prayerTime, endDate: endDate) { [weak self] in
            self?.dismiss(animated: true)
        }

        let panel = FullScreenOverlayWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        panel.level = .screenSaver
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        panel.contentView = NSHostingView(rootView: overlay)
        panel.setFrame(screen.frame, display: true)
        panel.makeKeyAndOrderFront(nil)
        return panel
    }

    private func scheduleAutoDismiss(after duration: TimeInterval) {
        let work = DispatchWorkItem { [weak self] in self?.dismiss(animated: true) }
        dismissWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }
}
