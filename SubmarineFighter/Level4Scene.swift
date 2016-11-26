//
//  Level4Scene.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 11/22/15.
//  Copyright © 2015 devsonmars. All rights reserved.
//

import UIKit
import SpriteKit

class Level4Scene: SKScene {
    
    // Level size.
    let screenSize: CGSize
    let previousScore: Int
    
    // Base level class.
    let baseLevel: BaseLevel
    
    // Boss textures.
    let bossTexture1 = SKTexture(imageNamed: "Boss3-1.png")
    let bossTexture2 = SKTexture(imageNamed: "Boss3-2.png")
    let bossTexture3 = SKTexture(imageNamed: "Boss3-3.png")
    
    // Boss2 textures.
    let boss2Texture1 = SKTexture(imageNamed: "Boss2-1.png")
    let boss2Texture2 = SKTexture(imageNamed: "Boss2-2.png")
    let boss2Texture3 = SKTexture(imageNamed: "Boss2-3.png")
    
    // Boss animation.
    var bossAnimationAction = SKAction()
    var boss2AnimationAction = SKAction()
    
    init(_size: CGSize, _previusScore: Int){
        screenSize = _size
        previousScore = _previusScore
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
        setupEnemyCount() // Setup final enemy count for this level.
        setupBossAnimationAction() // Prepare boss animation action.
        setupBoss2AnimationAction() // Prepare boss animation action.
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
        // Setup score.
        baseLevel.score = previousScore
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
        baseLevel.setupEnemyCount(4)
    }
    
    // MARK: - Boss animation.
    func setupBossAnimationAction(){
        var textures = [SKTexture]()
        textures.append(bossTexture1)
        textures.append(bossTexture2)
        textures.append(bossTexture3)
        textures.append(bossTexture2)
        
        bossAnimationAction = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
    }
    
    // MARK: - Boss animation.
    func setupBoss2AnimationAction(){
        var textures = [SKTexture]()
        textures.append(boss2Texture1)
        textures.append(boss2Texture2)
        textures.append(boss2Texture3)
        textures.append(boss2Texture2)
        
        boss2AnimationAction = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
    }
    
    // MARK: - Main Background.
    func createBackground() {
        GameplayCore().background(CGSize(width: self.frame.width, height: self.frame.height), frame: self.frame, backgroundImageName: "lvl2", layer: baseLevel.backgroundLayerNode)
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
    
    var boss1IsDead = false
    var boss2IsDead = false
    
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
                        //self.baseLevel.explosionSound_001.play() // Play explosion sound.
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
                        if(!self.boss1IsDead && self.baseLevel.bossLife <= 0 && self.baseLevel.bossIsSpawned){
                            self.boss1IsDead = true
                            self.baseLevel.score += 500 // Increse score.
                            self.runAction(self.baseLevel.explosionSoundBossAction)
                            self.explosion("Explosion003", _position: firenode.position)
                            self.baseLevel.boss.removeFromParent()
                        }
                    }
                    
                    if self.boss2.intersectsNode(firenode){
                        bulletArray.append(firenode)
                        self.boss2Life--
                        // Color enemy
                        let turnColor = SKAction.colorizeWithColor(self.baseLevel.handleBossColor(self.boss2Life), colorBlendFactor: 1.0, duration: 0.2)
                        self.boss2.runAction(turnColor)
                        self.createBoss2HealthBar() // Update boss health bar.
                        if(!self.boss2IsDead && self.boss2Life <= 0 && self.baseLevel.bossIsSpawned){
                            self.boss2IsDead = true
                            self.baseLevel.score += 500 // Increse score.
                            self.runAction(self.baseLevel.explosionSoundBossAction)
                            self.explosion("Explosion003", _position: firenode.position)
                            self.boss2.removeFromParent()
                        }
                    }
                    
                    if(self.boss2Life <= 0 && self.baseLevel.bossLife <= 0 && self.baseLevel.bossIsSpawned){
                        self.levelOver(true)
                    }
                    
