//
//  GameScene.swift
//  Blizzard
//
//  Created by Denton Hui on 7/11/16.
//  Copyright (c) 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var hero = Character()
    let cam = SKCameraNode()
    
    // Keeps track of distance moved since last map update check
    var distanceMoved = CGPointMake(0, 0)
    
    // Variable to hold the map that the character is currently on
    var currentMap: Map!
    
    // Array to hold the maps made
    var mapGrid = [[Map]]()
    
    // Map coordinate display
    var myLabel: SKLabelNode!
    
    // Target indicator
    var target: SKSpriteNode!
    
    // Healthbar
    let healthBorder = SKSpriteNode(imageNamed: "healthBorder")
    var healthBar = SKSpriteNode(imageNamed: "healthBar")
    
    // Bounce limiter for contact
    let bounceLimiter: CGFloat = 20
    
    // Max number of maps + 1 on one side. Number of total maps will be (max + 1)^2
    let max = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Set up physics world contact delegate
        physicsWorld.contactDelegate = self
        
        // Set up character and camera
        hero.position = CGPoint(x: 325*3, y: 325*3)
        hero.zPosition = 1
        self.addChild(hero)
        self.camera = cam
        self.addChild(self.camera!)
        camera?.position = hero.position
        
        // Set up target indicator
        target = SKSpriteNode(imageNamed: "targetSmall")
        target.name = "target"
        target.zPosition = 20
        
        // Generates  2d array of maps
        for x in 0...max {
            
            // Temporary array to hold row of maps that will be added to the 2d map array
            var mapRow : [Map] = []
            
            for y in 0...max {
                
                let map = Map()
                map.inScene = false
                map.zPosition = -1
                
                map.position.x = CGFloat(325 * 3 + 650 * 3 * y)
                map.position.y = CGFloat(325 * 3 + 650 * 3 * x)
                
                map.number.x = x
                map.number.y = y
                
                mapRow.append(map)
                
                if y == max {
                    mapGrid.append(mapRow)
                }
            }
        }
        
        // Updates which map the character is currently on
        currentMap = mapGrid[Int(hero.position.y / (650 * 3 + 1))][Int(hero.position.x / (650 * 3 + 1))]
        
        // Sets up inital map tile
        currentMap.inScene = true
        self.addChild(currentMap)
        
        // Sets up map indicator
        myLabel = SKLabelNode(fontNamed: "Courier")
        myLabel.text = "\(currentMap.number.x), \(currentMap.number.y)"
        myLabel.fontSize = 25
        myLabel.zPosition = 10
        //hero.addChild(myLabel)
        
        // Sets up health bar
        healthBar.anchorPoint = CGPointMake(0, 0.5)
        healthBar.position = CGPointMake(-30, 0)
        healthBorder.zPosition = 2
        healthBar.zPosition = 3
        //camera?.addChild(healthBorder)
        //camera?.addChild(healthBar)
    }
    
    // Checks if 8 maps around current map are added. If not, adds them. Also removes maps that are too far away.
    func checkMap() {
        
        for x in currentMap.number.x-2...currentMap.number.x+2 {
            for y in currentMap.number.y-2...currentMap.number.y+2 {
                
                // Handles out of bounds for the array
                if x < 0 || x > max || y < 0 || y > max {continue}
                
                // Removes map tiles not within the 8 tiles surrounding current map
                if (abs(x-currentMap.number.x) == 2 || abs(y-currentMap.number.y) == 2) && mapGrid[x][y].inScene {
                    mapGrid[x][y].removeFromParent()
                    mapGrid[x][y].inScene = false
                    print("removed \(x), \(y)")
                }
                    
                    // Adds maps to the 8 tiles surrounding current map
                else if mapGrid[x][y].inScene {continue}
                else if abs(x-currentMap.number.x) < 2 && abs(y-currentMap.number.y) < 2 {
                    addChild(mapGrid[x][y])
                    mapGrid[x][y].inScene = true
                    print("added \(x), \(y)")
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
                
            // Adds target and switches to combat
            if touchedNode.name == "enemy" {
                let touchedEnemy = nodeAtPoint(location) as! Enemy
                target.removeFromParent()
                touchedEnemy.addChild(target)
                hero.targeted = touchedEnemy
                if hero.state == .Moving {
                    hero.state = .CombatMove}
                else if hero.state == .Idle {
                    hero.state = .CombatIdle}
            }
                
            // Removes a target and switches to idle or moving
            else if touchedNode.name == "target" {
                target.removeFromParent()
                hero.targeted = nil
                if hero.state == .CombatMove {
                    hero.state = .Moving
                }
                else if hero.state == .CombatIdle {
                    hero.state = .Idle
                }
            }
              
            // Moves character
            else {
                
                hero.move(location)
                
                // Updates distance moved by character since last map update
                distanceMoved.x += abs(hero.position.x - location.x)
                distanceMoved.y += abs(hero.position.y - location.y)
                
                // Checks if there are maps to add or remove everytime the character moves at least 650 pixels
                if distanceMoved.x > 650 || distanceMoved.y > 650 {
                    distanceMoved = CGPointMake(0, 0)
                    checkMap()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // Updates which map the character is currently on
        currentMap = mapGrid[Int(hero.position.y / (650 * 3 + 1))][Int(hero.position.x / (650 * 3 + 1))]
        
        // Updates label for which map the character is currently on
        myLabel.text = "\(currentMap.number.x), \(currentMap.number.y)"
        
        // Check for game over
        if hero.damage >= hero.health {
            gameOver()
        }
        
        // If the character either: has no actions and is not in combat, or is in combat and has no target, then switch to idle
        if (!hero.hasActions() && !hero.inCombat()) ||
            (hero.inCombat() && hero.targeted == nil) {
            hero.state = .Idle
        }
        // If the character is in combat, increment firecounter and shoot
        else if hero.inCombat() && hero.targeted != nil {
            hero.fireCounter += 1
            
            if hero.fireCounter % hero.fireRate == 0 {hero.shoot()}
        }
        
        //print(hero.state)
    }
    
    override func didSimulatePhysics() {
        
        // Moves camera to character
        camera?.position = hero.position
        
        // Clamps camera
        camera?.position.x.clamp(self.frame.size.width/2, 650*3*CGFloat(max+1) - self.frame.size.width/2)
        camera?.position.y.clamp(self.frame.size.height/2, 650*3*CGFloat(max+1) - self.frame.size.height/2)
        
        // Stops character when it finishes moving
        if let moveLocation = hero.moveLocation {
            if (moveLocation.x <= hero.position.x + 5 && moveLocation.x >= hero.position.x - 5) && (moveLocation.y <= hero.position.y + 5 && moveLocation.y >= hero.position.y - 5) {
                
                if hero.inCombat() {
                    hero.state = .CombatIdle
                }
                else {
                    hero.state = .Idle
                }
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // Creates variables for the two objects that contact
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        // Returns if the any of the nodes are nil to prevent crashing
        if contactA.node == nil || contactB.node == nil {return}
        
        // Creates variables for the unwrapped nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        // Tests different collisions
        testCollision(nodeA, nodeB: nodeB)
        testCollision(nodeB, nodeB: nodeA)
    }
    
    func testCollision (nodeA: SKNode, nodeB: SKNode) {
        
        if let man = nodeA as? Character {
            // Scenery contact
            if let scenery = nodeB as? Scenery {
                characterSceneryContact(man, scenery: scenery)
            }
            // Enemy contact
            else if let enemy = nodeB as? Enemy {
                characterEnemyContact(man, enemy: enemy)
            }
            // Enemy detection contact
            else if nodeB.name == "detect" {
                let enemy = nodeB.parent as! Enemy
                enemy.aggro(man)
            }
        }
        
        // Projectile enemy contact
        if let projectile = nodeA as? Projectile {
            if let enemy = nodeB as? Enemy {
                projectileContact(projectile, enemy: enemy)
            }
        }
    }
    
    // Function for character contact with scenery
    func characterSceneryContact(man: Character, scenery: Scenery) {
        
        if man.inCombat() {
            man.state = .CombatIdle
        }
        else {
            man.state = .Idle
        }
    }
    
    // Function for character contact with enemy
    func characterEnemyContact(man: Character, enemy: Enemy) {
        
        let enemyPosition = currentMap.convertPoint(enemy.position, toNode: self)
        let x = (man.position.x - enemyPosition.x) / bounceLimiter
        let y = (man.position.y - enemyPosition.y) / bounceLimiter
        let vector = CGVectorMake(x, y)
        
        // Aggros player character
        enemy.aggro(man)
        enemy.removeAllActions()
        // Pushes enemy back a bit to prevent clipping
        enemy.runAction(SKAction.moveByX(vector.dx * -1.5, y: vector.dy * -1.5, duration: 0))
        enemy.state = .CombatIdle
        
        // Damages character and brings it out of combat (stops shooting and removes target)
        target.removeFromParent()
        man.targeted = nil
        man.damage += enemy.damageDealt
        man.damaged()
        man.state = .Idle
        man.physicsBody?.applyImpulse(vector)
        
        let restore = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.1)
        enemy.runAction(restore)
    }
    
    // Function for projectile contact
    func projectileContact(projectile: Projectile, enemy: Enemy) {
        
        enemy.targeted = hero
        if !enemy.inCombat() {enemy.state = .Combat}
        enemy.damage += 1
        enemy.damaged()
        projectile.removeFromParent()
        if hero.targeted != nil && enemy.damage == enemy.health && enemy == hero.targeted! {hero.targeted = nil}
    }
    
    // Shows game over screen
    func gameOver() {
        
        /* Grab reference to our SpriteKit view */
        let skView = self.view as SKView!
        
        /* Load Game scene */
        let scene = GameOver(fileNamed:"GameOver") as GameOver!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFit
        
        /* Show debug */
        skView.showsPhysics = false
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        /* Start game scene */
        skView.presentScene(scene)
    }
}