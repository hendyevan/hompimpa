//
//  Snooze.swift
//  Hompimpa
//
//  Created by hendy evan on 23/11/18.
//

import Foundation

open class Snooze {
    open func start() {
        let interval = TimeInterval(arc4random_uniform(100))
        Thread.sleep(forTimeInterval: interval)
    }
}

extension String {
    var isBlanks: Bool {
        get {
            let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}
