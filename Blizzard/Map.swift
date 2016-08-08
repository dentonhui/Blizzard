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
    
    func addTo(scenery: Scenery, x: CGFloat, y: CGFloat) {
        scenery.position = CGPointMake(x, y)
        self.addChild(scenery)
    }
    
    // Instructions for each of the maps
    func populateMap() {
        switch number {
            
        case (x: 0, y: 0):
            
            for i in 0...10 {
                let position = CGPointMake(200 + 64*CGFloat(i), 200)
                let enemy = Enemy(imageNamed: "fox", sPosition: position)
                self.addChild(enemy)
                enemy.state = .IdleMove
            }
            
            var tree: Scenery
            
            tree = Scenery(filename: "forest")
            addTo(tree, x: -300, y: 0)
            
            tree = Scenery(filename: "forest")
            addTo(tree, x: -250, y: -50)
            
            tree = Scenery(filename: "forest")
            addTo(tree, x: 400, y: 0)
            
            tree = Scenery(filename: "forest")
            addTo(tree, x: 400, y: -180)
            
            tree = Scenery(filename: "forest")
            addTo(tree, x: 20, y: -180)

        case (x: 0, y: 1):
            break
            
        case (x: 0, y: 2):
            break
            
        default: break
            
        }
    }
}