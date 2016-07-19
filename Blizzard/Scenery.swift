//
//  Scenery.swift
//  Blizzard
//
//  Created by Denton Hui on 7/19/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Scenery: SKSpriteNode {
    
    init(filename: String) {
        let texture = SKTexture(imageNamed: filename)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = false
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 15
        physicsBody?.contactTestBitMask = 0
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}