// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NamazBD",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "PrayerKit"),
        .executableTarget(
            name: "NamazBD",
            dependencies: ["PrayerKit"]
        )
    ]
)