                    for node in bulletArray {
                        node.removeFromParent()
                    }
                    
                })
            }
            
            // Check for collisions betwen boss bullet and player.
            baseLevel.gameplayNode.enumerateChildNodesWithName("bossbullet", usingBlock: { (bossbulletnode, stop: UnsafeMutablePointer) -> Void in
                
                if self.baseLevel.bossLife > 0 && self.boss2Life > 0 {
                    if self.baseLevel.subFighter.intersectsNode(bossbulletnode){
                        bossbulletnode.removeFromParent() // Remove node from parent.
                        self.baseLevel.playerHealth -= GameplayConfigurator.Boss1.bossDamage
                        self.baseLevel.playerHealthLabel.text = "Health: \(self.baseLevel.playerHealth)"
                        if self.baseLevel.playerHealth <= 0 {
                            self.baseLevel.subFighter.removeFromParent()
                            //self.baseLevel.explosionSound_001.play() // Play explosion sound.
                            self.levelOver(false) // Call game over.
                        }
                    }
                }

            })
            
        }
        baseLevel.scoreNode.text = "Score: \(baseLevel.score)" // Write score to display.
    }
    
    func levelOver(playerWin: Bool){
        saveResoult() // Save resoult
        // Show game over label.
        self.addChild(baseLevel.createGameOverLabel(playerWin))
        let waitAction = SKAction.waitForDuration(2)
        let runAction = SKAction.runBlock { () -> Void in
            
            self.baseLevel.mainThemeMusic.stop() // Stop background music.
            
            if playerWin {
                // Go to game over scene.
                let scene = GameOver(fileNamed: "GameOver")!
                scene.scaleMode = .AspectFill
                let transition = SKTransition.doorsOpenHorizontalWithDuration(1)
                self.view?.presentScene(scene, transition: transition)
            } else {
                let scene = MidGameHubScene(_size: CGSize(width: self.frame.width, height: self.frame.height), _score: self.baseLevel.score, isWin: playerWin, _levelName: 4)
                let transition = SKTransition.doorsOpenHorizontalWithDuration(1)
                self.view?.presentScene(scene, transition: transition)
            }
        }
        
        let runGameOverSequence = SKAction.sequence([waitAction, runAction])
        self.runAction(runGameOverSequence)
    }
    
    func saveResoult(){
        // TODO: save resoult.
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
            createSecondBoss()
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
        baseLevel.boss = GameplayCore().boss(CGSize(width: self.frame.width, height: self.frame.height), bossType: 3)
        let turnColor = SKAction.colorizeWithColor(self.baseLevel.handleBossColor(baseLevel.bossLife), colorBlendFactor: 1.0, duration: 0.2)
        self.baseLevel.boss.runAction(turnColor)
        baseLevel.gameplayNode.addChild(baseLevel.boss)
        baseLevel.boss.runAction(SKAction.repeatActionForever(bossAnimationAction))
        repeatAct()
        
        // Create boss healthbar.
        createBossHealthBar()
    }
    
    // Create second boss.
    var boss2 = SKSpriteNode()
    var boss2Life = 20
    var boss2ShootDif = 0
    func createSecondBoss(){
        // Create boss life.
        boss2Life = GameplayConfigurator.Boss.health // Set boss health.
        boss2 = GameplayCore().boss(CGSize(width: self.frame.width, height: self.frame.height), bossType: 3)
        let turnColor = SKAction.colorizeWithColor(self.baseLevel.handleBossColor(boss2Life), colorBlendFactor: 1.0, duration: 0.2)
        boss2.runAction(turnColor)
        baseLevel.gameplayNode.addChild(boss2)
        boss2.runAction(SKAction.repeatActionForever(boss2AnimationAction))
        repeatActSecondBoss()
        
        // Create boss healthbar.
        createBoss2HealthBar()
    }
    
    // Create boss healthbar.
    func createBossHealthBar(){
        baseLevel.healthBar.removeFromParent()
        baseLevel.handleHealthBar()
        baseLevel.healthBar.position = CGPoint(x: 0.0, y: baseLevel.boss.frame.height * 0.6)
        //baseLevel.healthBar.size = CGSize(width: 500, height: 23)
        baseLevel.boss.addChild(baseLevel.healthBar)
    }
    
    // Create boss healthbar.
    func createBoss2HealthBar(){
        baseLevel.healthBarBoss2.removeFromParent()
        baseLevel.handleHealthBarBoss2(boss2Life)
        baseLevel.healthBarBoss2.position = CGPoint(x: 0.0, y: boss2.frame.height * 0.6)
        //baseLevel.healthBarBoss2.size = CGSize(width: 500, height: 23)
        boss2.addChild(baseLevel.healthBarBoss2)
    }
    
    // MARK: - Repeat boss movement.
    func repeatAct(){
        let moveTo = SKAction.moveTo(GameplayCore().bossMovement(CGSize(width: self.frame.width, height: self.frame.height), currentPositin: baseLevel.boss.position), duration: 0.5)
        baseLevel.boss.runAction(moveTo) { () -> Void in
            self.baseLevel.bossShootDif++
            if self.baseLevel.bossShootDif >= 1 {
                self.baseLevel.bossShootDif = 0 // Reset shoot dif.
                self.bossShoot() // Boss shoots bullet.
            }
            self.repeatAct() // Rekurzija.
        }
    }
    
    func repeatActSecondBoss(){
        if let newPosition = GameplayCore().boss2Movement(CGSize(width: self.frame.width, height: self.frame.height), currentPositin: baseLevel.boss.position) {
            
            let moveTo = SKAction.moveTo(newPosition, duration: 1)
            boss2.runAction(moveTo) { () -> Void in
                self.boss2ShootDif++
                if self.boss2ShootDif >= 1 {
                    self.boss2ShootDif = 0 // Reset shoot dif.
                    self.boss2Shoot() // Boss shoots bullet.
                }
                self.repeatActSecondBoss() // Rekurzija.
            }
        } else { // Do nothing
            boss2.runAction(SKAction.waitForDuration(1.0))
            repeatActSecondBoss()
        }
    }
    
    // MARK: - Boss bullet.
    func bossShoot(){
        let (bullet, action) = GameplayCore().bossShoot(CGSize(width: self.frame.width, height: self.frame.height), position: baseLevel.boss.position)
        baseLevel.gameplayNode.addChild(bullet)
        bullet.runAction(action)
    }
    
    func boss2Shoot(){
        let (bullet, action) = GameplayCore().bossShoot(CGSize(width: self.frame.width, height: self.frame.height), position: boss2.position)
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
        baseLevel.mainThemeMusic.stop() // Stop background music.
    }
}

