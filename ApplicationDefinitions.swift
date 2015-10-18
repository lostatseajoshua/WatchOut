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

//MARK: Node bit masks
let circleBitMask: UInt32 = 0x1
let flyingObjectBitMask: UInt32 = 0x2

//MARK: SKAction keys
let flyingObjectCreationActionKey = "createObjects"

//MARK: NSLocalizedStrings
let subtitleString = NSLocalizedString("tap to begin", comment: "Instructing the user to tap the screen to begin the game.")
let titleString = NSLocalizedString("Watch Out", comment: "The title of the game")
let gameOverString = NSLocalizedString("Game Over", comment: "Game has ended")
let scoreString = NSLocalizedString("Score", comment: "Title to indicate the score of the game")

//MARK: Selector
let createFlyingNodeSelector: Selector = "createFlyingNode"
let appendScoreSelector: Selector = "appendScore"