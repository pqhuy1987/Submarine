//
//  GameOver.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 11/28/15.
//  Copyright © 2015 devsonmars. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameOver: SKScene {
    
    // Buttons.
    var restartButton = SKSpriteNode()
    var backToMainMenu = SKSpriteNode()
    
    // Main theme music.
    var mainThemeMusic = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        restartButton = self.childNodeWithName("restartButton") as! SKSpriteNode
        backToMainMenu = self.childNodeWithName("openMainMenuButton") as! SKSpriteNode
        
        playSounds() // Play wining sound. Hurrray.
        
        //NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("playSounds"), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location = CGPoint()
        
        for touch in touches {
            location = touch.locationInNode(self)
        }
        
        if CGRectContainsPoint(restartButton.frame, location){
            print("restart tačed :)")
            let scene = Level1Scene(_size: CGSize(width: 2048, height: 1536))
            scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(1)
            self.view?.presentScene(scene, transition: transition)
        } else if CGRectContainsPoint(backToMainMenu.frame, location){
            print("backto main menu tačed :)")
            let scene = StartScene(fileNamed: "StartScene")
            scene!.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(1)
            self.view?.presentScene(scene!, transition: transition)
        }
    }
    
    func playSounds(){
        let url: NSURL = NSBundle.mainBundle().URLForResource("win", withExtension: "mp3")!
        
        do {
            mainThemeMusic = try AVAudioPlayer(contentsOfURL: url)
        } catch _ {
            print("Error loading background music")
        }
        
        mainThemeMusic.volume = 0.85
        mainThemeMusic.prepareToPlay()
        mainThemeMusic.play()
    }
    
}
