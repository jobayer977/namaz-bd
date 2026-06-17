import SwiftUI
import PrayerKit

struct FocusOverlayView: View {
    let prayer: Prayer
    let prayerTime: Date
    let endDate: Date
    let onDismiss: () -> Void

    @State private var revealed = false

    var body: some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(background)
                .offset(y: revealed ? 0 : -geometry.size.height)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) { revealed = true }
                }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }

    private var background: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            Color.black.opacity(0.6)
        }
    }

    private var content: some View {
        VStack(spacing: 18) {
            Image(systemName: prayer.symbolName)
                .font(.system(size: 68))
                .foregroundStyle(prayer.symbolTint)

            VStack(spacing: 6) {
                Text("It's time for \(prayer.englishName)")
                    .font(.system(size: 36, weight: .bold))
                Text("\(prayer.banglaName) · \(TimeFormatting.clock(prayerTime))")
                    .font(.system(size: 18))
                    .foregroundStyle(.white.opacity(0.7))
            }

            Text("Take a moment to step away and pray 🤲")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.7))

            TimelineView(.periodic(from: .now, by: 1)) { context in
                let remaining = max(0, endDate.timeIntervalSince(context.date))
                Text("Focus mode · \(TimeFormatting.countdown(remaining)) remaining")
                    .font(.system(size: 13, weight: .medium))
                    .monospacedDigit()
                    .foregroundStyle(BrandTheme.accent)
            }
            .padding(.top, 4)

            Button(action: onDismiss) {
                Text("Dismiss")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 11)
                    .background(Capsule().fill(BrandTheme.accent))
            }
            .buttonStyle(.plain)
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
    }
}
