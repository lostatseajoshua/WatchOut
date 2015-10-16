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
    let labelNode = SKLabelNode()
    var flyingObjectCreationWaitDuration = 1.1
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        createBackground()
        createScoreLabel()
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
                beginGameStartAnimation(location)
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
        if gameStarted {
            gameLogic.score += 1
            if gameLogic.score % 20 == 0 {
                labelNode.text = "\(gameLogic.score)"
            }
            if gameLogic.score % 500 == 0 {
                self.removeActionForKey(flyingObjectCreationActionKey)
                createFlyingObjects()
            }
        }
    }
    
    //MARK: Object Creation
    
    func createFlyingObjects() {
        let createFlyingNode = SKAction.performSelector("createFlyingNode", onTarget: self)
        self.flyingObjectCreationWaitDuration = flyingObjectCreationWaitDuration - 0.1
        let sequence = SKAction.sequence([createFlyingNode,SKAction.waitForDuration((flyingObjectCreationWaitDuration - 0.1))])
        print(flyingObjectCreationWaitDuration)
        let repeatAction = SKAction.repeatActionForever(sequence)
        self.runAction(repeatAction, withKey: flyingObjectCreationActionKey)
    }
    
    func createFlyingNode() {
        let node = FlyingObject(bounds: self.view!.bounds)
        self.addChild(node)
    }
    
    func createBackground() {
        self.backgroundColor = UIColor.blackColor()
    }
    
    func createScoreLabel() {
        labelNode.text = "\(gameLogic.score)"
        labelNode.position = CGPointMake(300, 300)
        labelNode.color = UIColor.whiteColor()
        self.addChild(labelNode)
    }
    
    //MARK: Utilites
    func beginGameStartAnimation(location: CGPoint) {
        if animationInProgess == false {
            animationInProgess = true
            self.circleNode = CircleNode(location: location, creationCompletionBlock: {
                self.animationInProgess == false
                self.gameStarted = true
                self.createFlyingObjects()
            })
            self.addChild(circleNode)
        }
    }
    
    
    //MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        self.paused = true
    }

}
