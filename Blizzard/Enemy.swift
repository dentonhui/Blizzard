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
    
    // A damage counter to keep track of the enemy's health
    var damage = 0 {
        didSet {
            if damage == 3 {
                self.removeFromParent()
            }
        }
    }
    
    // Sets up the enemy
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        //size = CGSize(width: 200, height: 160)
        //self.size = size
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.mass = 0.01
        physicsBody?.categoryBitMask = 2
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 2
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        
        self.name = "enemy"

        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func damaged() {
        
        //Turns the enemy red, then back to its original color after it is hit
        let red = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let restore = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1)
        self.runAction(SKAction.sequence([red, restore]))
    }
}