//
//  experamet.swift
//  FaceMouse
//
//  Created by ferdinand on 8/31/18.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.


//        var screenCentre = CGPoint()
//
//        if let screen = NSScreen.main { screenCentre = CGPoint(x: screen.frame.width / 2, y: screen.frame.height / 2) } else { return }
//
//
//        guard let screen = NSScreen.main?.frame else { return }
//
//
//
//        //  determines if the mouse is meant to be moved or to ignore
//        if fabs((trueCentre.x - position.x) / trueCentre.x) > (self.calibrationData[0] * sensitivity) || fabs((trueCentre.y - position.y ) / trueCentre.y) > (self.calibrationData[1] * fabs(sensitivity - 1)) {
//
//            // This calculates the Delta on the face to the true centre  and then  applies a corresponding vector to the mouse.
//
//            let sckalX = screen.maxX / 10
//            let sckalY = screen.maxY / 10
//            let new = CGPoint(x: screenCentre.x + ((trueCentre.x - position.x) * 5 ) , y: screenCentre.y + ((trueCentre.y - position.y) * 5 ) )
//
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
//                let c = CGEvent.init(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: mouseLocation, mouseButton: .left)
//                c?.post(tap: .cgSessionEventTap )
//            }
//        }
