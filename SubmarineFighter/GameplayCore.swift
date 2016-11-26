//
//  GameplayCore.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 10/3/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

//import UIKit
import SpriteKit

struct GameplayCore {
    
    // MARK: - Player.
    func player() -> SKSpriteNode {
        // 1. Create player.
        let player = Player(entityPosition: CGPointZero, viewSize: CGSizeZero)
        
        return player
    }
    
    // MARK: - Shot.
    func shoot(_view: CGSize, position: CGPoint) ->(SKSpriteNode, SKAction){
        
        // 1. Create bullet.
        let bullet = Bullet(entityPosition: position)
        
        // 2. Create bullet actions.
        let moveToX = SKAction.moveToX(_view.width + bullet.size.width, duration: 2)
        let removeFromScreen = SKAction.removeFromParent()
        
        // 3. Create sequence of actions.
        let fireAndRemove = SKAction.sequence([moveToX, removeFromScreen])
        
        // 4. Return created object and action.
        return (bullet, fireAndRemove)
    }
    
    func powerUp(_view: CGSize) ->(SKSpriteNode, SKAction){
        // 1. Create powerUp object.
        let power = PowerUp(entityPosition: CGPointZero)
        
        // 2. Setup start positions.
        let startX = _view.width + power.size.width
        let startY = CGFloat(arc4random() % UInt32(_view.height)) - power.size.width
        
        // 3. Setup end positions.
        let endX = -power.size.width
        let endY = CGFloat(arc4random() % UInt32(_view.height)) - power.size.width
        
        // 4. Add position to powerUp object.
        power.position = CGPointMake(startX, startY)
        
        // 5. Create movement - actions.
        let move = SKAction.moveTo(CGPointMake(endX, endY), duration: 6)
        let spin = SKAction.rotateByAngle(-1, duration: 1)
        let remove = SKAction.removeFromParent()
        
        let spinForever = SKAction.repeatActionForever(spin)
        let moveAndRemove = SKAction.sequence([move,remove])
        let allTogether = SKAction.group([spinForever, moveAndRemove])
        
        return (power, allTogether)
    }
    
    func enemyType1(viewSize: CGSize) ->(SKSpriteNode, SKAction){
        // 1. Create enemy type 1.
        let enemy = Enemy1(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        
        // 2. Starting position.
        let startX = getStartX(viewSize.width, objectSizeWidth: enemy.frame.width)
        let startY = getStartY(viewSize.height, objectHeight: enemy.frame.height)
        
        // 3. Set starting position for enemy type 1.
        enemy.position = CGPointMake(startX, startY)
        
        // 4. Create movement - actions.
        let flightTime = NSTimeInterval(arc4random_uniform(2) + 3)
        let move = SKAction.moveTo(CGPoint(x: -enemy.size.width, y: startY), duration: flightTime)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move, remove])
        
