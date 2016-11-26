//
//  BasseLevel.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 10/10/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class BaseLevel {
    
    // Layers.
    let playerHudNode = SKNode()
    let gameplayNode = SKNode()
    let backgroundLayerNode = SKNode()
    let backgroundMiscLayerNode = SKNode()
    
    // Properties.
    var subFighter = SKSpriteNode() // Player submarine.
    var boss = SKSpriteNode() // Boss sprite.
    var healthBar = SKSpriteNode() // Boss health bar.
    var healthBarBoss2 = SKSpriteNode() // Boss 2 health bar.
    
    // Level setup.
    var lastUpdateTime = NSTimeInterval()
    var lastFireTime = NSTimeInterval()
    var fireRate = CGFloat()
    
    var subTouch = UITouch()
    var touchInProgress = Bool()
    var gamePlayInProgress = true
    
    // Player data.
    var playerHealth:Int = 0
    
    // Boss on screen.
    var isBossActive = false
    var bossLife = 20
    var bossShootDif = 0
    var bossIsSpawned = false
    var bossIsPresent = true
    
    // Enemy counter.
    var currentEnemyKilled = 0
    var finalEnemyCnt = 0
    
    // Score.
    var score = 0
    var scoreNode = SKLabelNode()
    var enemyCnt = 0
    var enemyCount = SKLabelNode()
    var bossHealt = SKLabelNode()
    var playerHealthLabel = SKLabelNode()
    
    // Textures.
    let enemy1a = SKTexture(imageNamed: "enemy1a")
    let enemy1b = SKTexture(imageNamed: "enemy1b")
    let enemy1c = SKTexture(imageNamed: "enemy1c")
    let enemy2a = SKTexture(imageNamed: "enemy2a")
    let enemy2b = SKTexture(imageNamed: "enemy2b")
    let enemy2c = SKTexture(imageNamed: "enemy2c")
    
    // Health bar textures.
    let hb5 = SKTexture(imageNamed: "Healthbar5")
    let hb10 = SKTexture(imageNamed: "Healthbar10")
    let hb15 = SKTexture(imageNamed: "Healthbar15")
    let hb20 = SKTexture(imageNamed: "Healthbar20")
    let hb25 = SKTexture(imageNamed: "Healthbar25")
    let hb30 = SKTexture(imageNamed: "Healthbar30")
    let hb35 = SKTexture(imageNamed: "Healthbar35")
    let hb40 = SKTexture(imageNamed: "Healthbar40")
    let hb45 = SKTexture(imageNamed: "Healthbar45")
    let hb50 = SKTexture(imageNamed: "Healthbar50")
    let hb55 = SKTexture(imageNamed: "Healthbar55")
    let hb60 = SKTexture(imageNamed: "Healthbar60")
    let hb65 = SKTexture(imageNamed: "Healthbar65")
    let hb70 = SKTexture(imageNamed: "Healthbar70")
    let hb75 = SKTexture(imageNamed: "Healthbar75")
    let hb80 = SKTexture(imageNamed: "Healthbar80")
    let hb85 = SKTexture(imageNamed: "Healthbar85")
    let hb90 = SKTexture(imageNamed: "Healthbar90")
    let hb95 = SKTexture(imageNamed: "Healthbar95")
    let hb100 = SKTexture(imageNamed: "Healthbar100")
    
    // Boss texture.
    var bossTexture = SKTexture()
    
    // Effects.
    var explosionAction = SKAction()
    
    // Main theme music.
    var mainThemeMusic = AVAudioPlayer()
    
    // Explostion sound FSX.
    var explosionSoundAction = SKAction()
    var explosionSoundBossAction = SKAction()
    var shootSoundAction = SKAction()
    
    // Playable rectangle.
    let playableRect:CGRect
    
    init(size: CGSize){
        let maxAspecRatio:CGFloat = 16.0 / 9.0 // 1.
        let playableHeight = size.width / maxAspecRatio // 2.
        let playableMargin = (size.height - playableHeight) / 2.0 // 3.
        
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight) // 4.
        initSetup(size)
    }
    
    func initSetup(size: CGSize){
        fireRate = GameplayConfigurator.Shoot.fireRate // Set fire rate.
        playerHealth = GameplayConfigurator.Player.playerHealth // Set players health.
        bossLife = 20
        backgroundLayerNode.zPosition = 0
        backgroundMiscLayerNode.zPosition = 1
        playerHudNode.zPosition = 2
        gameplayNode.zPosition = 3        
        explosionSoundAction = SKAction.playSoundFileNamed("explosionRegularFX.mp3", waitForCompletion: false)
        explosionSoundBossAction = SKAction.playSoundFileNamed("explosionFX.mp3", waitForCompletion: false)
        shootSoundAction = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
        setupSounds() // Prepare background music sound.
    }
    
    func setupScene(frame: CGRect){
        fireRate = GameplayConfigurator.Shoot.fireRate // Fire rate setup.
        
        // Play music.
        //SKAction.repeatActionForever(mainThemeMusic)
        
        // Testing score label.        
        scoreNode = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreNode.text = "Score: \(score)"
        scoreNode.horizontalAlignmentMode = .Center
        scoreNode.fontSize = 70
        scoreNode.fontColor = SKColor.whiteColor()
        scoreNode.position = CGPointMake(frame.midX, frame.height - 250)
        
        // Players health label.
        //playerHealthLabel = SKLabelNode(fontNamed: "Bradley Hand")
        playerHealthLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        playerHealthLabel.text = "Health: 100"
        playerHealthLabel.horizontalAlignmentMode = .Left
        playerHealthLabel.fontSize = 70
        playerHealthLabel.fontColor = SKColor.whiteColor()
        playerHealthLabel.position = CGPointMake(30, frame.height - 250)

    }
    
    func setupPlayer(){
        subFighter = Player(entityPosition: CGPointZero, viewSize: CGSizeZero)
    }
    
    func setupEnemyCount(level: Int){
        switch level {
        case 1:
            finalEnemyCnt = GameplayConfigurator.Enemy.maxEnemyCountLvl1
            bossTexture = SKTexture(imageNamed: "Boss1-1.png")
        case 2:
            finalEnemyCnt = GameplayConfigurator.Enemy.maxEnemyCountLvl2
            bossTexture = SKTexture(imageNamed: "Boss2-1.png")
        case 3:
            finalEnemyCnt = GameplayConfigurator.Enemy.maxEnemyCountLvl3
            bossTexture = SKTexture(imageNamed: "Boss3-1.png")
        case 4:
            finalEnemyCnt = GameplayConfigurator.Enemy.maxEnemyCountLvl4
        default:
            break
        }
        
        print("Final enemy count = \(finalEnemyCnt)")
    }
    
    func setupSounds(){
        let url: NSURL = NSBundle.mainBundle().URLForResource("main_theme", withExtension: "mp3")!
        
        do {
            mainThemeMusic = try AVAudioPlayer(contentsOfURL: url)
        } catch _ {
            print("Error loading background music")
        }
        
        mainThemeMusic.numberOfLoops = -1
        mainThemeMusic.volume = 0.55
        mainThemeMusic.prepareToPlay()
    }
    
    func createExplosion001() ->(SKEmitterNode?){
        return SKEmitterNode(fileNamed: "Explosion001")
    }
    
    func createExplosion(name: String) ->(SKEmitterNode?){
        return SKEmitterNode(fileNamed: name)
    }
    
    func animateEnemyType1() -> SKAction {
        var textures = [SKTexture]()
        textures.append(enemy1a)
        textures.append(enemy1b)
        textures.append(enemy1c)
        textures.append(enemy1b)
        
        let enemy1Animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        return enemy1Animation
    }
    
    func animateEnemyType2() -> SKAction {
        var textures = [SKTexture]()
        textures.append(enemy2a)
        textures.append(enemy2b)
        textures.append(enemy2c)
        textures.append(enemy2b)
        
        let enemy2Animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        return enemy2Animation
    }
    
    func handleBossColor(bossLifeCurrentValue: Int) -> UIColor {
        //switch(bossLife){
        switch(bossLifeCurrentValue){
        case 20:
            return GameplayConfigurator.BossColors.color20
        case 19:
            return GameplayConfigurator.BossColors.color19
        case 18:
            return GameplayConfigurator.BossColors.color18
        case 17:
            return GameplayConfigurator.BossColors.color17
        case 16:
            return GameplayConfigurator.BossColors.color16
        case 15:
            return GameplayConfigurator.BossColors.color15
        case 14:
            return GameplayConfigurator.BossColors.color14
        case 13:
            return GameplayConfigurator.BossColors.color13
        case 12:
            return GameplayConfigurator.BossColors.color12
        case 11:
            return GameplayConfigurator.BossColors.color11
        case 10:
            return GameplayConfigurator.BossColors.color10
        case 9:
            return GameplayConfigurator.BossColors.color9
        case 8:
            return GameplayConfigurator.BossColors.color8
        case 7:
            return GameplayConfigurator.BossColors.color7
        case 6:
            return GameplayConfigurator.BossColors.color6
        case 5:
            return GameplayConfigurator.BossColors.color5
        case 4:
            return GameplayConfigurator.BossColors.color4
        case 3:
            return GameplayConfigurator.BossColors.color3
        case 2:
            return GameplayConfigurator.BossColors.color2
        case 1:
            return GameplayConfigurator.BossColors.color1
        default:
            break
        }
        
        return GameplayConfigurator.BossColors.color5
    }
    
    func handleHealthBar(){
        switch(bossLife){
        case 20:
            healthBar = SKSpriteNode(texture: hb100)
        case 19:
            healthBar = SKSpriteNode(texture: hb95)
        case 18:
            healthBar = SKSpriteNode(texture: hb90)
        case 17:
            healthBar = SKSpriteNode(texture: hb85)
        case 16:
            healthBar = SKSpriteNode(texture: hb80)
        case 15:
            healthBar = SKSpriteNode(texture: hb75)
        case 14:
            healthBar = SKSpriteNode(texture: hb70)
        case 13:
            healthBar = SKSpriteNode(texture: hb65)
        case 12:
            healthBar = SKSpriteNode(texture: hb60)
        case 11:
            healthBar = SKSpriteNode(texture: hb55)
        case 10:
            healthBar = SKSpriteNode(texture: hb50)
        case 9:
            healthBar = SKSpriteNode(texture: hb45)
        case 8:
            healthBar = SKSpriteNode(texture: hb40)
        case 7:
            healthBar = SKSpriteNode(texture: hb35)
        case 6:
            healthBar = SKSpriteNode(texture: hb30)
        case 5:
            healthBar = SKSpriteNode(texture: hb25)
        case 4:
            healthBar = SKSpriteNode(texture: hb20)
        case 3:
            healthBar = SKSpriteNode(texture: hb15)
        case 2:
            healthBar = SKSpriteNode(texture: hb10)
        case 1:
            healthBar = SKSpriteNode(texture: hb5)
        default:
            break
        }
        
        return
    }
    
    func handleHealthBarBoss2(_boss2Life: Int){
        switch(_boss2Life){
        case 20:
            healthBarBoss2 = SKSpriteNode(texture: hb100)
        case 19:
            healthBarBoss2 = SKSpriteNode(texture: hb95)
        case 18:
            healthBarBoss2 = SKSpriteNode(texture: hb90)
        case 17:
            healthBarBoss2 = SKSpriteNode(texture: hb85)
        case 16:
            healthBarBoss2 = SKSpriteNode(texture: hb80)
        case 15:
            healthBarBoss2 = SKSpriteNode(texture: hb75)
        case 14:
            healthBarBoss2 = SKSpriteNode(texture: hb70)
        case 13:
            healthBarBoss2 = SKSpriteNode(texture: hb65)
        case 12:
            healthBarBoss2 = SKSpriteNode(texture: hb60)
        case 11:
            healthBarBoss2 = SKSpriteNode(texture: hb55)
        case 10:
            healthBarBoss2 = SKSpriteNode(texture: hb50)
        case 9:
            healthBarBoss2 = SKSpriteNode(texture: hb45)
        case 8:
            healthBarBoss2 = SKSpriteNode(texture: hb40)
        case 7:
            healthBarBoss2 = SKSpriteNode(texture: hb35)
        case 6:
            healthBarBoss2 = SKSpriteNode(texture: hb30)
        case 5:
            healthBarBoss2 = SKSpriteNode(texture: hb25)
        case 4:
            healthBarBoss2 = SKSpriteNode(texture: hb20)
        case 3:
            healthBarBoss2 = SKSpriteNode(texture: hb15)
        case 2:
            healthBarBoss2 = SKSpriteNode(texture: hb10)
        case 1:
            healthBarBoss2 = SKSpriteNode(texture: hb5)
        default:
            break
        }
        
        return
    }
    
    func dropGameObjects()->Int{
        if gamePlayInProgress && !isBossActive && enemyCnt < finalEnemyCnt {
            let objectType: UInt32 = arc4random() % 100
            
            if objectType < 1 {
                return 1 // Create Droppowerup.
            } else if objectType < 20 {
                enemyCnt++
                return 2 // Create EnemyType1.
            } else if objectType < 30 {
                enemyCnt++
                return 3 // Create EnemyType2.
            }
        } else {
            isBossActive = true
            if !bossIsSpawned {
                bossIsSpawned = true
                return 4 // Create boss.
            }
        }
        return 0 // Nothing selected.
    }
    
    func handleTouchBegan(touches: Set<UITouch>){
       subTouch = touches.first!
        if gamePlayInProgress {
            touchInProgress = true
        }
    }
    
    func handleTouchesEnded(){
        touchInProgress = false
    }
    
    func evaluateActions()->Bool{
        if currentEnemyKilled < GameplayConfigurator.Enemy.maxEnemyCountLvl1 || bossLife > 0 {
            return true
        } else {
            gamePlayInProgress = false
            return false
        }
    }
    
    func createPlayer(frameHeight: CGFloat){
        subFighter = Player(entityPosition: CGPointZero, viewSize: CGSizeZero)
        subFighter.position = CGPoint(x: subFighter.frame
            .width + 5, y: frameHeight * 0.5)
    }
    
    func createGameOverLabel(didWin: Bool) -> SKLabelNode{
        
        var text = String()
        
        if didWin {
            text = "You win"
        } else {
            text = "You lost"
        }
        
        let levelOverLabelNode = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        levelOverLabelNode.text = text
        //levelOverLabelNode.horizontalAlignmentMode = .Left
        levelOverLabelNode.fontSize = 100
        levelOverLabelNode.fontColor = SKColor.whiteColor()
        levelOverLabelNode.position = CGPointMake(playableRect.width * 0.5, playableRect.height * 0.5)
        levelOverLabelNode.zPosition = 10
        
        return levelOverLabelNode
        
    }
    
}