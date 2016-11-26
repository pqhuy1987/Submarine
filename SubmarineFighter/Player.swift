//
//  Player.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/30/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class Player: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint, viewSize: CGSize) {
        let entityTexture = Player.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "player"
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
            let player = SKSpriteNode(imageNamed: "sub.png")
            player.name = "player"
            player.size = CGSizeMake(150, 102) // Player size.
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(player)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
}
