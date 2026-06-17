# Namaz BD

A lightweight macOS **menu-bar app** that shows Islamic prayer times for Bangladesh, with a live countdown to the next prayer and local notifications. Everything is computed **offline** on your Mac — no internet, no accounts, no tracking.

---

## Features

- 🕌 Daily prayer times (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha)
- ⏱️ Live countdown to the next prayer, right in the menu bar
- 📍 All **64 districts** of Bangladesh (default: Dhaka)
- 🧮 Calculation methods: **Islamic Foundation Bangladesh**, Karachi, Muslim World League, Egyptian
- 🕋 Asr juristic: **Hanafi** (default) or Standard
- 🔔 Prayer-time notifications + optional early reminder
- 🪶 Tiny, native (SwiftUI), runs entirely offline

---

## Install (Homebrew)

```bash
brew tap jobayer977/namaz-bd
brew trust --cask jobayer977/namaz-bd/namaz-bd
brew install --cask namaz-bd
```

### First launch

The app isn't notarized (no paid Apple Developer account), so macOS blocks it the first time. To open it:

- **Applications → NamazBD → right-click → Open → Open**, or
- **System Settings → Privacy & Security → "Open Anyway"**, or run:

```bash
xattr -dr com.apple.quarantine /Applications/NamazBD.app
```

---

## How to use

1. After launching, look at the **top-right menu bar** (near the clock / Wi-Fi). You'll see a small icon with the countdown to the next prayer (e.g. `1h 24m`).
2. **Click it** to open the panel:
   - The **next prayer** with a live countdown at the top
   - All six daily times — the next one highlighted, past ones dimmed
   - Your location, calculation method, and timezone
3. Click **Settings** (gear, bottom-left) to change:
   - **District** (any of the 64)
   - **Calculation method**
   - **Asr juristic** (Hanafi / Standard)
   - **Notifications** and early-reminder lead time
4. **Quit** anytime from the bottom-right.

> The app lives only in the menu bar — there is no Dock icon and no window.

> **Crowded menu bar?** On MacBooks with a notch, items can hide behind it. Hold **⌘** and drag the icon to the left of the notch, or use a menu-bar manager like [Ice](https://github.com/jordanbaird/Ice).

---

## Update / uninstall

```bash
brew update && brew upgrade --cask namaz-bd   # update
brew uninstall --cask namaz-bd                # remove
```

---

## Prayer time calculation

Times are computed locally using standard solar-position astronomy. The default profile matches the **Islamic Foundation Bangladesh** convention (Fajr/Isha at 18°, Hanafi Asr). Verified against official Dhaka timetables (within ~1 minute; note that some printed tables add a small safety margin to Dhuhr).

| Method | Fajr | Isha |
| --- | --- | --- |
| Islamic Foundation Bangladesh | 18° | 18° |
| University of Islamic Sciences, Karachi | 18° | 18° |
| Muslim World League | 18° | 17° |
| Egyptian General Authority | 19.5° | 17.5° |

---

## Build from source

Requires the Xcode Command Line Tools (or full Xcode).

```bash
git clone https://github.com/jobayer977/namaz-bd.git
cd namaz-bd
./scripts/build-app.sh          # produces dist/NamazBD.app
./scripts/make-dmg.sh           # optional: dist/NamazBD.dmg installer
```

Run directly during development:

```bash
swift run NamazBD
```

---

## Releasing

Releases are fully automated. Push a version tag and GitHub Actions builds the app, publishes the release, and updates the Homebrew cask:

```bash
git tag v0.2.0 && git push origin v0.2.0
```

---

## Credits

Inspired by [**Prayer Times for macOS**](https://github.com/tareq1988/prayer-times-macos) by [Tareq Hasan](https://github.com/tareq1988) — a great native menu-bar prayer-times app. Namaz BD is an independent, from-scratch implementation focused on Bangladesh; it does not reuse that project's code, but credit goes to it for the idea and the menu-bar UX.
