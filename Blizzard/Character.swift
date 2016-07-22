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
    
    var moveSpeed: CGFloat = 100
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
    
    // States for the hero
    enum HeroState {
        case Idle, Moving, Combat
    }
    var state = HeroState.Idle
    
    // Variable to hold the targeted enemy
    var targeted: Enemy?
    
    // Controls the fire rate
    let fireRate = 60
    var fireCounter = 0

    // Sets up the character
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
    
    // A function to move the hero character at a constant speed
    func move (location: CGPoint) {
        
        // Checks if the character has a move action and if so, removes it
        if self.hasActions() {
            self.removeActionForKey("move")
        }
        
        // Calculates duration so that the character moves at a constant speed
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
        
        // Ensures that character won't change to move state if it is in combat
        if self.state != .Combat {self.state = .Moving}
    }
    
    // Function to shoot a projectile
    func shoot() {
        
        // Creates the projectile, which is a child of the scene, like the character
        let projectile = Projectile(imageNamed: "projectile")
        projectile.position = self.position
        self.parent!.addChild(projectile)
        
        // Uses the projectile class' function to shoot at the targeted enemy
        projectile.shootProjectile(targeted!)
    }
}
