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
    var moveSpeed: CGFloat = 50
    
    // Span position
    var spawnPosition: CGPoint!
    
    // Variable to hold the targeted character
    var targeted: Character?
    
    // Variable to hold walking frames
    var foxWalkingFrames: [SKTexture]!
    
    // Variable for enemy health
    let health = 10
    
    // Variable for enemy damage dealt
    let damageDealt = 5
    
    // Detection node
    var detectNode = SKNode()
    
    // A damage counter to keep track of the enemy's health
    var damage = 0 {
        didSet {
            if damage == health {
                self.removeAllChildren()
                self.removeFromParent()
            }
        }
    }
    
    // Enemy states
    enum EnemyState {
        case Idle, IdleMove, Combat, CombatIdle
    }
    var state = EnemyState.Idle {
        didSet {
            switch state {
            // Wait for 2 seconds, then go to idle move
            case .Idle:
                let delay = SKAction.waitForDuration(2)
                self.runAction(delay, completion: { () -> Void in
                    self.state = .IdleMove
                } )
            // Moves enemy
            case .IdleMove:
                self.idleMove()
            // Wait for 2 seconds, then go to combat
            case .CombatIdle:
                let delay = SKAction.waitForDuration(2)
                self.runAction(delay, completion: { () -> Void in
                    self.state = .Combat
                } )
            // Attacks character
            case .Combat:
                self.removeAllActions()
                self.CombatMove()
            }
        }
    }
    
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
    init(imageNamed: String, sPosition: CGPoint) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        spawnPosition = sPosition
        self.position = spawnPosition
        self.zPosition = 10
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = false
        physicsBody?.categoryBitMask = 4
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
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
        
        // Adds detector node
        self.addDetect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Adds an epty node to the front of the enemy which triggers combat if the hero collides with it
    func addDetect() {
        
        detectNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.size.width*2, height: self.size.height*2))
        detectNode.physicsBody?.affectedByGravity = false
        detectNode.physicsBody?.dynamic = true
        detectNode.physicsBody?.categoryBitMask = 0
        detectNode.physicsBody?.collisionBitMask = 0
        detectNode.physicsBody?.contactTestBitMask = 1
        detectNode.position = CGPointMake(-self.size.width, 0)
        detectNode.zPosition = 10
        detectNode.name = "detect"
        self.addChild(detectNode)
    }
    
    // Function to flash sprite red it when damaged
    func damaged() {
        
        //Turns the enemy red, then back to its original color after it is hit
        let red = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1)
        let restore = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1)
        self.runAction(SKAction.sequence([red, restore]))
    }
    
    // Function to return a boolean for whether or not the hero is in combat
    func inCombat()-> Bool {
        if self.state == .Combat || self.state == .CombatIdle {return true}
        else {return false}
    }
    
    // Function to enter combat
    func aggro(man: Character) {
        if self.inCombat() == false {
            self.removeActionForKey("move")
            self.removeActionForKey("walkingFox")
            self.targeted = man
            self.state = .CombatIdle
        }
    }
    
    // Function to animate character
    func walkingFox() {
        var frameSpeed: NSTimeInterval = 0.2
        
        if self.state == .Combat {frameSpeed = 0.05}
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(foxWalkingFrames, timePerFrame: frameSpeed, resize: false, restore: false)), withKey: "walkingFox")
    }
    
    func idleMove() {
        
        // Random location
        var randX = CGFloat(arc4random_uniform(100)) - 50
        var randY = CGFloat(arc4random_uniform(100)) - 50
        var x = self.position.x + randX
        if abs(x) > spawnPosition.x + 50 {
            randX *= -1
            x = self.position.x + randX
        }
        var y = self.position.y + randY
        if abs(y) > spawnPosition.y + 50 {
            randY *= -1
            y = self.position.y + randY
        }
        let location = CGPointMake(x, y)
        self.walkingFox()
        self.move(location, speed: moveSpeed)
    }
    
    func CombatMove() {
        
        // Converts target location to be in the context of the projectile's parent
        var targetPosition = targeted!.parent?.convertPoint(targeted!.position, toNode: self.parent!)
        targetPosition!.x += 5
        targetPosition!.y += 5
        
        self.walkingFox()
        self.move(targetPosition!, speed: self.moveSpeed*4)
    }
    
    // Function to move sprite
    func move(location: CGPoint, speed: CGFloat) {
        
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
        let duration = NSTimeInterval(distance / speed)
        let move = SKAction.moveTo(location, duration: duration)

        
        // Action after move to remove animation and switch state
        let doneMove = (SKAction.runBlock({
            self.removeActionForKey("walkingFox")
            self.removeActionForKey("move")
            
            // Resets texture to default
            self.texture = SKTexture(imageNamed: "fox")
            
            // Sets enemy to idle if in idle move
            if self.state == .IdleMove {self.state = .Idle}
            
            // Runs CombatMove again if in combat
            if self.state == .Combat {self.state = .CombatIdle}
            
            self.detectNode.position = CGPointMake(-self.size.width, 0)
            
        }))
        
        let moveWithDone = SKAction.sequence([move, doneMove])
        self.runAction(moveWithDone, withKey: "move")
    }
    
}