//
//  TutorialsView.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 04/09/2018.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class TutorialsView: NSViewController {


    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var sView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! Scene? {
                
                // Copy gameplay related content over to the scene
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.sceneView {
                    view.presentScene(sceneNode)
    
                    view.ignoresSiblingOrder = false
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }

        // Do view setup here.
    }
}
    
    
    override func viewWillAppear() {
       
    }
    
}
