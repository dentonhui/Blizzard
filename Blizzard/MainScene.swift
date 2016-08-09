//
//  MainScene.swift
//  Blizzard
//
//  Created by Denton Hui on 7/12/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene: SKScene {
    
    /* UI Connections */
    var buttonPlay: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        /* Set UI connections */
        buttonPlay = self.childNodeWithName("buttonPlay") as! MSButtonNode
        
        /* Setup play button selection handler */
        buttonPlay.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFit
            
            /* Show debug */
            skView.showsPhysics = false
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
        // Snow particle effect
        /* Load our particle effect */
        let particles = SKEmitterNode(fileNamed: "Snow")!
        
        particles.position = CGPointMake(284, 320)
        
        /* Restrict total particles to reduce runtime of particle */
        //particles.numParticlesToEmit = 25
        
        /* Add particles to scene */
        addChild(particles)

    }
}