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
    
    // Controls move speed
    var moveSpeed: CGFloat = 5
    
    // Variable to hold the targeted character
    var targeted: Character?
    
    // Variable to hold walking frames
    var foxWalkingFrames: [SKTexture]!
    
    // A damage counter to keep track of the enemy's health
    var damage = 0 {
        didSet {
            if damage == 3 {
                self.removeAllChildren()
                self.removeFromParent()
            }
        }
    }
    
    // Enemy states
    enum EnemyState {
        case Idle, IdleMove
    }
    var state = EnemyState.Idle
    
    // Switches enemy sprite's visual orientation whenever the orientaiton in code changes
    enum Orientation {
        case Right, Left
    }
    var direction = Orientation.Left {
        didSet {
            if direction == .Left {
                self.xScale = 1
            }
            else {
                self.xScale = -1
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
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 2
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        
        self.name = "enemy"

        self.zPosition = 1
        
        // Initilizes walking frames
        var walkFrames = [SKTexture]()
        for i in 0...5 {
            let name = "foxWalkingAnimation_\(i)"
            let walkFrame = SKTexture(imageNamed: name)
            walkFrames.append(walkFrame)
        }
        foxWalkingFrames = walkFrames
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Function to flash sprite red it when damaged
    func damaged() {
        
        //Turns the enemy red, then back to its original color after it is hit
        let red = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let restore = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1)
        self.runAction(SKAction.sequence([red, restore]))
    }
    
    // Function to animate character
    func walkingFox() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(foxWalkingFrames, timePerFrame: 0.2, resize: false, restore: false)), withKey: "walkingFox")
    }
    
    func idleMove() {
        
        // Random location
        let x = self.position.x + CGFloat(arc4random_uniform(1000)) - 500
        let y = self.position.y + CGFloat(arc4random_uniform(1000)) - 500
        let location = CGPointMake(x, y)
        self.move(location)
    }
    
    // Function to move sprite
    func move(location: CGPoint) {
        
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
        let duration = NSTimeInterval(distance / self.moveSpeed)
        let move = SKAction.moveTo(location, duration: duration)

        
        // Action after move to remove animation and switch state
        let doneMove = (SKAction.runBlock({
            self.removeActionForKey("walkingFox")
            self.removeActionForKey("move")
            
            // Resets texture to default
            self.texture = SKTexture(imageNamed: "fox")
        }))
        
        let moveWithDone = SKAction.sequence([move, doneMove])
        self.runAction(moveWithDone, withKey: "move")
    }
}