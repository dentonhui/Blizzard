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
        
        size = CGSize(width: texture.size().width * 2, height: texture.size().height*2)
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = false
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "scenery"
        
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}