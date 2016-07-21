//
//  Projectile.swift
//  Blizzard
//
//  Created by Denton Hui on 7/21/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 2
        self.zPosition = 10
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "projectile"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
