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
    var number = (x: -1, y: -1) {
        didSet {
            populateMap()
        }
    }
    
    // Variable to keep track of whether or not a map is in the scene
    var inScene = false
    
    // Sets up the map tiles
    init() {
        let texture = SKTexture(imageNamed: "backgroundTile")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size.height = 650*3
        self.size.width = 650*3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Instructions for each of the maps
    func populateMap() {
        switch number {
            
        case (x: 0, y: 0):
//            var enemy = Enemy()
//            enemy.zPosition = 1
//            enemy.position = CGPointMake(200, 0)
//            self.addChild(enemy)
            
            for i in 0...10 {
                let enemy = Enemy(imageNamed: "fox")
                enemy.zPosition = 10
                enemy.position = CGPointMake(200 + enemy.size.width*CGFloat(i), 0)
                self.addChild(enemy)
                enemy.state = .IdleMove
            }
            
            let rock = Scenery(filename: "rock")
            rock.position = CGPointMake(-200,200)
            self.addChild(rock)
            
            let rock2 = Scenery(filename: "rock")
            rock2.position = CGPointMake(-270,190)
            self.addChild(rock2)

        case (x: 0, y: 1):
            break
            
        case (x: 0, y: 2):
            break
            
        default: break
            
        }
    }
}