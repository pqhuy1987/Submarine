//
//  GameViewController.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 10/11/15.
//  Copyright (c) 2015 devsonmars. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = StartScene(_size: self.view.frame.size)
//        let skView = self.view as! SKView
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .AspectFill
//        skView.presentScene(scene)
        
        if let scene = StartScene(fileNamed: "StartScene"){
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.ignoresSiblingOrder = true
            
            // Present scene.
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
