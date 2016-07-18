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
        
        // Generates  2darray of maps
        for x in 0...9 {
            
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
        if currentMap.number.y >= 0 && currentMap.number.y < 9 && mapGrid[0][currentMap.number.y + 1].inScene == false && hero.position.x  > 425 * 3 * CGFloat(currentMap.number.y + 1)  {
            
            addChild(mapGrid[0][currentMap.number.y+1])
            mapGrid[0][currentMap.number.y+1].inScene = true
            print("added \(currentMap.number.x), \(currentMap.number.y + 1)")
        }
        
        // Removes the map that is 2 maps to the left
        if currentMap.number.y > 1 && mapGrid[0][currentMap.number.y-2].inScene == true {
            
            mapGrid[0][currentMap.number.y-2].removeFromParent()
            mapGrid[0][currentMap.number.y-2].inScene = false
            print("removed \(currentMap.number.x), \(currentMap.number.y - 2)")
        }
        
        // Checks if the character is far enough left to add map to left
        if currentMap.number.y > 0 && currentMap.number.x <= 9 && mapGrid[0][currentMap.number.y - 1].inScene == false {
            
            addChild(mapGrid[0][currentMap.number.y-1])
            mapGrid[0][currentMap.number.y-1].inScene = true
            print("added \(currentMap.number.x), \(currentMap.number.y - 1)")
        }
        
        // Removes the map that is 2 maps to the right
        if currentMap.number.y < 8 && mapGrid[0][currentMap.number.y+2].inScene == true {
            
            mapGrid[0][currentMap.number.y+2].removeFromParent()
            mapGrid[0][currentMap.number.y+2].inScene = false
            print("removed \(currentMap.number.x), \(currentMap.number.y + 2)")
        }
        
        
        // Updates which map the character is currently on
        currentMap = mapGrid[0][Int(hero.position.x / (650 * 3 + 1))]
        
    }
    
    // Function to add map
    func addMap(side: String) {
        
        
    }
    
    // Removes a map if it is more than 1 map away from the current one
    func removeMap(side: String) {
        
    }
    
}
