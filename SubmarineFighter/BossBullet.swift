//
//  BossBullet.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 10/7/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class BossBullet: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = BossBullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "bossbullet"
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
            let bullet = SKSpriteNode(imageNamed: "bossbullet")
            bullet.name = "bossbullet"
            bullet.size = CGSizeMake(50, 30)
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(bullet)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
        
    }
    
}
