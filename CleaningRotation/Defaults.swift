//
//  Defaults.swift
//  CleaningRotation
//
//  Created by Harry Nelken on 4/27/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import Foundation

struct Defaults {

    private static let lastRoomKey = "lastRoomKey"
    private static let currentRoomKey = "currentRoomKey"
    private static let recentCleaningDayKey = "recentCleaningDayKey"

    // MARK: - Access

    static var lastRoom: Room {
        guard
            let string = UserDefaults.standard.string(forKey: lastRoomKey),
            let room = Room(rawValue: string)
            else { return .livingRoom }
        return room
    }

    static var currentRoom: Room {
        guard
            let string = UserDefaults.standard.string(forKey: currentRoomKey),
            let room = Room(rawValue: string)
            else { return .livingRoom }
        return room
    }

    static var recentCleaningDay: Bool {
        return UserDefaults.standard.bool(forKey: recentCleaningDayKey)
    }

    // MARK: - Mutation

    static func setLastRoom(_ value: Room) {
        UserDefaults.standard.set(
            value.rawValue,
            forKey: lastRoomKey
        )
    }

    static func setCurrentRoom(_ value: Room) {
        UserDefaults.standard.set(
            value.rawValue,
            forKey: currentRoomKey
        )
    }

    static func setRecentCleaningDay(_ value: Bool) {
        UserDefaults.standard.set(
            value,
            forKey: recentCleaningDayKey
        )
    }
}
