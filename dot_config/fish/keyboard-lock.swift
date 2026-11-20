
import Foundation
import CoreGraphics
import ApplicationServices

let required = 5
let window: TimeInterval = 2
let maxLockTime: TimeInterval = 120

var count = 0
var firstPress: Date?
var resetTimer: Timer?
var eventTap: CFMachPort?

func message(_ text: String) {
    print(text)
    fflush(stdout)
}

func reset() {
    count = 0
    firstPress = nil
    resetTimer?.invalidate()
    resetTimer = nil
    message("🔒 Press ESC 5 times within 2 seconds to unlock")
}

func handleKey(_ event: CGEvent) {
    let key = event.getIntegerValueField(.keyboardEventKeycode)
    let repeatKey = event.getIntegerValueField(.keyboardEventAutorepeat)

    // Ignore held-down key repeats
    if repeatKey != 0 { return }

    // Any other key resets the sequence
    guard key == 53 else {
        if count > 0 { reset() }
        return
    }

    let now = Date()

    if firstPress == nil || now.timeIntervalSince(firstPress!) >= window {
        count = 0
        firstPress = now

        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(withTimeInterval: window, repeats: false) { _ in
            if count > 0 { reset() }
        }
    }

    count += 1
    let remaining = required - count

    if remaining == 0 {
        message("🔓 Keyboard unlocked!")
        resetTimer?.invalidate()
        CFRunLoopStop(CFRunLoopGetMain())
    } else {
        message("🔑 ESC: \(remaining) remaining")
    }
}

let callback: CGEventTapCallBack = { _, type, event, _ in
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: true)
        }
        return Unmanaged.passUnretained(event)
    }

    if type == .keyDown {
        handleKey(event)
    }

    // Swallow all keyboard events, including modifiers
    return nil
}

// An active tap that swallows keys needs both permissions, granted to the
// terminal app running this script (System Settings > Privacy & Security).
guard AXIsProcessTrusted() else {
    message("❌ Accessibility permission required for your terminal.")
    exit(1)
}

guard CGPreflightListenEventAccess() else {
    _ = CGRequestListenEventAccess()
    message("❌ Input Monitoring permission required for your terminal. Grant it, restart the terminal, and retry.")
    exit(1)
}

let mask: CGEventMask =
    (1 << CGEventType.keyDown.rawValue) |
    (1 << CGEventType.keyUp.rawValue) |
    (1 << CGEventType.flagsChanged.rawValue)

guard let tap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: mask,
    callback: callback,
    userInfo: nil
) else {
    message("❌ Cannot create keyboard lock. Check macOS permissions.")
    exit(1)
}

eventTap = tap

let source = CFMachPortCreateRunLoopSource(nil, tap, 0)
CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
CGEvent.tapEnable(tap: tap, enable: true)

// Safety: automatically unlock after 2 minutes
let safetyTimer = Timer.scheduledTimer(withTimeInterval: maxLockTime, repeats: false) { _ in
    message("🔓 Safety timeout: keyboard unlocked.")
    CFRunLoopStop(CFRunLoopGetMain())
}

message("🧹 KEYBOARD CLEANING MODE")
message("🔒 Keyboard locked. Mouse/trackpad still works.")
message("Press ESC 5 times within 2 seconds to unlock.")

CFRunLoopRun()

safetyTimer.invalidate()
CGEvent.tapEnable(tap: tap, enable: false)
CFMachPortInvalidate(tap)

