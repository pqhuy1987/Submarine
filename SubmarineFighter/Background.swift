//
//  Background.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/30/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class Background: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = Background.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "background"
    }
    
    // Because entity returns nil when generateTexture func is called, we have to use this function to create singleton.
    override class func generateTexture() -> SKTexture? {
        
        // 1. Struct.
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2.
            var background = SKSpriteNode()
            let backgroundTexture = SKTexture(imageNamed: "background") // Get background texture.
            
            let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 24) // Move background to the left.
            let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0) // Replace background.
            
            let backgroundSequence = SKAction.sequence([moveBackground, replaceBackground]) // Create squence.
            let moveBackgroundForever = SKAction.repeatActionForever(backgroundSequence) // Run action forever.
            
            for var i: CGFloat = 0; i < 3; i++ {
                background = SKSpriteNode(texture: backgroundTexture)
                //background.position = CGPoint(x: backgroundTexture.size().width/2 + i * backgroundTexture.size().width, y: CGRectGetMidY(1000))
                //background.size.height = self.frame.height
            
                background.runAction(moveBackgroundForever)
            }
        
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(background)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
        
    }
    
}

