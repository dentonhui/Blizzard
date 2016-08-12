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
    
    // Waves survived
    var waveLabel: SKLabelNode!
    var wavesSurvived = NSUserDefaults.standardUserDefaults().objectForKey("wavesSurvived")!
    
    var highWave: SKLabelNode!
    var highestWave = NSUserDefaults.standardUserDefaults().objectForKey("highestWave")!
    
    override func didMoveToView(view: SKView) {
        
        /* Set UI connections */
        buttonRestart = self.childNodeWithName("buttonRestart") as! MSButtonNode
        waveLabel = self.childNodeWithName("waveLabel") as! SKLabelNode
        waveLabel.text = "Waves Survived: \(wavesSurvived)"
        highWave = self.childNodeWithName("highWave") as! SKLabelNode
        highWave.text = "Highest Wave Survived: \(highestWave)"
        
        /* Setup play button selection handler */
        buttonRestart.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
    }
}