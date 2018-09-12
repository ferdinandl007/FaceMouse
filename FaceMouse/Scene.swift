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
    var label = SKLabelNode()
    var mouseLocation = CGPoint()
    var ispause = false
    var visage = Visage()
    var lastSmile: Date?
    var lastRightEyeBlink: Date?
    var rect = CGRect()
    var click = false
    var count = 0
    
    
    override func didMove(to view: SKView) {
        
        visage.delegate = self
        self.backgroundColor = NSColor(red: 247 / 255, green: 80 / 255, blue: 101 / 255, alpha: 1)
        rect = (scene?.frame)!
        mouseLocation = CGPoint(x: 0, y: 0)
        setUpNode()
        
    }
    
    
    func setUpNode() {
        mouseNode = self.childNode(withName: "mause") as! SKSpriteNode
        label = self.childNode(withName: "label") as! SKLabelNode
        label.text = "\(count)/10"
        mouseNode.zPosition = 10
        mouseNode.isHidden = true
        label.isHidden = true
        
    }
    
    
    public func setSpeed(sensitivityint: Float,speed: Int) {
        visage.setSensitivity(sensitivityint: sensitivityint, speeds: speed)
    }
    
    public func setCanClick(click: Bool){
        visage.setCanClick(click: click)
    }
    
    public func setSelection(select: Int) {
        visage.setSelection(select: select)
    }
    
    
    
    func makeBols(){
        let node = SKSpriteNode(imageNamed: "Oval")
        node.name = UUID().uuidString
        node.position = CGPoint().getRandom(rect: (self.scene!.frame))
        node.size = CGSize(width: 50, height: 50)
        node.zPosition = 1
        self.addChild(node)
    }
    
    
    
    
    
    func mouseDidMove(position: CGPoint) {
        if fabs((visage.trueCentre.x - position.x) / visage.trueCentre.x) > (visage.calibrationData[0] * visage.sensitivity) || fabs((visage.trueCentre.y - position.y ) / visage.trueCentre.y) > (visage.calibrationData[1] * fabs(visage.sensitivity - 1)) {

            // This calculates the Delta on the face to the true centre  and then  applies a corresponding vector to the mouse.
            let new = CGPoint(x: mouseLocation.x + (((visage.trueCentre.x - position.x) / visage.trueCentre.x) * visage.speed), y: mouseLocation.y - ((visage.trueCentre.y - position.y) / visage.trueCentre.y) * visage.speed)


            // checking your ex compliment is out of reach of display
            if new.x > rect.minX && new.x < rect.maxX  {
                mouseLocation.x = new.x
            }
            // checking why component is out of reach of display
            if new.y > (rect.minY + 100) && new.y < (rect.maxY - 10)  {
                mouseLocation.y = new.y
            }

            if !ispause {
                mouseNode.position = mouseLocation
            }
        }
    }
    

    func faceDidSmile(faceFeature: CIFaceFeature) {
        
        if faceFeature.hasSmile  {
            if lastSmile == nil {
                lastSmile = Date()
            }
            
            if visage.time(time: lastSmile, delay: 0.3) {
                lastSmile = Date()
                print("click")
                click = true
            }
            
        } else {
            lastSmile = nil
            click = false
        }
    }
    
    func eyeDidClosed(faceFeature: CIFaceFeature) {
        
        if faceFeature.rightEyeClosed && !faceFeature.leftEyeClosed {
            if lastRightEyeBlink == nil {
                lastRightEyeBlink = Date()
            }
            lastRightEyeBlink = nil
            if visage.time(time: lastRightEyeBlink, delay: 0.3) {
                lastRightEyeBlink = Date()

                print("click")
                click = true
            }
            
            
        } else {
            lastRightEyeBlink = nil
            click = false
        }
    }
    

    override func sceneDidLoad() {
        UserDefaults().set(false, forKey: "hasState")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if UserDefaults.standard.bool(forKey: "hasState") {
            visage.beginFaceDetection()
        }
        
        // Called before each frame is rendered
        guard var children =  scene?.children else { return }
        children.remove(at: 0)
        for i in children {
            if mouseNode.intersects(i) {
                if click {
                    scene?.removeChildren(in: [i])
                    makeBols()
                    count += 1
                    label.text = "\(count)/10"
                    if count >= 10 {
                        visage.endFaceDetection()
                    }
                    
                }
            }
        }
        visage.setSelection(select: getSelection())
        visage.setSensitivity(sensitivityint: getSensitivity(), speeds: getSpeed())
        
    }
    
    
    
    
    
}
