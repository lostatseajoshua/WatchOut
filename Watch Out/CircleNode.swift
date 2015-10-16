//
//  CircleNode.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 4/12/15.
//  Copyright (c) 2015 Joshua Alvarado. All rights reserved.
//

import SpriteKit


class CircleNode: SKShapeNode {
        
    var size = CGSize(width: 30, height: 30)
    
    private var color: UIColor {
        get {
          return UIColor.redColor()
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(location: CGPoint, creationCompletionBlock: () -> Void ) {
        self.init()
        
        let circlePath = CGPathCreateMutable()
        CGPathAddArc(circlePath, nil, 0, 0, 30.0, 0, CGFloat(M_PI*2), true)
        
        self.path = circlePath

        self.fillColor = self.color
        self.strokeColor = self.color
        self.position = location
        
        self.name = circleNodeName
        
        //Creation action
        let scaleUp = SKAction.scaleBy(2, duration: 0.35)
        let scaleDown = SKAction.scaleBy(0.50, duration: 0.35)
        let sequenceAction = SKAction.sequence([scaleUp,scaleDown])
        self.runAction(sequenceAction, completion: {creationCompletionBlock()})
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = circleBitMask
        self.physicsBody?.contactTestBitMask = flyingObjectBitMask
        
    }
    
    func moveToPoint(point: CGPoint) {
        self.position = point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
