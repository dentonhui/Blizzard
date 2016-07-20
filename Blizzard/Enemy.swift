//
//  Enemy.swift
//  Blizzard
//
//  Created by Denton Hui on 7/19/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "man")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        //size = CGSize(width: 200, height: 160)
        //self.size = size
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.mass = 0.01
        physicsBody?.categoryBitMask = 0
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 0
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}