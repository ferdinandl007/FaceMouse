//
//  FaceMouseViewController.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 17.06.18.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import AVFoundation
import Cocoa
import Foundation

class FaceMouseViewController: NSViewController {
    @IBOutlet var sensitivitySlider: NSSlider!
    @IBOutlet var speedSlider: NSSlider!
    @IBOutlet var label: NSTextField!
    @IBOutlet var buttonText: NSButton!
    @IBOutlet var click: NSButton!
    private var timer: Timer!
    @IBOutlet var selection: NSPopUpButton!

    let camara = Camara(frame: CGRect(x: 0, y: 0, width: 640.0, height: 360))
    var hasFaceTracking = true

    let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        camara.setSpeed(sensitivityint: 5 - getSensitivity(), speed: getSpeed())
        speedSlider.integerValue = getSpeed()
        sensitivitySlider.floatValue = getSensitivity()
        selection.selectItem(at: getSelection())

        label.stringValue = "When pressing the start button try to look in the centre of the screen for about 4 seconds"
        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "bob"), sender: nil)
    }

    @IBAction func clickButton(_: Any) {
        camara.setCanClick(click: Bool(truncating: click.state.rawValue as NSNumber))
        defaults.set(Bool(truncating: click.state.rawValue as NSNumber), forKey: "clickButton")
    }

    @IBAction func selectionButton(_: Any) {
        camara.setSelection(select: selection.indexOfSelectedItem)
        defaults.set(selection.indexOfSelectedItem, forKey: "selection")
    }

    @IBAction func sensitivitySliderAction(_: Any) {
        let value = sensitivitySlider.floatValue
        defaults.set(value, forKey: "sensitivity")
        camara.setSpeed(sensitivityint: 5 - value, speed: speedSlider.integerValue)
        print(value)
    }

    @IBAction func speedSliderAction(_: Any) {
        let value = speedSlider.integerValue
        camara.setSpeed(sensitivityint: sensitivitySlider.floatValue, speed: value)
        defaults.set(value, forKey: "Speed")
    }

    @IBAction func quitButton(_: Any) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func button(_: Any) {
        if hasFaceTracking {
            var count = 4
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                if count < 1 {
                    self.label.stringValue = "We are ready to go! Use your head to move the cursor. To left click smile. To ´select´ close your left eye and smile."
                    self.timer.invalidate()
                } else {
                    self.label.stringValue = "calibration is in progress Try  to keep your head still for  another \(count) Seconds"
                    count -= 1
                }
            })
            camara.faceTracking(yes: true)
            buttonText.title = "Stop"
            hasFaceTracking = false
            view.layer?.contents = camara.layer?.contents

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
        // 1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        // 2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "FaceMouseViewController")
        // 3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? FaceMouseViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
