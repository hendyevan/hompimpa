//
//  Snooze.swift
//  Hompimpa
//
//  Created by hendy evan on 23/11/18.
//

import Foundation

public class Snooze {
    public func start() {
        let interval = TimeInterval(arc4random_uniform(100))
        Thread.sleep(forTimeInterval: interval)
    }
}
