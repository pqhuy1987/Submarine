//
//  Enemy2.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/27/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class Enemy2: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //init(entityPosition: CGPoint) {
    init(entityPosition: CGPoint, viewSize: CGSize) {
        let entityTexture = Enemy2.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "enemy"
    }
    
    var pos: CGSize = CGSize(width: 0, height: 0)
    
    // Because entity returns nil when generateTexture func is called, we have to use this function to create singleton.
    override class func generateTexture() -> SKTexture? {
    
        // 1. Struct.
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2.
            let enemy2 = SKSpriteNode(imageNamed: "enemy2a")
            //enemy2.size = CGSizeMake(175, 105)
            enemy2.name = "enemy"
            
            // 3.
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy2)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
        
    }
}

