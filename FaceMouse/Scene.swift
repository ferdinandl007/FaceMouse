//
//  scene.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 04/09/2018.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import Cocoa
import SpriteKit

class Scene: SKScene {

    override func didMove(to view: SKView) {
        print("miipp")
    self.scene?.backgroundColor = NSColor(red: 247 / 255, green: 80 / 255, blue: 101 / 255, alpha: 1)
    }
    
    override func sceneDidLoad() {
        print("yasss")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
