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
    var mapGrid: [Map] = []
    
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
        
        // Generates array of maps
        for i in 0...9 {
            let map = Map()
            map.inScene = false
            map.zPosition = -1
            
            if i == 0 {
                map.inScene = true
                map.position = hero.position
                self.addChild(map)
                currentMap = map
            }
            else {
                map.position.y = mapGrid[i-1].position.y
                map.position.x = mapGrid[i-1].position.x + (650 * 3)
            }
            
            map.number = i
            mapGrid.append(map)
        }
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
        
        // Checks if the character is far enough right to add map to right
        if currentMap.number >= 0 && currentMap.number < mapGrid.count-1 && mapGrid[currentMap.number + 1].inScene == false && hero.position.x  > 425 * 3 * CGFloat(currentMap.number + 1)  {
            
            addChild(mapGrid[currentMap.number+1])
            mapGrid[currentMap.number+1].inScene = true
            print("added \(currentMap.number + 1)")
        }
        
        // Removes the map that is 2 maps to the left
        if currentMap.number > 1 && mapGrid[currentMap.number-2].inScene == true {
            
            mapGrid[currentMap.number-2].removeFromParent()
            mapGrid[currentMap.number-2].inScene = false
            print("removed \(currentMap.number - 2)")
        }
        
        // Checks if the character is far enough left to add map to left
        if currentMap.number > 0 && currentMap.number <= 9 && mapGrid[currentMap.number - 1].inScene == false {
            
            addChild(mapGrid[currentMap.number-1])
            mapGrid[currentMap.number-1].inScene = true
            print("added \(currentMap.number - 1)")
        }
        
        // Removes the map that is 2 maps to the right
        if currentMap.number < 8 && mapGrid[currentMap.number+2].inScene == true {
            
            mapGrid[currentMap.number+2].removeFromParent()
            mapGrid[currentMap.number+2].inScene = false
            print("removed \(currentMap.number + 2)")
        }
        
        
        // Updates which map the character is currently on
        currentMap = mapGrid[Int(hero.position.x / (650 * 3 + 1))]
        
    }
    
    // Function to add map
    func addMap(side: String) {
        
        
    }
    
    // Removes a map if it is more than 1 map away from the current one
    func removeMap(side: String) {
        if currentMap.number > 1 {
            for i in currentMap.number-2...mapGrid.count {
                if abs(i - currentMap.number) > 1 && mapGrid[i].inScene == true {
                    mapGrid[i].removeFromParent()
                    mapGrid[i].inScene = false
                }
            }
        }
    }
    
}
