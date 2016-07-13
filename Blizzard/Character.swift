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
    
    var moveSpeed: CGFloat = 100
    
//    init(filename: String) {
//        let texture = SKTexture(imageNamed: filename)
//        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    func move (location: CGPoint) {
    // A function to move the hero character at a constant speed
        
        self.removeAllActions()
        let distancex = abs(self.position.x - location.x)
        let distancey = abs(self.position.y - location.y)
        let distance = sqrt(distancex * distancex + distancey * distancey)
        
        let duration = NSTimeInterval(distance / self.moveSpeed)
        let move = SKAction.moveTo(location, duration: duration)
        
        self.runAction(move)
    }
}
