//
//  GameScene.swift
//  Blizzard
//
//  Created by Denton Hui on 7/11/16.
//  Copyright (c) 2016 Denton Hui. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hero: Character!
    let cam = SKCameraNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
        hero = self.childNodeWithName("hero") as! Character
        self.camera = cam
        
        let map = Map()
        map.zPosition = -1
        map.position = hero.position
        self.addChild(map)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            hero.move(location)
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        cam.position = hero.position
    }
}
