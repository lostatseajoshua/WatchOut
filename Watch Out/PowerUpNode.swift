//
//  PowerUpNode.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/22/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import SpriteKit

class PowerUpNode: SKShapeNode, RandomPositionGenerator {

    private var color: UIColor = UIColor.blueColor()
    
    var powerUpType: PowerUpType = .Remove
    
    override init() {
        super.init()
        
        let circlePath = CGPathCreateMutable()
        CGPathAddArc(circlePath, nil, 0, 0, 10.0, 0, CGFloat(M_PI*2), true)
        
        self.path = circlePath
        
        self.fillColor = self.color
        self.strokeColor = self.color
        
        self.name = powerUpNodeName
        
        //Creation action
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = powerUpBitMask
        self.physicsBody?.contactTestBitMask = circleBitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private convenience init(bounds: CGRect) {
        self.init()
        
        self.position = createRandomPointWithinBounds(bounds)
        let fadeInAction = SKAction.fadeInWithDuration(1.0)
        self.runAction(fadeInAction)
        
    }
    
    convenience init(bounds: CGRect, withPowerUpType powerupType: PowerUpType) {
        self.init()
        
        let circlePath = CGPathCreateMutable()
        CGPathAddArc(circlePath, nil, 0, 0, 10.0, 0, CGFloat(M_PI*2), true)
        
        self.path = circlePath
        
        switch powerupType {
        case .Invincible:
            self.fillColor = UIColor.purpleColor()
            self.strokeColor = UIColor.purpleColor()
        case .Remove:
            self.fillColor = UIColor.redColor()
            self.strokeColor = UIColor.redColor()
        case .Shrink:
            self.fillColor = UIColor.yellowColor()
            self.strokeColor = UIColor.yellowColor()
        case .Slow:
            self.fillColor = UIColor.grayColor()
            self.strokeColor = UIColor.grayColor()
        }
        
        self.name = powerUpNodeName
        
        self.powerUpType = powerupType
        
        //Creation action
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = powerUpBitMask
        self.physicsBody?.contactTestBitMask = circleBitMask
        
        self.position = createRandomPointWithinBounds(bounds)
        let fadeInAction = SKAction.fadeInWithDuration(1.0)
        self.runAction(fadeInAction)
        
    }
    
    //MARK: Power Ups
    
    func performPowerUp() {
        switch self.powerUpType {
        case .Invincible:
            makeUserNodeInvincible()
        case .Remove:
            removeFlyingObjectNodes()
            self.removeFromParent()
        case .Shrink:
            shrink()
            self.removeFromParent()
        case .Slow:
            slowFlyingNodesSpeed()
            self.removeFromParent()
        }
    }
    
    private func removeFlyingObjectNodes() {
        if let parentNode = self.parent {
            for node in parentNode.children {
                if node is FlyingObject {
                    node.removeFromParent()
                }
            }
        }
    }
    
    private func makeUserNodeInvincible() {
        if let parentNode = self.parent {
            for node in parentNode.children {
                if node is CircleNode {
                    node.physicsBody = nil
                }
            }
        }
        
        self.alpha = 0
        self.physicsBody = nil
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: reverseInvinciblilityOnUserSelector, userInfo: nil, repeats: false)
    }
    
    private func slowFlyingNodesSpeed() {
        if let  parentNode = self.parent {
            for node in parentNode.children {
                if node is FlyingObject {
                    node.speed = 0.5
                }
            }
        }
    }
    
    private func shrink() {
        if let parentNode = self.parent {
            for node in parentNode.children {
                if node is CircleNode {
                    let shrinkAction = SKAction.scaleBy(0.5, duration: 1)
                    let growAction = SKAction.scaleBy(2.0, duration: 1)
                    
                    let physicsBodyShrinkChangeAction = SKAction.runBlock({
                        node.physicsBody = nil
                        node.physicsBody = SKPhysicsBody(circleOfRadius: 15)
                        node.physicsBody?.dynamic = true
                        node.physicsBody?.affectedByGravity = false
                        node.physicsBody?.categoryBitMask = circleBitMask
                        node.physicsBody?.contactTestBitMask = flyingObjectBitMask
                    })
                    
                    let physicsBodyGrowChangeAction = SKAction.runBlock({
                        node.physicsBody = nil
                        node.physicsBody = SKPhysicsBody(circleOfRadius: 30)
                        node.physicsBody?.dynamic = true
                        node.physicsBody?.affectedByGravity = false
                        node.physicsBody?.categoryBitMask = circleBitMask
                        node.physicsBody?.contactTestBitMask = flyingObjectBitMask
                    })

                    
                    let shrinkAndGrowAction = SKAction.sequence([shrinkAction, physicsBodyShrinkChangeAction, SKAction.waitForDuration(3),growAction, physicsBodyGrowChangeAction])
                    node.runAction(shrinkAndGrowAction)
                }
            }
        }
    }
    
    func reverseInvinciblilityOnUserNode() {
        if let parentNode = self.parent {
            for node in parentNode.children {
                if node is CircleNode {
                    node.physicsBody = SKPhysicsBody(circleOfRadius: 30)
                    node.physicsBody?.dynamic = true
                    node.physicsBody?.affectedByGravity = false
                    node.physicsBody?.categoryBitMask = circleBitMask
                    node.physicsBody?.contactTestBitMask = flyingObjectBitMask
                }
            }
        }
        self.removeFromParent()
    }
}

enum PowerUpType {
    case Remove
    case Shrink
    case Invincible
    case Slow
}
