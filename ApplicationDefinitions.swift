//
//  ApplicationDefinitions.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/3/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation

//MARK: Name of nodes
let circleNodeName = "Circle"
let titleLabelNodeName = "titleLabel"
let subtitleLabelNodeName = "subtitleLabel"
let scoreLabelNodeName = "scoreLabel"
let gameOverLabelNodeName = "gameoverLabel"
let gameOverScoreLabelNodeName = "gameoverScoreLabel"
let howToPlayLabelNodeName = "howToPlayLabel"
let flyingObjectNodeName = "flyingObject"
let powerUpNodeName = "powerUp"

//MARK: Node bit masks
let circleBitMask: UInt32 = 0x1
let flyingObjectBitMask: UInt32 = 0x2
let powerUpBitMask: UInt32 = 0x3

//MARK: SKAction keys
let flyingObjectCreationActionKey = "createObjects"
let powerUpObjectCreationActionKey = "createPowerUp"

//MARK: NSLocalizedStrings
let subtitleString = NSLocalizedString("tap to begin", comment: "Instructing the user to tap the screen to begin the game.")
let titleString = NSLocalizedString("Watch Out", comment: "The title of the game")
let gameOverString = NSLocalizedString("Game Over", comment: "Game has ended")
let scoreString = NSLocalizedString("Score", comment: "Title to indicate the score of the game")
let howToPlayString = NSLocalizedString("How to play", comment: "Button label to give instructions to user on the game")

//MARK: Selector
let appendScoreSelector: Selector = "appendScore"
let reverseInvinciblilityOnUserSelector: Selector = "reverseInvinciblilityOnUserNode"