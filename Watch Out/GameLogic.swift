//
//  GameLogic.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/4/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation

class GameLogic: NSObject {
    private var score = 0
    
    var gameScore: Int {
        return score
    }
    
    func resetScore() {
        score = 0
    }
    
    func appendScore() {
        self.score++
    }
}
