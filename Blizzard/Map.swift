//
//  Map.swift
//  Blizzard
//
//  Created by Denton Hui on 7/14/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class Map: SKSpriteNode {
    
        // Variable to keep track which map is which
        var number = 0
    
        // Variable to keep track of whether or not a map is in the scene
        var inScene = false
    
        init() {
            let texture = SKTexture(imageNamed: "backgroundTile")
            super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
            self.size.height = 650*3
            self.size.width = 650*3
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
}