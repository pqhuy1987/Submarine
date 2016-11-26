//
//  Level1Scene.swift
//  Submarine Fighter
//
//  Created by Boris Filipović on 9/27/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import UIKit
import SpriteKit

class Level1Scene: SKScene {

    // Base level class.
    //let baseLevel = BaseLevel.init(size: CGSize(width: 2048, height: 1536))
    
    // Level size.
    let screenSize: CGSize
    
    // Base level class.
    let baseLevel: BaseLevel
    
    // Boss textures.
    let bossTexture1 = SKTexture(imageNamed: "Boss1-1.png")
    let bossTexture2 = SKTexture(imageNamed: "Boss1-2.png")
    let bossTexture3 = SKTexture(imageNamed: "Boss1-3.png")
    
    // Boss animation.
    var bossAnimationAction = SKAction()
    
    init(_size: CGSize){
        screenSize = _size
        baseLevel = BaseLevel(size: screenSize)
        super.init(size: _size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented!")
    }
    
    override func didMoveToView(view: SKView) {
        setupSceneLayers() // Setup scene layers.
        setupScene() // Add labels to screen.
        createBackground() // Add scrolling background.
        setupPlayer() // Add player.
        setupEnemyCount() // Setup max enemy count.
        setupBossAnimationAction() // Prepare boss animation action.
        playBakckgroundMusic()
    }
    
    func playBakckgroundMusic(){
       baseLevel.mainThemeMusic.play() // Play background music.
    }
    
    // MARK: -Layer setup.
    func setupSceneLayers() {
        let layerArray = ([baseLevel.backgroundLayerNode, baseLevel.playerHudNode, baseLevel.gameplayNode, baseLevel.backgroundMiscLayerNode])
        for layer in layerArray {
            addChild(layer)
        }
    }

    // MARK: -Scene setup.
    func setupScene() {
        baseLevel.setupScene(frame)
        
        // Add labels to screen.
        baseLevel.playerHudNode.addChild(baseLevel.scoreNode)
        baseLevel.playerHudNode.addChild(baseLevel.playerHealthLabel)
        baseLevel.playerHudNode.addChild(baseLevel.enemyCount)
        baseLevel.playerHudNode.addChild(baseLevel.bossHealt)
    }
    
    // MARK: - Player setup.
    func setupPlayer() {
        baseLevel.setupPlayer()
        baseLevel.subFighter.position = CGPointMake(baseLevel.subFighter.frame.width, frame.height * 0.5)
        baseLevel.gameplayNode.addChild(baseLevel.subFighter)
    }
    
    // MARK: - Max enemy count.
    func setupEnemyCount(){
        baseLevel.setupEnemyCount(1)
    }
    
    // MARK: - Explosion001 setup.
//    func setupExplosion001(){
//        baseLevel.setupExplosion001()
//    }
    
    // MARK: - Explosion_001 sound.
//    func setupExplosionSound() {
//        baseLevel.setupExplosionSound()
//    }
    
    // MARK: - Boss animation.
    func setupBossAnimationAction(){
        var textures = [SKTexture]()
        textures.append(bossTexture1)
        textures.append(bossTexture2)
        textures.append(bossTexture3)
        textures.append(bossTexture2)
        
        bossAnimationAction = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
    }
    
    // MARK: - Main Background.
    func createBackground() {
        GameplayCore().background(CGSize(width: self.frame.width, height: self.frame.height), frame: self.frame, backgroundImageName: "lvl3", layer: baseLevel.backgroundLayerNode)
        //GameplayCore().background(CGSize(width: self.frame.width, height: self.frame.height), frame: self.frame, backgroundImageName: "lvl4", layer: baseLevel.backgroundLayerNode)
    }
    
    // MARK: - Touches.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        baseLevel.handleTouchBegan(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
         baseLevel.handleTouchesEnded()
    }
    
