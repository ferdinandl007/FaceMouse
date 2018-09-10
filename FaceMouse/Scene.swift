//
//  scene.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 04/09/2018.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import Cocoa
import SpriteKit

class Scene: SKScene , VisageDelegate {
    
    var mouseNode = SKSpriteNode(imageNamed: "mouse")
    var mouseLocation = CGPoint()
    var ispause = false
   // var visage = Visage()
    
    var rect = CGRect()
    override func didMove(to view: SKView) {
        
       // visage.delegate = self
        //visage.beginFaceDetection()
        self.backgroundColor = NSColor(red: 247 / 255, green: 80 / 255, blue: 101 / 255, alpha: 1)
        mouseLocation = CGPoint(x: (self.view?.frame.width)! / 2 , y: (self.view?.frame.height)! / 2)
        
        setUpNode()
        
        
    }
    
    
    func setUpNode() {
        mouseNode = self.childNode(withName: "mause") as! SKSpriteNode
        
        
      
    }
    
    
    
    
    func mouseDidMove(position: CGPoint) {
//        if fabs((visage.trueCentre.x - position.x) / visage.trueCentre.x) > (visage.calibrationData[0] * visage.sensitivity) || fabs((visage.trueCentre.y - position.y ) / visage.trueCentre.y) > (visage.calibrationData[1] * fabs(visage.sensitivity - 1)) {
//
//            // This calculates the Delta on the face to the true centre  and then  applies a corresponding vector to the mouse.
//            let new = CGPoint(x: mouseLocation.x + (((visage.trueCentre.x - position.x) / visage.trueCentre.x) * visage.speed), y: mouseLocation.y + ((visage.trueCentre.y - position.y) / visage.trueCentre.y) * visage.speed)
//
//            print(new)
//
//            // checking your ex compliment is out of reach of display
//            if new.x > 0 && new.x < rect.maxX  {
//                mouseLocation.x = new.x
//            }
//            // checking why component is out of reach of display
//            if new.y > 0 && new.y < rect.maxY  {
//                mouseLocation.y = new.y
//            }
//
//            if !ispause {
//                mouseNode.position = mouseLocation
//            }
//        }
//
        print("dsd")
    }
    
    func faceDidSmile(faceFeature: CIFaceFeature) {
        
    }
    
    func eyeDidClosed(faceFeature: CIFaceFeature) {
        
    }
    

    override func sceneDidLoad() {
        print("yasss")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
