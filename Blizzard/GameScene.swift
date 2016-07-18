//
//  GameScene.swift
//  Blizzard
//
//  Created by Denton Hui on 7/11/16.
//  Copyright (c) 2016 Denton Hui. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero = Character()
    let cam = SKCameraNode()
    
    // Variable to hold the map that the character is currently on
    var currentMap: Map!
    
    // Array to hold the maps made
    var mapGrid = [[Map]]()
    
    var myLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //        myLabel.text = "Hello, World!"
        //        myLabel.fontSize = 45
        //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        //
        //        self.addChild(myLabel)
        hero.position = CGPoint(x: 325*3, y: 325*3)
        self.addChild(hero)
        self.camera = cam
        hero.addChild(self.camera!)
        
        // Generates  2d array of maps
        for x in 0...9 {
            
            // Temporary array to hold row of maps that will be added to the 2d map array
            var mapRow : [Map] = []
            
            for y in 0...9 {
                
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
                //print("added \(map.number.x), \(map.number.y), position: \(map.position.x), \(map.position.y)")
                if y == 9 {
                    mapGrid.append(mapRow)
                    //print("added \(map.number.x) row")
                }
            }
        }
        
        mapGrid[0][0].inScene = true
        self.addChild(mapGrid[0][0])
        currentMap = mapGrid[0][0]
        
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
        
        myLabel.text = "\(currentMap.number.x), \(currentMap.number.y)"
        
        checkMap()
        
    }
    
    // Checks if 8 maps around current map are added. If not, adds them. Also rmoves maps that are too far away.
    func checkMap() {

        for x in currentMap.number.x-2...currentMap.number.x+2 {
            for y in currentMap.number.y-2...currentMap.number.y+2 {
                if x < 0 || x > 9 || y < 0 || y > 9 {continue}

                if (abs(x-currentMap.number.x) == 2 || abs(y-currentMap.number.y) == 2) && mapGrid[x][y].inScene {
                    mapGrid[x][y].removeFromParent()
                    mapGrid[x][y].inScene = false
                    print("removed \(x), \(y)")
                }
                if mapGrid[x][y].inScene {continue}
                if abs(x-currentMap.number.x) < 2 && abs(y-currentMap.number.y) < 2 {
                    addChild(mapGrid[x][y])
                    mapGrid[x][y].inScene = true
                    print("added \(x), \(y)")
                }
                
            }
            
        }

    }
    
}