    // MARK: - Update.
    override func update(currentTime: NSTimeInterval) {
        if  baseLevel.gamePlayInProgress {
            // Create enemies.
            if (arc4random() % 100 ) <= GameplayConfigurator.GameItems.dropGameObjectFrequency {
                dropGameObjects()
            }
            
            if baseLevel.lastUpdateTime == 0 {
                baseLevel.lastUpdateTime = currentTime
            }
            
            let delta:NSTimeInterval = currentTime - baseLevel.lastUpdateTime
            
            if  baseLevel.touchInProgress {
                var touchLocation: CGPoint = baseLevel.subTouch.locationInNode(self)
                touchLocation.x += 20
                
                // Move player.
                let movePlayerToPosition = GameplayCore().moveSubmarineFighter(touchLocation, timeDelta: delta, playerPosition: baseLevel.subFighter.position)
                if movePlayerToPosition != nil {
                    baseLevel.subFighter.position = movePlayerToPosition!
                }
                
                // Shooting while we are touching screen to move heli.
                if ( CGFloat(currentTime - baseLevel.lastFireTime) > baseLevel.fireRate) {
                    shoot()
                    baseLevel.lastFireTime = currentTime
                }
            }
            
            baseLevel.lastUpdateTime = currentTime
        }
    }
    
    // MARK: - DidEvaluateActions method.
    override func didEvaluateActions() {
        baseLevel.evaluateActions() ? checkForCollisions() : levelOver(true)
    }
    
    // MARK: -Check collisions.
    func checkForCollisions(){
        if baseLevel.gamePlayInProgress {
            // Check collision between player and power node.
            baseLevel.gameplayNode.enumerateChildNodesWithName("power", usingBlock: { (powernode: SKNode, stop: UnsafeMutablePointer) -> Void in
                if self.baseLevel.subFighter.intersectsNode(powernode) {
                    self.baseLevel.score += 100 // Increse score.
                    powernode.removeFromParent() // Remove power node from screen.
                    self.baseLevel.fireRate = 0.1 // Increse fire rate (for 5 seconds).
                    
                    let normalShoot = SKAction.runBlock({ () -> Void in
                        self.baseLevel.fireRate = 0.5
                    })
                    
                    let wait = SKAction.waitForDuration(5.0) // Wait for 5 seconds.
                    let waitAndShoot = SKAction.sequence([wait, normalShoot]) // Create sequence.
                    
                    // Create broadcast.
                    self.baseLevel.subFighter.removeActionForKey("waitAndNormalShoot")
                    self.baseLevel.subFighter.runAction(waitAndShoot, withKey: "waitAndNormalShoot")
                }
            })
            
            // Check collision betwen enemy fighter and player.
            baseLevel.gameplayNode.enumerateChildNodesWithName("enemy", usingBlock: { (enemynode: SKNode, stop:UnsafeMutablePointer) -> Void in
                
                // Check if heli and enemy collids.
                if self.baseLevel.subFighter.intersectsNode(enemynode) {
                    enemynode.removeFromParent() // Remove enemy node.
                    self.baseLevel.playerHealth -= GameplayConfigurator.Enemy.enemyDamage // Zmanjši življenje.
                    self.baseLevel.playerHealthLabel.text = "Health: \(self.baseLevel.playerHealth)"
                    if self.baseLevel.playerHealth <= 0 {
                        self.baseLevel.subFighter.removeAllActions()
                        self.baseLevel.subFighter.removeFromParent()
                        self.levelOver(false) // Call game over.
                    }
                }
                
                // Check if enemy was hit with our laser.
                self.baseLevel.gameplayNode.enumerateChildNodesWithName("fire", usingBlock: { (firenode: SKNode, stop: UnsafeMutablePointer) -> Void in
                    if enemynode.intersectsNode(firenode) {
                        self.explosion("Explosion002", _position: enemynode.position)
                        enemynode.removeFromParent()
                        firenode.removeFromParent()
                        self.runAction(self.baseLevel.explosionSoundAction)
                        ++self.baseLevel.currentEnemyKilled // Increse score.
                        self.baseLevel.score += 200 // Increse score.
                    }
                })
            })

            if baseLevel.isBossActive && baseLevel.bossLife > 0 {
                // Check if enemy was hit with our laser.
                var bulletArray = [SKNode]()
                self.baseLevel.gameplayNode.enumerateChildNodesWithName("fire", usingBlock: { (firenode: SKNode, stop: UnsafeMutablePointer) -> Void in
                    
                    if self.baseLevel.boss.intersectsNode(firenode){
                        bulletArray.append(firenode)
                        self.baseLevel.bossLife--
                        // Color enemy
                        let turnColor = SKAction.colorizeWithColor(self.baseLevel.handleBossColor(self.baseLevel.bossLife), colorBlendFactor: 1.0, duration: 0.2)
                        self.baseLevel.boss.runAction(turnColor)
                        self.createBossHealthBar() // Update boss health bar.
                        if(self.baseLevel.bossLife <= 0 && self.baseLevel.bossIsSpawned){
                            self.baseLevel.score += 500 // Increse score.
                            self.runAction(self.baseLevel.explosionSoundBossAction)
                            self.explosion("Explosion003", _position: firenode.position)
                            self.baseLevel.boss.removeFromParent()
                            self.levelOver(true)
                        }
                    }
                    
                    for node in bulletArray {
                        node.removeFromParent()
                    }
                    
                })
            }

            // Check for collisions betwen boss bullet and player.
            baseLevel.gameplayNode.enumerateChildNodesWithName("bossbullet", usingBlock: { (bossbulletnode, stop: UnsafeMutablePointer) -> Void in
                if self.baseLevel.bossLife > 0 {
                    if self.baseLevel.subFighter.intersectsNode(bossbulletnode){
                        bossbulletnode.removeFromParent() // Remove node from parent.
                        self.baseLevel.playerHealth -= GameplayConfigurator.Boss1.bossDamage
                        self.baseLevel.playerHealthLabel.text = "Health: \(self.baseLevel.playerHealth)"
                        if self.baseLevel.playerHealth <= 0 {
                            self.baseLevel.subFighter.removeFromParent()
                            self.levelOver(false) // Call game over.
                        }
                    }
                }

            })

        }
        baseLevel.scoreNode.text = "Score: \(baseLevel.score)" // Write score to display.
    }
    
