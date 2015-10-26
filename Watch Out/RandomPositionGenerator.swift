//
//  RandomPositionGenerator.swift
//  Watch Out
//
//  Created by Joshua Alvarado on 10/22/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit

protocol RandomPositionGenerator {
    func createRandomPointWithinBounds(bounds: CGRect) -> CGPoint
    func createRandomLinePathInBounds(bounds: CGRect) -> CGPath
    func createRandomPathInBounds(bounds: CGRect) -> CGPath
}

extension RandomPositionGenerator {
    

    func createRandomPointWithinBounds(bounds: CGRect) -> CGPoint {
        let randomX = arc4random_uniform(UInt32(bounds.width))
        let randomY = arc4random_uniform(UInt32(bounds.height))
        
        let randomPoint = CGPointMake(CGFloat(randomX), CGFloat(randomY))
        return randomPoint
    }
    
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
    
}

