//
//  Entity.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/27/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode {
    
    // iVars.
    var direction = CGPointZero
    var lifes = 1
    var maxLifes = 1
    
    // Required init.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Initializer for this class. It takes the initial position along with its texture.
    init(position: CGPoint, texture: SKTexture) {
    
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())

        self.position = position
    }
    
    // Generate texture.
    class func generateTexture() -> SKTexture? {    
        // Override by sublclass.
        return nil
    }
    
    func update(delta: NSTimeInterval) {
        // Override by subclass.
    }
    
    
    
}