        // 5. Return enemy object and actions.
        return (enemy, moveAndRemove)
    }
        
    func enemyType2(viewSize: CGSize) ->(SKSpriteNode, SKAction){
        // 1. Create enemy type 1.
        let enemy = Enemy2(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        
        // 2. Starting position.
        let startX = getStartX(viewSize.width, objectSizeWidth: enemy.frame.width)
        let startY = getStartY(viewSize.height, objectHeight: enemy.frame.height)
        
        // 3. Set starting position for enemy type 1.
        enemy.position = CGPointMake(startX, startY)
        
        // 4. Create movement - actions.
        let flightTime = NSTimeInterval(arc4random_uniform(2) + 3)
        let move = SKAction.moveTo(CGPoint(x: -enemy.size.width, y: startY), duration: flightTime)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move, remove])
        
        // 5. Return enemy object and actions.
        return (enemy, moveAndRemove)
    }
    
    func boss(viewSize: CGSize, bossType: Int) -> SKSpriteNode{
        // 1. Create boss.
        var boss = SKSpriteNode()
        
        switch bossType {
        case 1:
            boss = Boss1(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        case 2:
            boss = Boss2(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        case 3:
            boss = Boss3(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        default:
            boss = Boss1(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        }
        
        //let boss = Boss1(entityPosition: CGPointZero, viewSize: CGSize(width: viewSize.width, height: viewSize.height))
        
        // 2. Starting position.
        let startX = getStartX(viewSize.width, objectSizeWidth: -boss.frame.width)
        let startY = getStartY(viewSize.height, objectHeight: -boss.frame.height)
        
        // 3. Set starting position.
        boss.position = CGPointMake(startX, startY)
        
        // 5. Return boss sprite and action.
        return boss
    }
    
    func bossShoot(_view: CGSize, position: CGPoint) ->(SKSpriteNode, SKAction){
        
        // 1. Create bullet.
        let bossBullet = BossBullet(entityPosition: position)
        
        // 2. Create bullet actions.
        let moveToX = SKAction.moveToX(-bossBullet.size.width, duration: 2) // Bullet size is 25, so -30 is out of screen.
        let removeFromScreen = SKAction.removeFromParent()
        
        // 3. Create sequence of actions.
        let fireAndRemove = SKAction.sequence([moveToX, removeFromScreen])
        
        // 4. Return created object and action.
        return (bossBullet, fireAndRemove)
    }
    
    func healthBar(viewSize: CGSize, healtBarType: Int) -> SKSpriteNode{
        // 1. Create.
        var healthBar = SKSpriteNode()
        
        switch healtBarType {
        case 20:
            healthBar = HB100(entityPosition: CGPointZero)
        case 19:
            healthBar = HB95(entityPosition: CGPointZero)
        case 18:
            healthBar = HB90(entityPosition: CGPointZero)
        case 17:
            healthBar = HB85(entityPosition: CGPointZero)
        case 16:
            healthBar = HB80(entityPosition: CGPointZero)
        case 15:
            healthBar = HB75(entityPosition: CGPointZero)
        case 14:
            healthBar = HB70(entityPosition: CGPointZero)
        case 13:
            healthBar = HB65(entityPosition: CGPointZero)
        case 12:
            healthBar = HB60(entityPosition: CGPointZero)
        case 11:
            healthBar = HB55(entityPosition: CGPointZero)
        case 10:
            healthBar = HB50(entityPosition: CGPointZero)
        case 9:
            healthBar = HB45(entityPosition: CGPointZero)
        case 8:
            healthBar = HB40(entityPosition: CGPointZero)
        case 7:
            healthBar = HB35(entityPosition: CGPointZero)
        case 6:
            healthBar = HB30(entityPosition: CGPointZero)
        case 5:
            healthBar = HB25(entityPosition: CGPointZero)
        case 4:
            healthBar = HB20(entityPosition: CGPointZero)
        case 3:
            healthBar = HB15(entityPosition: CGPointZero)
        case 2:
            healthBar = HB10(entityPosition: CGPointZero)
        case 1:
            healthBar = HB5(entityPosition: CGPointZero)
        default:
            break
        }
        
        return healthBar
    }
    
    func staticBackground(viewSize: CGSize, backgroundImageName: String) -> SKSpriteNode{
        let background = SKSpriteNode(imageNamed: backgroundImageName)
        background.size = viewSize
        background.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
        
        return background
    }
    
    func background(viewSize: CGSize, frame: CGRect, backgroundImageName: String, layer: SKNode){
        var background = SKSpriteNode()
        let backgroundTexture = SKTexture(imageNamed: backgroundImageName) // Get background texture.
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 24) // Move background to the left.
        let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0) // Replace background.
        
        let backgroundSequence = SKAction.sequence([moveBackground, replaceBackground]) // Create squence.
        let moveBackgroundForever = SKAction.repeatActionForever(backgroundSequence) // Run action forever.
        
        for var i: CGFloat = 0; i < 3; i++ {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width/2 + i * backgroundTexture.size().width, y: CGRectGetMidY(frame))
            background.size.height = viewSize.height
            
            background.runAction(moveBackgroundForever)
            layer.addChild(background) // Add to background layer.
        }
    }
    
    // MARK: - Move methods.
    func moveSubmarineFighter(point:CGPoint, timeDelta:NSTimeInterval, playerPosition: CGPoint) -> CGPoint?{
        let distanceLeft: CGFloat = sqrt(pow(CGFloat(playerPosition.x - point.x),2) + pow(CGFloat(playerPosition.y) - point.y, 2))
        
        if distanceLeft > 4 {
            let distanceToTravel: CGFloat = CGFloat(timeDelta) * GameplayConfigurator.Player.playerSpeed
            let angle: CGFloat = atan2(point.y - playerPosition.y, point.x - playerPosition.x)
            
            let yOffset: CGFloat = distanceToTravel * sin(angle)
            let xOffset: CGFloat = distanceToTravel * cos(angle)
            
           return CGPointMake(playerPosition.x + xOffset, playerPosition.y + yOffset)
        }
        
        return nil
    }
    
    func bossMovement(viewSieze: CGSize, currentPositin: CGPoint) -> CGPoint{
        
        // Up or down.
        var up = Bool()
        
        // Calculate x.
        var newX = CGFloat()
        let tmpRand = Int(arc4random() % 200)
        let upOrDown = arc4random() % 10
        
        if upOrDown >= 5 {
            up = true // Prištevamo x.
            newX = currentPositin.x + CGFloat(tmpRand)
        } else {
            up = false // Odštevamo x.
            newX = currentPositin.x - CGFloat(tmpRand)
        }
        
        // Check if out of bounds.
        if up && currentPositin.x + CGFloat(tmpRand) >= viewSieze.width {
            newX = currentPositin.x - CGFloat(tmpRand)
        } else if !up && currentPositin.x - CGFloat(tmpRand) <= viewSieze.width * 0.7 {
            var randDif = arc4random() % 5
            if randDif == 0 { randDif = 1} // Check if random is 0.
            let randDifFloat = CGFloat(randDif) / 100
            newX = viewSieze.width * (randDifFloat + 0.7)
        }
        
        // Calculate y.
        var newY = CGFloat()
        let tmpRand2 = Int(arc4random() % 200)
        let upOrDown2 = arc4random() % 10
        
        if upOrDown2 >= 5 {
            up = true // Add Y coordinate.
            newY = currentPositin.y + CGFloat(tmpRand2)
        } else {
            up = false // Subtrack Y coordinate.
            newY = currentPositin.y - CGFloat(tmpRand2)
        }
        
        // Check if out of bounds.
        if up && currentPositin.y + CGFloat(tmpRand2) > (viewSieze.height - 200) {
            newY = currentPositin.y - CGFloat(tmpRand2)
        } else if !up && currentPositin.y - CGFloat(tmpRand2) <= 200 {
            newY = currentPositin.y + CGFloat(tmpRand2)
        }
        
        // Return new position.
        return CGPointMake(newX, newY)
    }
    
    func boss2Movement(viewSieze: CGSize, currentPositin: CGPoint) -> CGPoint?{
        
        // Up or down.
        var up = Bool()
        
        // Calculate x.
        var newX = CGFloat()
        let tmpRand = Int(arc4random() % 300)
        let upOrDown = arc4random() % 10
        
        if upOrDown >= 4 {
            up = true // Prištevamo x.
            newX = currentPositin.x + CGFloat(tmpRand)
        } else {
            up = false // Odštevamo x.
            newX = currentPositin.x - CGFloat(tmpRand)
        }
        
        // Check if out of bounds.
        if up && currentPositin.x + CGFloat(tmpRand) >= viewSieze.width {
            newX = currentPositin.x - CGFloat(tmpRand)
        } else if !up && currentPositin.x - CGFloat(tmpRand) <= viewSieze.width * 0.7 {
            var randDif = arc4random() % 5
            if randDif == 0 { randDif = 1} // Check if random is 0.
            let randDifFloat = CGFloat(randDif) / 100
            newX = viewSieze.width * (randDifFloat + 0.7)
        }
        
        // Calculate y.
        var newY = CGFloat()
        let tmpRand2 = Int(arc4random() % 400)
        let upOrDown2 = arc4random() % 10
        
        let shouldUpdatePosition = arc4random() % 100
        
        if(shouldUpdatePosition <= 35){
            // Do the update.
            if upOrDown2 >= 4 {
                up = true // Add Y coordinate.
                newY = currentPositin.y + CGFloat(tmpRand2)
            } else {
                up = false // Subtrack Y coordinate.
                newY = currentPositin.y - CGFloat(tmpRand2)
            }
            
            // Check if out of bounds.
            if up && currentPositin.y + CGFloat(tmpRand2) > (viewSieze.height - 200) {
                newY = currentPositin.y - CGFloat(tmpRand2)
            } else if !up && currentPositin.y - CGFloat(tmpRand2) <= 200 {
                newY = currentPositin.y + CGFloat(tmpRand2)
            }
            
            // Return new position.
            return CGPointMake(newX, newY)
        } else {
            return nil
        }
    }
    
    // MARK: - Helper methods.
    func getStartX(viewSizeWidth: CGFloat, objectSizeWidth: CGFloat) -> CGFloat{
        return viewSizeWidth + objectSizeWidth
    }
    
    func getStartY(viewHeight: CGFloat, objectHeight: CGFloat) -> CGFloat{
        return CGFloat(arc4random() % UInt32(viewHeight - objectHeight)) + objectHeight/2 // Random height Y.
    }
}
