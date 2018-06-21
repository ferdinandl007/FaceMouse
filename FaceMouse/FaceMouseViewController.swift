//
//  FaceMouseViewController.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 17.06.18.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import Cocoa
import Foundation
import AVFoundation

class FaceMouseViewController: NSViewController {


    @IBOutlet weak var sensitivitySlider: NSSlider!
    @IBOutlet weak var speedSlider: NSSlider!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var buttonText: NSButton!
    private var timer: Timer!
    
    
    

    
    let  camara = Camara(frame: CGRect(x: 0, y: 0, width: 640.0, height: 360))
    var hasFaceTracking = true
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        camara.setSpeed(sensitivityint: getSensitivity(), speed: getSpeed())
        speedSlider.integerValue = getSpeed()
        sensitivitySlider.floatValue = 5 - getSensitivity()
        label.stringValue = "when pressing the start button try to look in the centre of the screen for about 4 seconds"
    }
    


    
    @IBAction func sensitivitySliderAction(_ sender: Any) {
        let value =  sensitivitySlider.floatValue
        defaults.set(value, forKey: "Sensitivity")
        camara.setSpeed(sensitivityint: 5 - value, speed: speedSlider.integerValue)
        print(value)

    }
    @IBAction func speedSliderAction(_ sender: Any){
        let value = speedSlider.integerValue
        camara.setSpeed(sensitivityint: sensitivitySlider.floatValue, speed: value)
        defaults.set(value, forKey: "Speed")

    
    }
    @IBAction func quitButton(_ sender: Any) {
        NSApplication.shared.terminate(self)
    
    }
    @IBAction func button(_ sender: Any) {
        if hasFaceTracking {
            var cunt = 4
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                if cunt < 1{
                self.label.stringValue = "We are already to go! Move you ahead to move. For left click smile for  double click close your left eye and smile."
                self.timer.invalidate()
                } else {
                    self.label.stringValue = "calibration is in progress Try  to keep your head still for  another \(cunt) Seconds"
                    cunt -= 1
                }
            })
            self.camara.faceTracking(yes: true)
            self.buttonText.title = "Stop"
            self.hasFaceTracking = false
            
        
        } else {
            
            camara.faceTracking(yes: false)
            hasFaceTracking = true
            buttonText.title = "Start"
            label.stringValue = "when pressing the start button try to look in the centre of the screen for about 4 seconds"
        }
        
    }
    
}

extension FaceMouseViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> FaceMouseViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "FaceMouseViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? FaceMouseViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    func getSpeed() -> Int {
        if let session = UserDefaults.standard.value(forKey: "Speed") as? Int {
            return session
        } else {
            return 40
        }
    }
    
    func getSensitivity() -> Float {
        if let session = UserDefaults.standard.value(forKey: "sensitivity") as? Float {
            return session
        } else {
            return 2.0
        }
    }
}
