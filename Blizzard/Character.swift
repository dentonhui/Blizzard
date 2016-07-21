//
//  Character.swift
//  Blizzard
//
//  Created by Denton Hui on 7/11/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    
    var moveSpeed: CGFloat = 1000
    enum Orientation {
        case Right, Left
    }
    var direction = Orientation.Right {
        
        // Switches character sprite's visual orientation whenever the orientaiton in code changes
        didSet {
            if direction == .Right {
                self.xScale = 1
            }
            else {
                self.xScale = -1
            }
        }
    }
    
    enum HeroState {
        case Idle, Moving, Combat
    }
    
    var state = HeroState.Idle
    
    var targeted: Enemy?
    
    let fireRate = 60
    var fireCounter = 0

    init() {
        let texture = SKTexture(imageNamed: "man")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "man"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func move (location: CGPoint) {
    // A function to move the hero character at a constant speed
        
        if self.hasActions() {
            self.removeActionForKey("move")
        }
        
        let distancex = abs(self.position.x - location.x)
        let distancey = abs(self.position.y - location.y)
        let distance = sqrt(distancex * distancex + distancey * distancey)
        
        let duration = NSTimeInterval(distance / self.moveSpeed)
        let move = SKAction.moveTo(location, duration: duration)
        
        // A switch case to change character orientation if it heads in a direction different from their current orientation
        switch  direction {
        case .Right:
            if location.x < self.position.x {
                direction = .Left
            }
            
        case .Left:
            if location.x > self.position.x {
                direction = .Right
            }
            
        }
        
        self.runAction(move, withKey: "move")
        if self.state != .Combat {self.state = .Moving}
    }
    
    func shoot() {
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        
        projectile.physicsBody = SKPhysicsBody(rectangleOfSize: projectile.size)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.allowsRotation = false
        projectile.physicsBody?.categoryBitMask = 2
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.contactTestBitMask = 2
        projectile.zPosition = 10
        projectile.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        projectile.name = "projectile"
        
        targeted!.addChild(projectile)
        
        print("added projectile")
    }

}
