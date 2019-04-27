//
//  ForecastViewModel.swift
//  CleaningRotation
//
//  Created by Harry Nelken on 4/27/19.
//  Copyright © 2019 Harry Nelken. All rights reserved.
//

import UIKit
import Foundation

protocol ForecastViewModelDelegate: AnyObject {
    func updateUIForCleaningDay()
    func updateUIForNonCleaningDay()
}

final class ForecastViewModel {

    weak var delegate: ForecastViewModelDelegate?

    // MARK: - Defaults

    private var lastRoom: Room {
        get {
            return Defaults.lastRoom
        } set {
            Defaults.setLastRoom(newValue)
        }
    }

    private var currentRoom: Room {
        get {
            return Defaults.currentRoom
        } set {
            Defaults.setCurrentRoom(newValue)
        }
    }

    private var recentCleaningDay: Bool {
        get {
            return Defaults.recentCleaningDay
        } set {
            Defaults.setRecentCleaningDay(newValue)
        }
    }

    // MARK: - UI Properties

    var detailText: String {
        return isCleaningDay
            ? "Clean:"
            : "Last room cleaned:"
    }

    var forecastText: String {
        return isCleaningDay
            ? currentRoom.rawValue
            : lastRoom.rawValue
    }

    var weekdayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }

    var calendarDateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: Date())
    }

    var separatorColor: UIColor {
        if isCleaningDay {
            return UIColor(rgb: 0x007AFF)
        } else {
            return .red
        }
    }

    // MARK: - Forecast

    private let cleaningDays = [4, 7]
    private let rotation: [Room] = [
        .livingRoom,
        .kitchen,
        .bathroom,
        .bedrooms,
        .diningRoom
    ]

    var isCleaningDay: Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return cleaningDays.contains(weekday)
    }

    func updateForecast() {
        if isCleaningDay {
            delegate?.updateUIForCleaningDay()
            recentCleaningDay = true
        } else {
            if recentCleaningDay {
                recentCleaningDay = false
                advanceForecast()
            }
            delegate?.updateUIForNonCleaningDay()
        }
    }

    private func advanceForecast() {
        guard let currentIndex = rotation.firstIndex(of: currentRoom) else { return }
        let nextIndex: Int
        if currentIndex == rotation.endIndex {
            nextIndex = rotation.startIndex
        } else {
            nextIndex = rotation.index(after: currentIndex)
        }
        lastRoom = currentRoom
        currentRoom = rotation[nextIndex]
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
