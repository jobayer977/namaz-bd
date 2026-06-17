import AppKit
import SwiftUI
import PrayerKit

@MainActor
final class FocusModeController {
    private var window: NSWindow?
    private var dismissWork: DispatchWorkItem?

    private let slideInDuration = 0.5
    private let slideOutDuration = 0.4

    func present(prayer: Prayer, prayerTime: Date, duration: TimeInterval) {
        dismiss(animated: false)
        guard let screen = NSScreen.main else { return }
        let endDate = Date().addingTimeInterval(duration)

        let overlay = FocusOverlayView(prayer: prayer, prayerTime: prayerTime, endDate: endDate) { [weak self] in
            self?.dismiss(animated: true)
        }

        let panel = NSWindow(
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

        panel.setFrame(offscreenFrame(for: screen), display: false)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = slideInDuration
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().setFrame(screen.frame, display: true)
        }

        window = panel
        scheduleAutoDismiss(after: duration)
    }

    func dismiss(animated: Bool) {
        dismissWork?.cancel()
        dismissWork = nil
        guard let panel = window else { return }
        window = nil

        guard animated, let screen = NSScreen.main else {
            panel.close()
            return
        }

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = slideOutDuration
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().setFrame(offscreenFrame(for: screen), display: true)
        }, completionHandler: {
            panel.close()
        })
    }

    private func scheduleAutoDismiss(after duration: TimeInterval) {
        let work = DispatchWorkItem { [weak self] in self?.dismiss(animated: true) }
        dismissWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }

    private func offscreenFrame(for screen: NSScreen) -> NSRect {
        var frame = screen.frame
        frame.origin.y = screen.frame.maxY
        return frame
    }
}
