//
//  GameScene.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/3/15.
//  Copyright (c) 2015 Joshua Alvarado. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = false
    var selectedNode: SKNode!
    var animationInProgess = false
    var circleNode: CircleNode!
    var gameLogic = GameLogic()
    let scoreLabelNode = SKLabelNode()
    var flyingObjectCreationWaitDuration = 1.1
    var gameTimer: NSTimer!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        createBackground()
        gameIntroSetup()
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if gameStarted
            {
                if node.name == circleNode.name!
                {
                    self.selectedNode = node
                } else {
                    self.selectedNode = nil
                }
            } else {
                if node.name == howToPlayLabelNodeName {
                    removeGameIntro()
                } else {
                    gameLogic.resetScore()
                    beginGameStartAnimation(location)
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = selectedNode {
            for touch in touches {
                let newPoint = touch.locationInNode(self)
                circleNode.moveToPoint(newPoint)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //MARK: Object Creation
    
    func createFlyingObjects() {
        let createFlyingNodeAction = SKAction.runBlock({
            let node = FlyingObject(bounds: self.view!.bounds)
            self.addChild(node)
        })
        self.flyingObjectCreationWaitDuration = flyingObjectCreationWaitDuration - 0.1
        let sequence = SKAction.sequence([createFlyingNodeAction,SKAction.waitForDuration((flyingObjectCreationWaitDuration - 0.1))])
        let repeatAction = SKAction.repeatActionForever(sequence)
        self.runAction(repeatAction, withKey: flyingObjectCreationActionKey)
    }
    
    func createBackground() {
        self.backgroundColor = UIColor.blackColor()
    }
    
    func createScoreLabel() {
        scoreLabelNode.text = "\(gameLogic.gameScore)"
        scoreLabelNode.position = CGPointMake(self.frame.midX, self.frame.maxY - 60)
        scoreLabelNode.color = UIColor.whiteColor()
        scoreLabelNode.name = scoreLabelNodeName
        self.addChild(scoreLabelNode)
    }
    
    func createPowerUps() {
        
        let createPowerUpAction = SKAction.runBlock({
        
            //create random int to choose power up
            let randomInt = arc4random_uniform(4)
            
            let powerUpNode: PowerUpNode
            
            if let powerUpType = PowerUpType(rawValue: Int(randomInt)) {
                powerUpNode = PowerUpNode(bounds: self.view!.bounds, withPowerUpType: powerUpType)
            } else  {
                powerUpNode = PowerUpNode(bounds: self.view!.bounds, withPowerUpType: .Shrink)
            }
            
            self.addChild(powerUpNode)
        })
        
        let waitDurationAction = SKAction.waitForDuration(5, withRange: 9)
        
        let sequenceAction = SKAction.sequence([waitDurationAction,createPowerUpAction])
        let repeatAction = SKAction.repeatActionForever(sequenceAction)
        self.runAction(repeatAction, withKey: powerUpObjectCreationActionKey)
    }
    
    //MARK: Utilites
    func beginGameStartAnimation(location: CGPoint) {
        if animationInProgess == false {
            animationInProgess = true

            removeGameIntro()
            removeGameOver()
            
            self.circleNode = CircleNode(location: location, creationCompletionBlock: {
                self.animationInProgess = false
                self.gameStarted = true
                self.createScoreLabel()
                self.createFlyingObjects()
                self.createGameTimer()
                self.createPowerUps()
            })
            self.addChild(circleNode)
        }
    }
    
    func gameIntroSetup() {
        let titleLabel = SKLabelNode(text: titleString)
        titleLabel.fontSize = self.frame.width / 7
        titleLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
        titleLabel.name = titleLabelNodeName
        
        let subtitleLabel = SKLabelNode(text: subtitleString)
        subtitleLabel.fontSize = self.frame.width / 13
        subtitleLabel.position = CGPointMake(self.frame.midX, self.frame.midY - titleLabel.frame.height)
        subtitleLabel.name = subtitleLabelNodeName
        
        
        let howToPlayLabel = SKLabelNode(text: howToPlayString)
        howToPlayLabel.fontSize = self.frame.width / 14
        howToPlayLabel.position = CGPointMake(self.frame.midX, self.frame.minY + (howToPlayLabel.frame.height * 1.5))
        howToPlayLabel.name = howToPlayLabelNodeName
        howToPlayLabel.fontColor = UIColor.whiteColor()
        
        self.addChild(titleLabel)
        self.addChild(subtitleLabel)
        self.addChild(howToPlayLabel)

    }
    
    func removeGameIntro() {
        let titleNode = self.childNodeWithName(titleLabelNodeName)
        let subtitleNode = self.childNodeWithName(subtitleLabelNodeName)
        let howToPlayNode = self.childNodeWithName(howToPlayLabelNodeName)
        
        let fadeOutAction = SKAction.fadeOutWithDuration(2.0)
        
        titleNode?.runAction(fadeOutAction)
        subtitleNode?.runAction(fadeOutAction)
        howToPlayNode?.runAction(fadeOutAction)
        titleNode?.removeFromParent()
        subtitleNode?.removeFromParent()
        howToPlayNode?.removeFromParent()
        
    }
    
    func gameOverSetup() {
        let gameOverLabel = SKLabelNode(text: gameOverString)
        gameOverLabel.fontSize = self.frame.width / 10
        gameOverLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
        gameOverLabel.name = gameOverLabelNodeName
        
        let gameOverScoreLabelString = scoreString + ": " + "\(gameLogic.gameScore)"
        
        let gameOverScoreLabel = SKLabelNode(text: gameOverScoreLabelString)
        gameOverScoreLabel.fontSize = self.frame.width / 20
        gameOverScoreLabel.position = CGPointMake(self.frame.midX, self.frame.midY - gameOverLabel.frame.height)
        gameOverScoreLabel.name = gameOverScoreLabelNodeName
        
        self.addChild(gameOverLabel)
        self.addChild(gameOverScoreLabel)
    }
    
    func removeGameOver() {
        let gameOverLabel = self.childNodeWithName(gameOverLabelNodeName)
        let gameOverScoreLabel = self.childNodeWithName(gameOverScoreLabelNodeName)
        
        let fadeOutAction = SKAction.fadeOutWithDuration(2.0)
        
        gameOverLabel?.runAction(fadeOutAction)
        gameOverScoreLabel?.runAction(fadeOutAction)
        gameOverLabel?.removeFromParent()
        gameOverScoreLabel?.removeFromParent()
    }
    
    func gameOver() {
        //stop game timer
        gameTimer.invalidate()
        self.gameTimer = nil
        
        //remove all nodes and actions
        self.removeAllChildren()
        self.removeAllActions()
        
        //reset game changes
        flyingObjectCreationWaitDuration = 1.1
        gameStarted = false

        //display game over
        gameOverSetup()
    }
    
    func createGameTimer() {
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: appendScoreSelector, userInfo: nil, repeats: true)
    }
    
    func appendScore() {
        gameLogic.appendScore()
        scoreLabelNode.text = "\(gameLogic.gameScore)"
        
        if gameLogic.gameScore % 15 == 0 {
            if flyingObjectCreationWaitDuration > 0.1 {
                self.removeActionForKey(flyingObjectCreationActionKey)
                createFlyingObjects()
            }
        }
    }
    
    //MARK: Node manipulation
    
    func removeAllFlyingObjectNodes() {
        for node in self.children {
            if node is FlyingObject {
                node.removeFromParent()
            }
        }
    }
    
    
    //MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        if let bodyANodeName = contact.bodyA.node?.name, let bodyBNodeName = contact.bodyB.node?.name {
            if bodyANodeName == circleNodeName || bodyBNodeName == circleNodeName {
                if bodyANodeName == flyingObjectNodeName || bodyBNodeName == flyingObjectNodeName {
                    gameOver()
                } else if bodyANodeName == powerUpNodeName || bodyBNodeName == powerUpNodeName {
                    if contact.bodyA.node is PowerUpNode {
                        (contact.bodyA.node as! PowerUpNode).performPowerUp()
                        return
                    }
                    if contact.bodyB.node is PowerUpNode {
                        (contact.bodyB.node as! PowerUpNode).performPowerUp()
                        return
                    }
                }
            }
        }
    }

}
