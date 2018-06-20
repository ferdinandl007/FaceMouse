//
//  Visage.swift
//  FaceMouse
//
//  Created by Ferdinand Lösch on 17.06.18.
//  Copyright © 2018 Ferdinand Lösch. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation
import CoreGraphics
import Vision

public class Visage: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // set up the size of the camera view  and initialise as NSView
    fileprivate var visageCameraView = NSView(frame: NSRect(x: 0.0, y: 0.0, width: 640.0, height: 480.0))
    
    // assigning the face detector as a CI detector
    fileprivate var faceDetector : CIDetector?
    
    // assigning videoDataOutputQueue as DispatchQueue which is an optional
    fileprivate var videoDataOutputQueue : DispatchQueue?
    
    // initialising output as a capture video output
    fileprivate var output = AVCaptureVideoDataOutput()
    
    // assigning the camera preview layer
    fileprivate var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    //  initialise  AVCaptureSession
    fileprivate var captureSession : AVCaptureSession = AVCaptureSession()
    
    //  initialise capture layer as CALayer
    fileprivate var captureLayer: CALayer = CALayer()
    
    //  assigning sample buffer
    fileprivate var sampleBuffers: CMSampleBuffer?
    
    // initialising the dispatch Queue used to asynchronously process the face tracking
    fileprivate let dispatchQueue = DispatchQueue(label: "com.wwdc_project_2018")
    
    //  initialising the is user smiling variable to true
    fileprivate var isSmile = true
    
    //   initialising face tracking ends  to false
    fileprivate var  faceTrackingEnds = false
    
    
    fileprivate var mouseDownPos = CGPoint()
    
    fileprivate var speed: CGFloat = 40.0
    
    fileprivate var sensitivity: CGFloat = 3
    
    fileprivate var mousePos = CGPoint()
    
    fileprivate var sens = [CGFloat]()
    
    fileprivate var calX = [CGFloat]()
    fileprivate var calY = [CGFloat]()
    fileprivate var trueCentre = CGPoint()
    
    fileprivate var hasEnded = false
    
    
    //  this method is called when the class is initialised
    override init() {
        super.init()
        
        //  calls the camera set up method
        self.captureSetup()
        
        //   initialising the face detection options as a dictionary
        var faceDetectorOptions : [String : AnyObject]?
        
        //  assigning faceDetectorOptions to set the accuracy high
        faceDetectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyHigh as AnyObject]
        
        // Initialising the CI detector  to detect faces with  options said to high accuracy
        self.faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: faceDetectorOptions)
    }
    
    //  method used to start running the capture session
    public func beginFaceDetection() {
        
        //  this starts the face tracking loop
        self.faceTrackingEnds = false
        // This starts the capture session so the camera will turn on now
        self.captureSession.startRunning()
        //  this starts the face tracking
        self.faceDetection()
    }
    
    // Method to end  the capture session as well as terminate the face tracking loop
    public func endFaceDetection() {
        
        //  this will stop the capture session so the camera will turn off
        self.captureSession.stopRunning()
        
        //  this terminates  the face tracking loop
        self.faceTrackingEnds = true
        
        
        calY = []
        calX = []
        hasEnded = false

    }
    
    //  captures setup method  sets up everything for the life camera view
    fileprivate func captureSetup () {
        
        //  assigns  the capture device input
        var input : AVCaptureDeviceInput
        
        //  devices will represent the media capture devices  present on this machine such as cameras and mics
        let devices : [AVCaptureDevice] = AVCaptureDevice.devices()
        
        // this loop will go through all the different media capture methods on this machine
        for device in devices {
            
            //  here we check if the device can capture video and at a resolution of 640x480
            if device.hasMediaType(AVMediaType.video) && device.supportsSessionPreset(AVCaptureSession.Preset.vga640x480) {
                do {
                    // if yes  we set up the video input
                    input = try AVCaptureDeviceInput(device: device as AVCaptureDevice) as AVCaptureDeviceInput
                    
                    // and add the input to the capture session
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        break
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        //  here we specify the settings we will use to encode the input
        self.output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: Int(kCVPixelFormatType_32BGRA)]
        
        //  this will make sure that late frames will be discarded and will not clog up the frame rate
        self.output.alwaysDiscardsLateVideoFrames = true
        
        //  puts the video encoding on our video output Queue
        self.videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue", attributes: [])
        self.output.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue!)
        
        //  now we add our output to are captureSession
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //   assigning capture layer  to our life video  capture layer
        self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //  makes sure  that visageCameraView  has a layer so we can  later  apply to life video to it
        visageCameraView.wantsLayer = true
        
        //  assigning are life video view to visageCameraView
        visageCameraView.layer = captureLayer
    }
    
    //  this method is called  during every frame
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        
        //  assigning a sample buffer  to the current captured  sample buffer so we can use it later
        self.sampleBuffers = sampleBuffer
    }
    

    fileprivate func allFeatures(sample: CMSampleBuffer) -> [CIFeature]?{
    
        //  casting the sample buffer to CMSampleBuffer and assigning it to pixelBuffer
        //                let pixelBuffer = sample.imageBuffer
        let pixelBuffer = CMSampleBufferGetImageBuffer(sample)
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sample, kCMAttachmentMode_ShouldPropagate)
    
    
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [String : Any]?)
    
        //  setting up the options  for the  CI detector
        let options: [String : Any] = [CIDetectorImageOrientation: 1, CIDetectorSmile: true, CIDetectorEyeBlink: true]
    
        //  assign an instance of CIdetector to allFeatures and initialise with the CIimage as well as the options
        let allFeatures = self.faceDetector?.features(in: ciImage, options: options)
    
        //   if allfeatures is not equal to nil. if yes assign allfeatures to features otherwise return
        return allFeatures
    
    }
    


    fileprivate var  mouseLocation = CGPoint(x: 655.927419354839, y: 655.927419354839)
    
    
    
    
    fileprivate func mouse(position: CGPoint ,faceFeature: CIFaceFeature){
       
        if fabs((trueCentre.x - position.x) / trueCentre.x) > (self.sens[0] * sensitivity) || fabs((trueCentre.y - position.y ) / trueCentre.y) > (self.sens[1] * sensitivity - 1) {
            
            
            mouseLocation = CGPoint(x: mouseLocation.x + ((((trueCentre.x - position.x)) / trueCentre.x) * speed), y: mouseLocation.y + (((trueCentre.y - position.y)) / trueCentre.y) * speed)
        
            let c = CGEvent.init(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: mouseLocation, mouseButton: .left)
            c?.post(tap: .cgSessionEventTap )
            self.mousePos = position
           
        
       }
        

        // Checks if  a smile is equal to  the user's smile 3
        if self.isSmile == faceFeature.hasSmile {
            
            if self.isSmile {
                
                //  set isSmile to false
                self.isSmile = false
            
                self.mouseDownPos = position;
                
                if faceFeature.rightEyeClosed {
                    let x = CGEvent.init(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition:  mouseLocation , mouseButton: .left)
                    
                    x?.setIntegerValueField(.mouseEventClickState, value: 2)
                    x?.post(tap: .cgSessionEventTap )
                    print("Triple Click")
                    
                } else if faceFeature.leftEyeClosed {
                    
                } else {
                    let x = CGEvent.init(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition:  mouseLocation, mouseButton: .left)
                    x?.post(tap: .cgSessionEventTap )
                    self.mouseDownPos = mouseLocation
                }
                
            // otherwise
            } else {
                // sets isSmile to false
                self.isSmile = true
                let x = CGEvent.init(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: mouseLocation, mouseButton: .left)
                x?.post(tap: .cgSessionEventTap )
            }
        }
    }
        
    
 
        
    fileprivate func faceDetection(){
        
        let group = DispatchGroup()
        group.enter()

        // setting up dispatchQueue
        dispatchQueue.async {
            
            //  checking if sample buffer  is equal to nil if not assign its value to sample
            if let sample = self.sampleBuffers {
                
  
                //   if allfeatures is not equal to nil. if yes assign allfeatures to features otherwise return
                guard let features = self.allFeatures(sample: sample) else { return }
                
                // loop to cycle through all features
                for  feature in features {
                    
                    // checks if the feature is a CIFaceFeature if yes assign feature to face feature and go on.
                    if let faceFeature = feature as? CIFaceFeature {
                        
                        
                        if !self.hasEnded {
                            
                            if self.calX.count > 30 {
                                guard let calXMax = self.calX.max() else {return}
                                guard let calXMin = self.calX.min() else {return}
                                guard let calYMax = self.calY.max() else {return}
                                guard let calYMin = self.calY.min() else {return}
                                self.sens.append((calXMax - calXMin) / calXMax)
                                self.sens.append((calYMax - calYMin) / calYMax)
                                print((calYMax - calYMin) / calYMax)

                                self.trueCentre = CGPoint(x: self.calX.average, y: self.calY.average)
                                print("trueCentre = ",self.trueCentre)
                                self.hasEnded = true
                            } else {
                                self.calX.append(faceFeature.mouthPosition.x)
                                self.calY.append(faceFeature.mouthPosition.y)
                                
                                    }
                            } else {
                            self.mouse(position: faceFeature.mouthPosition, faceFeature: faceFeature)
                            }
                    }
                }
            }
            group.leave()
        }
        group.notify(queue: .main) {
            if !self.faceTrackingEnds {
                self.faceDetection()
            }
        }
      
    }
    
    public func setSensitivity(sensitivityint: Int, speeds: Int) {
        speed = CGFloat(speeds)
        
    }
    
    
    
}// end of class


class Camara: NSView {
    
    // initialising the NSView
    fileprivate let camara = NSView()
    
    //  assigning the Visage class to smileRec
    fileprivate var camaraRec: Visage!
    
    // this method gets called when the class is initialised
    override init(frame: CGRect) {
        
        //  gets the size of the frame from the initialiser
        super.init(frame: frame)
        
        //  adds are smileView as a Subview of NSView
        self.addSubview(camara)
        
        //  sets up constraints
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //  initialising the Visage class
        camaraRec = Visage()
        
//        faceTracking(yes: true)
        
        //  gets the  life  view from the visage class
        let cameraView = camaraRec.visageCameraView
        
        //  this will  add our life camera view (cameraView) and will add it as a subview to are class
        self.addSubview(cameraView)
    }
    
     //  starts the camera view and  face tracking
    public func faceTracking(yes: Bool){
        if yes {
            camaraRec.beginFaceDetection()
            print("b")
        } else {
            camaraRec.endFaceDetection()
        }
    }
    
    public func setSpeed(sensitivityint: Int,speed: Int) {
        camaraRec.setSensitivity(sensitivityint: sensitivityint, speeds: speed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