    func levelOver(playerWin: Bool){
        // Show game over label.
        self.addChild(baseLevel.createGameOverLabel(playerWin))
        let waitAction = SKAction.waitForDuration(2)
        let runAction = SKAction.runBlock { () -> Void in
            self.baseLevel.mainThemeMusic.stop() // Stop background music.
            let scene = MidGameHubScene(_size: CGSize(width: self.frame.width, height: self.frame.height), _score: self.baseLevel.score, isWin: playerWin, _levelName: 1)
            let transition = SKTransition.doorsOpenHorizontalWithDuration(1)
            self.view?.presentScene(scene, transition: transition)
        }
        
        let runGameOverSequence = SKAction.sequence([waitAction, runAction])
        self.runAction(runGameOverSequence)
    }
    
    // MARK: -Spawn enemies and/or enemy objects.
    func dropGameObjects() {
        switch(baseLevel.dropGameObjects()){
        case 1:
            createPower()
        case 2:
            baseLevel.enemyCount.text = "Enemie count: \(baseLevel.enemyCnt)"
            createEnemyType1()
        case 3:
            baseLevel.enemyCount.text = "Enemie count: \(baseLevel.enemyCnt)"
            createEnemyType2()
        case 4:
            createBoss()
        default:
            break
        }
    }
    
    // MARK: - Create bullet.
    func shoot() {
        let (fire, fireAndRemove) = GameplayCore().shoot(CGSize(width: self.frame.width, height: self.frame.height), position: CGPointMake(baseLevel.subFighter.position.x + 50, baseLevel.subFighter.position.y - 10))
        baseLevel.gameplayNode.addChild(fire) // Add object to screen.
        fire.runAction(fireAndRemove) // Run action.
        self.runAction(baseLevel.shootSoundAction) // Play shoot sound.
    }
    
    func explosion(name: String, _position: CGPoint){
        if let explosion = baseLevel.createExplosion(name){
            explosion.position = _position
            baseLevel.gameplayNode.addChild(explosion)
            explosion.runAction(baseLevel.explosionAction)
        }
    }
    
