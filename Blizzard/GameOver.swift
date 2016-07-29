//
//  GameOver.swift
//  Blizzard
//
//  Created by Denton Hui on 7/29/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    
    /* UI Connections */
    var buttonRestart: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        /* Set UI connections */
        buttonRestart = self.childNodeWithName("buttonRestart") as! MSButtonNode
        
        /* Setup play button selection handler */
        buttonRestart.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"MainScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
    }

}
