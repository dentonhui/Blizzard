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
    
    // Variable for the speed at which the projectile moves
    let fireSpeed: CGFloat = 200
    
    // Variable to hold taget position
    var targetP = CGPointMake(-1, -1)
        
    // Ses up projectile
    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 4
        self.zPosition = 10
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "projectile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Function to shoot the projectile at target's location
    func shootProjectile(target: Enemy) {
        
        // Converts target location to be in the context of the projectile's parent
        let targetPosition = target.parent?.convertPoint(target.position, toNode: self.parent!)
        if targetPosition == nil {return}
        
        // Rotates projectile to face target location
        let dy = targetPosition!.y - self.position.y
        let dx = targetPosition!.x - self.position.x
        let angle = atan2(dy, dx)
        self.zRotation = angle
        
        // Moves projectile and removes it once it reaches its location
        let y = abs(dy)
        let x = abs(dx)
        let d = sqrt(y*y + x*x)
        let duration = NSTimeInterval(d / self.fireSpeed)
        let fire = SKAction.moveTo(targetPosition!, duration: duration)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fire, remove])
        self.runAction(sequence)
    }
}