//
//  GameplayConfigurator.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 9/30/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

// 70, 144 170

import UIKit

struct GameplayConfigurator {
    
    struct Shoot {
        static let fireRate: CGFloat = 0.5
    }
    
    struct Enemy {
        static let enemyDamage = 10
        static let maxEnemyCountLvl1 = 50
        static let maxEnemyCountLvl2 = 100
        static let maxEnemyCountLvl3 = 200
        static let maxEnemyCountLvl4 = 300
    }
    
    struct Boss {
        static let health = 20
    }
    
    struct Boss1 {
        static let health = 5
        static let fireRate: CGFloat = 1
        static let bossDamage: Int = 20
    }
    
    struct Boss2 {
        static let health = 5
        static let fireRate: CGFloat = 1
        static let bossDamage: Int = 30
    }
    
    struct Boss3 {
        static let health = 5
        static let fireRate: CGFloat = 1
        static let bossDamage: Int = 40
    }
    
    struct Boss4 {
        static let health = 5
        static let fireRate: CGFloat = 1
        static let bossDamage: Int = 50
    }
    
    struct BossColors {
        // Greeen.
        static let color20 = UIColor(colorLiteralRed: 0/255, green: 80/255, blue: 0/255, alpha: 1)
        static let color19 = UIColor(colorLiteralRed: 0/255, green: 120/255, blue: 0/255, alpha: 1)
        static let color18 = UIColor(colorLiteralRed: 0/255, green: 160/255, blue: 0/255, alpha: 1)
        static let color17 = UIColor(colorLiteralRed: 0/255, green: 200/255, blue: 0/255, alpha: 1)
        static let color16 = UIColor(colorLiteralRed: 0/255, green: 255/255, blue: 0/255, alpha: 1)
        
        // Blue.
        static let color15 = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 80/255, alpha: 1)
        static let color14 = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 120/255, alpha: 1)
        static let color13 = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 160/255, alpha: 1)
        static let color12 = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 200/255, alpha: 1)
        static let color11 = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        
        // Yellow.
        static let color10 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 180/255, alpha: 1)
        static let color9 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 140/255, alpha: 1)
        static let color8 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 100/255, alpha: 1)
        static let color7 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 60/255, alpha: 1)
        static let color6 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 0/255, alpha: 1)
        
        // Red.
        static let color5 = UIColor(colorLiteralRed: 130/255, green: 0/255, blue: 0/255, alpha: 1)
        static let color4 = UIColor(colorLiteralRed: 160/255, green: 0/255, blue: 0/255, alpha: 1)
        static let color3 = UIColor(colorLiteralRed: 190/255, green: 0/255, blue: 0/255, alpha: 1)
        static let color2 = UIColor(colorLiteralRed: 210/255, green: 0/255, blue: 0/255, alpha: 1)
        static let color1 = UIColor(colorLiteralRed: 255/255, green: 0/255, blue: 0/255, alpha: 1)

    }
    
    struct Player {
        static let playerSpeed: CGFloat = /*160*/ 450
        static let playerHealth: Int = 100
    }
    
    struct GameItems {
        static let dropGameObjectFrequency: UInt32 = 10
    }
    
}
