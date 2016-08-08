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
    
    // Controls move speed
    var moveSpeed: CGFloat = 100
    
    // Move location
    var moveLocation: CGPoint!
    
    // Controls the fire rate
    let fireRate = 50
    var fireCounter = 0
    
    // Variable for character health
    let health = 50
    
    // A damage counter to keep track of the character's health
    var damage = 0
    
    // Switches character sprite's visual orientation whenever the orientaiton in code changes
    enum Orientation {
        case Right, Left
    }
    var direction = Orientation.Right {
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
        case Idle, Moving, CombatMove, CombatIdle
    }
    var state = HeroState.Idle {
        didSet {
            // Sets move location to nil and veloctiy to 0 if in idle
            if state == .Idle || state == .CombatIdle{
                self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                self.removeActionForKey("walkingMan")
                self.texture = SKTexture(imageNamed: "manWalkingAnimation_5")
                self.moveLocation = nil
            }
            // Runs the walking animation everytime the state changes to moving or combat move
            if state == .Moving || state == .CombatMove {
                self.walkingMan()
            }
        }
    }
    
    // Variable to hold the targeted enemy
    var targeted: Enemy?
    
    // Variable to hold walking frames
    var manWalkingFrames: [SKTexture]!

    // Sets up the character
    init() {
        let texture = SKTexture(imageNamed: "manWalkingAnimation_5")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: texture.size().width/3, height: texture.size().height/1.5))
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "man"
        
        // Initilizes walking frames
        var walkFrames = [SKTexture]()
        for i in 0...5 {
            let name = "manWalkingAnimation_\(i)"
            let walkFrame = SKTexture(imageNamed: name)
            walkFrames.append(walkFrame)
        }
        manWalkingFrames = walkFrames
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Function to return a boolean for whether or not the hero is in combat
    func inCombat()-> Bool {
        if self.state == .CombatMove || self.state == .CombatIdle {return true}
        else {return false}
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
    
    // Function to flash sprite red it when damaged
    func damaged() {
        
        //Turns the enemy red, then back to its original color after it is hit
        let red = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let restore = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1)
        self.runAction(SKAction.sequence([red, restore]))
    }
    
    // Function to animate character
    func walkingMan() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(manWalkingFrames, timePerFrame: 0.2, resize: false, restore: false)), withKey: "walkingMan")
    }
    
    // A function to move the hero character at a constant speed
    func move (location: CGPoint) {
        
        // Checks if the character has a move action and if so, removes it
        self.removeActionForKey("move")
        
        // Sets velocity to 0
        self.moveLocation = location
        
        // If character is in combat idle, then moving changes state to combat move
        if self.state == .CombatIdle {self.state = .CombatMove}
            // If character is idle, then moving changes state to moving
        else if self.state == .Idle {self.state = .Moving}
        
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
        
        // Calculates duration so that the character moves at a constant speed
        let distancex = abs(self.position.x - location.x)
        let distancey = abs(self.position.y - location.y)
        let distance = sqrt(distancex * distancex + distancey * distancey)
        let factor = distance / moveSpeed
        
        physicsBody?.velocity = CGVector(dx: (location.x-self.position.x)/factor, dy: (location.y-self.position.y)/factor)

    }
}
