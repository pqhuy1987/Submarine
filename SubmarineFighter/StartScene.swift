//
//  StartScene.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 10/11/15.
//  Copyright © 2015 Boris Filipović. All rights reserved.
//

import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    var startGameButton = SKSpriteNode()
    var userAgrementButton = SKSpriteNode()
    var backgroundMusic = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        startGameButton = self.childNodeWithName("startGameButton") as! SKSpriteNode
        userAgrementButton = self.childNodeWithName("userAgrementButton") as! SKSpriteNode
        
        // Set background music.
        setupBackgroundMusic()
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
        
        if CGRectContainsPoint(startGameButton.frame, location){
            backgroundMusic.stop() // Stop bakground music.
            let scene = Level1Scene(_size: CGSize(width: 2048, height: 1536))
            //let scene = Level4Scene(_size: CGSize(width: 2048, height: 1536), _previusScore: 1000)
            let skView = self.view
//            skView!.showsFPS = true
//            skView!.showsNodeCount = true
            skView!.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill // Aspect fill makes the content fill the entire screen.
            let transition = SKTransition.crossFadeWithDuration(1)
            skView!.presentScene(scene, transition: transition)

        } else if CGRectContainsPoint(userAgrementButton.frame, location){
            backgroundMusic.stop() // Stop bakground music.
            print("user agrement toučed:)")
            let scene = UserAgrementScene(fileNamed: "UserAgrementScene")
            scene!.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(1)
            self.view?.presentScene(scene!, transition: transition)
        }

    }
    
    override func willMoveFromView(view: SKView) {
        self.removeAllChildren()
        self.removeAllActions()
    }
}
