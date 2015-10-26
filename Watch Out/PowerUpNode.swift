//
//  PowerUpNode.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/22/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import SpriteKit

class PowerUpNode: SKShapeNode, RandomPositionGenerator {

    private var color: UIColor {
        get {
            return UIColor.blueColor()
        }
    }
    
    override init() {
        super.init()
        
        let circlePath = CGPathCreateMutable()
        CGPathAddArc(circlePath, nil, 0, 0, 10.0, 0, CGFloat(M_PI*2), true)
        
        self.path = circlePath
        
        self.fillColor = self.color
        self.strokeColor = self.color
        
        self.name = "PowerUp"
        
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
    
    convenience init(bounds: CGRect) {
        self.init()
        
        self.position = createRandomPointWithinBounds(bounds)
        let fadeInAction = SKAction.fadeInWithDuration(1.0)
        self.runAction(fadeInAction)
    }
}
