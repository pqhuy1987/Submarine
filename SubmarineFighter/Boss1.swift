//
//  Boss1.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 10/5/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class Boss1: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint, viewSize: CGSize) {
        let entityTexture = Boss1.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "boss1"
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
            let boss1 = SKSpriteNode(imageNamed: "Boss1-1")
            boss1.name = "boss1"
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(boss1)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
}
