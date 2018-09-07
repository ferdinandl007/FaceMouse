//
//  TutorialsView.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 04/09/2018.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//


import SpriteKit
import Cocoa
import AVFoundation
import CoreGraphics
import Vision

class TutorialsView: NSViewController {


    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var sView: NSView!
    @IBOutlet weak var label: NSTextField!
    
    
    let visage = Visage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            visage.delegate = self
        
           visage.beginFaceDetection()
            sView.backgroundColor = NSColor.white
            sView.layer?.cornerRadius = 30
            sView.layer?.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        // Get the SKScene from the loaded GKScene
             let sceneNode = Scene()
                
                // Copy gameplay related content over to the scene
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.sceneView {
                    view.presentScene(sceneNode)
    
                    view.ignoresSiblingOrder = false
                    view.showsFPS = false
                    view.showsNodeCount = false
                
            

        // Do view setup here.
    }
}
    
    

    
    override func viewWillAppear() {
       
    }
    
}

extension TutorialsView: VisageDelegate {
    func EyeDidClosed(faceFeature: CIFaceFeature) {
        
    }
    
    
    func mouseDidMove(position: CGPoint) {
        visage.mouseWillMoveTo(position: position)
    }
    
    func faceDidSmile(faceFeature: CIFaceFeature) {
        print(faceFeature.hasSmile)
    }
    
    

    
    
}