    // MARK: - Boss.
    func createBoss(){
        baseLevel.bossLife = GameplayConfigurator.Boss.health // Set boss health.
        //baseLevel.boss = GameplayCore().boss(CGSize(width: self.frame.width, height: self.frame.height), bossType: 1)
        baseLevel.boss = SKSpriteNode(texture: baseLevel.bossTexture)
        let turnColor = SKAction.colorizeWithColor(self.baseLevel.handleBossColor(baseLevel.bossLife), colorBlendFactor: 1.0, duration: 0.2)
        self.baseLevel.boss.runAction(turnColor)
        baseLevel.gameplayNode.addChild(baseLevel.boss)
        baseLevel.boss.runAction(SKAction.repeatActionForever(bossAnimationAction))
        repeatAct()
        
        // Create boss healthbar.
        createBossHealthBar()
    }
    
    // Create boss healthbar.
//    func createBossHealthBar(){
//        baseLevel.healthBar.removeFromParent()
//        baseLevel.healthBar = GameplayCore().healthBar(CGSize(width: self.frame.width, height: self.frame.height), healtBarType: baseLevel.bossLife)
//        baseLevel.healthBar.position = CGPoint(x: 0.0, y: baseLevel.boss.frame.height * 0.6)
//        baseLevel.boss.addChild(baseLevel.healthBar)
//    }
    
    func createBossHealthBar() {
        baseLevel.healthBar.removeFromParent()
        baseLevel.handleHealthBar()
        baseLevel.healthBar.position = CGPoint(x: 0.0, y: baseLevel.boss.frame.height * 0.6)
        //baseLevel.healthBar.size = CGSize(width: 500, height: 23)
        baseLevel.boss.addChild(baseLevel.healthBar)
    }
    
    // MARK: - Repeat boss movement.
    func repeatAct(){
        let moveTo = SKAction.moveTo(GameplayCore().bossMovement(CGSize(width: self.frame.width, height: self.frame.height), currentPositin: baseLevel.boss.position), duration: 0.5)
        baseLevel.boss.runAction(moveTo) { () -> Void in
            self.baseLevel.bossShootDif++
            if self.baseLevel.bossShootDif >= 2 {
                self.baseLevel.bossShootDif = 0 // Reset shoot dif.
                self.bossShoot() // Boss shoots bullet.
            }
            self.repeatAct() // Rekurzija.
        }
    }
    
    // MARK: - Boss bullet.
    func bossShoot(){
        let (bullet, action) = GameplayCore().bossShoot(CGSize(width: self.frame.width, height: self.frame.height), position: baseLevel.boss.position)
        baseLevel.gameplayNode.addChild(bullet)
        bullet.runAction(action)
    }
    
    // MARK: - Create power.
    func createPower() {
        let (power, actionGroup) = GameplayCore().powerUp(CGSize(width: self.frame.width, height: self.frame.height))
        baseLevel.gameplayNode.addChild(power)
        power.runAction(actionGroup)        
    }
    
    // MARK: - Enemy type 1.
    func createEnemyType1(){
        let (enemyType1, enemyActionGroup) = GameplayCore().enemyType1(CGSize(width: self.frame.width, height: self.frame.height))
        baseLevel.gameplayNode.addChild(enemyType1)
        enemyType1.runAction(SKAction.repeatActionForever(baseLevel.animateEnemyType1()))
        enemyType1.runAction(enemyActionGroup)
    }
    
    // MARK: - Enemy type 2.
    func createEnemyType2(){
        let (enemyType2, enemyActionGroup) = GameplayCore().enemyType2(CGSize(width: self.frame.width, height: self.frame.height))
        baseLevel.gameplayNode.addChild(enemyType2)
        enemyType2.runAction(SKAction.repeatActionForever(baseLevel.animateEnemyType2()))
        enemyType2.runAction(enemyActionGroup)
    }
    
    override func willMoveFromView(view: SKView) {        
        self.removeAllChildren()
        self.removeAllActions()
        //baseLevel.mainThemeMusic.stop() // Stop background music.
    }
}