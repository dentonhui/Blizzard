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