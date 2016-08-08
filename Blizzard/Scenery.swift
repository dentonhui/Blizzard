//
//  Scenery.swift
//  Blizzard
//
//  Created by Denton Hui on 7/19/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Scenery: SKSpriteNode {
    
    // Sets up scenery object by taking in a filename and make an object of that file's texture
    init(filename: String) {
        let texture = SKTexture(imageNamed: filename)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        size = CGSize(width: texture.size().width, height: texture.size().height)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.zPosition = 10
        
        if filename == "forest" {
            let size2 = CGSize(width: size.width/1.05, height: size.height/1.25)
            physicsBody = SKPhysicsBody(rectangleOfSize: size2)
            self.zPosition = 20
        }
        
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = false
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        self.name = "scenery"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}