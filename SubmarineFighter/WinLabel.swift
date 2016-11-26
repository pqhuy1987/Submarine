//
//  WinLabel.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 10/4/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class WinLabel: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = GameOverLabel.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "playerSubmarine"
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
            let label = SKLabelNode(fontNamed: "ArialMT")
            
            label.text = "You Finished Level"
            label.fontSize = 20
            label.fontColor = SKColor.whiteColor()
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(label)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
}
