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
    
    // Max number of maps on one side. Number of total maps will be (max + 1)^2
    let max = 2
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Set up physics world contact delegate
        physicsWorld.contactDelegate = self
        
        // Set up character and camera
        hero.position = CGPoint(x: 325*3, y: 325*3)
        hero.zPosition = 1
        self.addChild(hero)
        self.camera = cam
        hero.addChild(self.camera!)
        
        // Generates  2d array of maps
        for x in 0...max {
            
            // Temporary array to hold row of maps that will be added to the 2d map array
            var mapRow : [Map] = []
            
            for y in 0...max {
                
                let map = Map()
                map.inScene = false
                map.zPosition = -1
                
                if y == 0 {
                    map.position.x = hero.position.x
                    map.position.y = hero.position.y + CGFloat(650 * 3 * x)
                }
                else {
                    map.position.x = hero.position.x + CGFloat(650 * 3 * y)
                    map.position.y = hero.position.y + CGFloat(650 * 3 * x)
                }
                
                map.number.x = x
                map.number.y = y
                
                mapRow.append(map)
                
                if y == max {
                    mapGrid.append(mapRow)
                }
            }
        }
        
        // Sets up inital map tile
        mapGrid[0][0].inScene = true
        self.addChild(mapGrid[0][0])
        currentMap = mapGrid[0][0]
        
        // Sets up map indicator
        myLabel = SKLabelNode(fontNamed: "Courier")
        myLabel.text = "\(currentMap.number.x), \(currentMap.number.y)"
        myLabel.fontSize = 45
        hero.addChild(myLabel)
        myLabel.zPosition = 10
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            // Moves character
            let location = touch.locationInNode(self)
            hero.move(location)
            
            // Updates distance moved by character since last map update
            distanceMoved.x += abs(hero.position.x - location.x)
            distanceMoved.y += abs(hero.position.y - location.y)
            
            // Checks if there are maps to add or remove everytime the character moves at least 650 pixels
            if distanceMoved.x > 650 || distanceMoved.y > 650 {
                distanceMoved = CGPointMake(0, 0)
                checkMap()
            }
            
            // Makes sure camera doesn't flip
            if hero.direction == .Right {
                self.camera?.xScale = 1
            }
            else {
                self.camera?.xScale = -1
            }
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // Updates which map the character is currently on
        currentMap = mapGrid[Int(hero.position.y / (650 * 3 + 1))][Int(hero.position.x / (650 * 3 + 1))]
        
        // Updates label for which map the character is currently on
        myLabel.text = "\(currentMap.number.x), \(currentMap.number.y)"
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Creates variables for the two objects that contact
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        //Returns if the any of the nodes are nil to prevent crashing
        if contactA.node == nil || contactB.node == nil {return}
        
        //Creates variables for the unwrapped nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        let x: CGFloat = 4
        let y: CGFloat = 4
        let size: CGFloat = 40
        
        
        // Stops character from moving if it hits a rock
        if nodeA.name == "man" && nodeB.name == "scenery" {
            nodeA.removeAllActions()
            
            let sceneryPosition = currentMap.convertPoint(nodeB.position, toNode: self)
            
            if nodeA.position.x - sceneryPosition.x >= size {
                nodeA.runAction(SKAction.moveToX(nodeA.position.x+x, duration: 0))
            }
            else if nodeA.position.x - sceneryPosition.x <= -size {
                nodeA.runAction(SKAction.moveToX(nodeA.position.x-x, duration: 0))
            }
            else if nodeA.position.y - sceneryPosition.y >= size {
                nodeA.runAction(SKAction.moveToY(nodeA.position.y+y, duration: 0))
            }
            else {
                nodeA.runAction(SKAction.moveToY(nodeA.position.y-y, duration: 0))
            }
        }
        else if nodeB.name == "man" && nodeA.name == "scenery" {
            nodeB.removeAllActions()
            
            let sceneryPosition = currentMap.convertPoint(nodeA.position, toNode: self)
            
            if nodeB.position.x - sceneryPosition.x >= size {
                nodeB.runAction(SKAction.moveToX(nodeB.position.x+x, duration: 0))
            }
            else if nodeB.position.x - sceneryPosition.x <= -size {
                nodeB.runAction(SKAction.moveToX(nodeB.position.x-x, duration: 0))
            }
            else if nodeB.position.y - sceneryPosition.y >= size {
                nodeB.runAction(SKAction.moveToY(nodeB.position.y+y, duration: 0))
            }
            else {
                nodeB.runAction(SKAction.moveToY(nodeB.position.y-y, duration: 0))
            }
        }
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
    
}
