//
//  PowerUp.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/27/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class PowerUp: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = PowerUp.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "power"
    }
    
    // Because entity returns nil when generateTexture func is called, we have to use this function to create singleton.
    override class func generateTexture() -> SKTexture? {
        
        // 1. Struct.
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // Preload power textures.
            let powerTexture1 = SKTexture(imageNamed: "power1.png")
            let power = SKSpriteNode(texture: powerTexture1)

            power.name = "power"
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(power)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
}
