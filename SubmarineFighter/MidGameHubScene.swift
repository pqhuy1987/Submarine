//
//  MidGameHubScene.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 10/4/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit
import AVFoundation

class MidGameHubScene: SKScene {
    
    let score: Int
    let win: Bool
    let levelName: Int
    
    // iVars.
    var title = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var nextLevelButton = SKSpriteNode()
    var startSceneButton = SKSpriteNode()
    var touchButton = SKLabelNode()
    var backToMainMenuLabel = SKLabelNode()
    
    // Background music player.
    var backgroundMusic = AVAudioPlayer()
    
    init(_size: CGSize, _score: Int, isWin: Bool, _levelName: Int){
        self.win = isWin
        self.score = _score
        self.levelName = _levelName
        super.init(size: _size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented!")
    }
    
    override func didMoveToView(view: SKView) {
        setBackground() // Set background.
        setLabel() // Set label.
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("setupBackgroundMusic"), userInfo: nil, repeats: false)
        
        // Set background music.
        //setupBackgroundMusic()
    }
    
    func setBackground(){
        let background = GameplayCore().staticBackground(CGSize(width: self.size.width, height: self.size.height), backgroundImageName: "ozadje")
        background.zPosition = 0
        addChild(background)
    }
    
    func setLabel(){
        var labelTitle = String()
        
        if win {
            labelTitle = "You finished level \(levelName)"
        } else {
            labelTitle = "Game Over. You lost on level \(levelName)"
        }
        
        title = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        title.text = labelTitle
        title.fontColor = SKColor.whiteColor()
        title.fontSize = 80
        title.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5 + 100)
        title.zPosition = 10
        addChild(title)
        
        // 4. Score label setup.
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.text = "Your score: \(score)"
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.fontSize = 80
        scoreLabel.position = CGPoint (x: title.position.x, y: title.position.y - 100)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // 5. Button to next scene.
        nextLevelButton = SKSpriteNode(texture: nil, color: SKColor.greenColor(), size: CGSize(width: 800, height: 200))
        nextLevelButton.position = CGPoint(x: title.position.x, y: scoreLabel
            .position.y - 200)
        nextLevelButton.zPosition = 10
        addChild(nextLevelButton)
        
        
        // 6. Button text.
        touchButton = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        touchButton.text = "Next level"
        touchButton.fontColor = SKColor.whiteColor()
        touchButton.fontSize = 70
        //touchButton.position = CGPoint(x: nextLevelButton.position.x, y: nextLevelButton.frame.midY - 20)
        touchButton.position = CGPointZero
        touchButton.verticalAlignmentMode = .Center
        touchButton.zPosition = 20
        nextLevelButton.addChild(touchButton)
        
        // 7. Button to start menu scene.
        startSceneButton = SKSpriteNode(texture: nil, color: SKColor.redColor(), size: CGSize(width: 800, height: 200))
        startSceneButton.position = CGPoint(x: title.position.x, y: nextLevelButton.position.y - 300)
        startSceneButton.zPosition = 10
        addChild(startSceneButton)
        
        // 6. Back to main menu button label.
        backToMainMenuLabel = SKLabelNode(fontNamed:"Optima-ExtraBlack");
        backToMainMenuLabel.text = "Return to start menu"
        backToMainMenuLabel.fontColor = SKColor.whiteColor()
        backToMainMenuLabel.fontSize = 70
        backToMainMenuLabel.position = CGPointZero
        backToMainMenuLabel.verticalAlignmentMode = .Center
        //backToMainMenuLabel.position = CGPoint(x: title.position.x, y: touchButton.position.y - 150)
        backToMainMenuLabel.zPosition = 1
        startSceneButton.addChild(backToMainMenuLabel)

    }
    
    func setupBackgroundMusic() {
        
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("menu", withExtension: "mp3")
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOfURL: backgroundMusicURL!)
        } catch _{
            print("Error setting background music")
        }
        
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 0.55
        backgroundMusic.prepareToPlay()
        backgroundMusic.play()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        var location = CGPoint()
        
        for touch in touches {
            location = touch.locationInNode(self)
        }
        
        if CGRectContainsPoint(nextLevelButton.frame, location){
            backgroundMusic.stop() // Stop background music.
            // Go to next level.
            if win {
                let nextLevel = levelName + 1
                goToNext(nextLevel)
            } else {
                goToNext(1) // Restart game.
            }

        } else if CGRectContainsPoint(startSceneButton.frame, location){
            // Go back to main menu.
            backgroundMusic.stop() // Stop background music.
            let scene = StartScene(fileNamed: "StartScene")
            scene!.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(1)
            self.view?.presentScene(scene!, transition: transition)
        }
        
        
        
    }
    
    func goToNext(currentLevel: Int){
        var scene = SKScene()
        
        switch(currentLevel){
        case 1 :
            scene = Level1Scene(_size: CGSize(width: self.frame.width, height: self.frame.height))
        case 2:
            scene = Level2Scene(_size: CGSize(width: self.frame.width, height: self.frame.height), _previusScore: score)
        case 3:
            scene = Level3Scene(_size: CGSize(width: self.frame.width, height: self.frame.height), _previusScore: score)
        case 4:
            scene = Level4Scene(_size: CGSize(width: self.frame.width, height: self.frame.height), _previusScore: score)
        case 5:
            // Game over scene.
            scene = GameOver(fileNamed: "GameOver")!
        default:
            scene = StartScene(fileNamed: "StartScene")!
            break
        }
        
        scene.scaleMode = .AspectFill
        
        let transition = SKTransition.crossFadeWithDuration(1)
        
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func willMoveFromView(view: SKView) {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
}
