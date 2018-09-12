//
//  TutorialsView.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 04/09/2018.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//


import SpriteKit
import Cocoa
import CoreGraphics
import Vision
import SpriteKit
import GameplayKit


class TutorialsView: NSViewController {


    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var sView: NSView!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var speed: NSSlider!
    @IBOutlet weak var sensitivity: NSSlider!
    @IBOutlet weak var selection: NSPopUpButton!
    let defaults = UserDefaults()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
           setUpslatschens()
            sView.backgroundColor = NSColor.white
            sView.layer?.cornerRadius = 30
            sView.layer?.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
            sView.layer?.shadowRadius = 20
        
        // Get the SKScene from the loaded GKScene
        if let scene = GKScene(fileNamed: "Scene") {
            
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
        }
    }
    
    

    
    func setUpslatschens() {
        speed.integerValue = getSpeed()
        sensitivity.floatValue = getSensitivity()
        selection.selectItem(at: getSelection())
        
    }
    @IBAction func laftButton(_ sender: Any) {
        
    }
    
    @IBAction func reitBButton(_ sender: Any) {
        
    }
    @IBAction func selectionButton(_ sender: Any){
        defaults.set(selection.indexOfSelectedItem, forKey: "selection")
    }
    
    @IBAction func senSlider(_ sender: Any) {
         let value =  sensitivity.floatValue
         defaults.set(value, forKey: "sensitivity")
    }
    @IBAction func speedSlider(_ sender: Any) {
        let value = speed.integerValue
        defaults.set(value, forKey: "Speed")
    }
    
    override func viewWillAppear() {
       
    }
    
}




