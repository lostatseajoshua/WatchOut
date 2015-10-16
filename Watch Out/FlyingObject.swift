//
//  FlyingObject.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 4/25/15.
//  Copyright (c) 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import SpriteKit

class FlyingObject: SKShapeNode {
    
    private var color: UIColor {
        get {
            return UIColor.whiteColor()
        }
    }
    
    override init() {
        super.init()
        
        let circlePath = CGPathCreateMutable()
        CGPathAddArc(circlePath, nil, 0, 0, 10.0, 0, CGFloat(M_PI*2), true)
        
        self.path = circlePath
        
        self.fillColor = self.color
        self.strokeColor = self.color
        
        self.name = "FlyingObject"
        
        //Creation action
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = flyingObjectBitMask
        self.physicsBody?.contactTestBitMask = circleBitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(bounds: CGRect) {
        self.init()
        
        let points = createRandomPointsToMoveOnBounds(bounds)
        self.position = points.0
        let action = SKAction.moveTo(points.1, duration: 3)
        self.runAction(action, completion: {
            self.removeFromParent()
        })
    }
    
//    func followRandomPathInBounds(bounds: CGRect) {
//        let followPath = SKAction.followPath(createRandomLinePathInBounds(bounds), duration: 4)
//        let moveToPoint = SKAction.moveTo(createRandomPointWithinBounds(bounds), duration: 2)
//        self.runAction(moveToPoint)
//        self.removeFromParent()
//    }
    
    func createRandomLinePathInBounds(bounds: CGRect) -> CGPath {
        let randomPath = UIBezierPath()
        randomPath.moveToPoint(createRandomPointWithinBounds(bounds))
        randomPath.addLineToPoint(createRandomPointWithinBounds(bounds))
        return randomPath.CGPath
    }
    
    func createRandomPathInBounds(bounds: CGRect) -> CGPath {
        let randomPath = UIBezierPath()
        randomPath.moveToPoint(createRandomPointWithinBounds(bounds))
        randomPath.addCurveToPoint(createRandomPointWithinBounds(bounds), controlPoint1: createRandomPointWithinBounds(bounds), controlPoint2: createRandomPointWithinBounds(bounds))
        return randomPath.CGPath
    }
    
    func createRandomPointWithinBounds(bounds: CGRect) -> CGPoint {
        let randomX = arc4random_uniform(UInt32(bounds.width))
        let randomY = arc4random_uniform(UInt32(bounds.height))
        
        let randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))
        return randomPoint
    }
    
    func createRandomPointsToMoveOnBounds(bounds: CGRect) -> (CGPoint,CGPoint) {
        if let pathToMoveOn = PathToMoveAlong(rawValue: Int(arc4random_uniform(4))) {
            switch pathToMoveOn {
            case .LeftToRight:
                return (pointAlongLeftBound(bounds),pointAlongRightBound(bounds))
            case .RightToLeft:
                return (pointAlongRightBound(bounds),pointAlongLeftBound(bounds))
            case .TopToBottom:
                return (pointAlongTopBound(bounds),pointAlongBottomBound(bounds))
            case .BottomToTop:
                return (pointAlongBottomBound(bounds),pointAlongTopBound(bounds))
            }
        }
        return (CGPointMake(0, 0), CGPointMake(0,0))
    }
    
    
    func pointAlongLeftBound(bounds: CGRect) -> CGPoint {
        return CGPointMake(0 - self.frame.width, CGFloat(arc4random_uniform(UInt32(bounds.height))))
    }
    func pointAlongBottomBound(bounds: CGRect) -> CGPoint {
        return CGPointMake(CGFloat(arc4random_uniform(UInt32(bounds.width))), 0 - self.frame.height)
    }
    func pointAlongRightBound(bounds: CGRect) -> CGPoint {
        return CGPointMake(CGRectGetMaxX(bounds) + self.frame.width, CGFloat(arc4random_uniform(UInt32(bounds.height))))
    }
    func pointAlongTopBound(bounds: CGRect) -> CGPoint {
        return CGPointMake(CGFloat(arc4random_uniform(UInt32(bounds.width))), CGRectGetMaxY(bounds) + self.frame.height)
    }
}

enum PathToMoveAlong: Int {
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
}