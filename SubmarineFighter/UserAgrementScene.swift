//
//  UserAgrementScene.swift
//  SubmarineFighter
//
//  Created by Boris Filipović on 11/29/15.
//  Copyright © 2015 devsonmars. All rights reserved.
//

import SpriteKit

class UserAgrementScene: SKScene {
    // Do something here.
    
    override func didMoveToView(view: SKView) {
        let textFieldFrame = CGRectMake((self.view?.frame.midX)!, (self.view?.frame.midY)!, 600, 500)
        let uiTextField = UITextField(frame: textFieldFrame)
        uiTextField.text = "By playing this game, user agreest thah creators (devsonmars) are not responsible for any healt, financial or hardware issues while playing this ( Submarine Fighter)"
        uiTextField.font?.fontWithSize(50)
        //self.addChild(uiTextField)
    }
}
